//
//  File.swift
//  
//
//  Created by Givi on 26.11.2019.
//

import NIO
import NIOHTTP1

private final class UpdatesHandler: ChannelInboundHandler {

    public typealias InboundIn = HTTPServerRequestPart
    public typealias OutboundOut = HTTPServerResponsePart

    private enum State {
        case idle
        case waitingForRequestBody
        case sendingResponse

        mutating func requestReceived() {
            precondition(self == .idle, "Invalid state for request received: \(self)")
            self = .waitingForRequestBody
        }

        mutating func requestComplete() {
            precondition(self == .waitingForRequestBody, "Invalid state for request complete: \(self)")
            self = .sendingResponse
        }

        mutating func responseComplete() {
            precondition(self == .sendingResponse, "Invalid state for response complete: \(self)")
            self = .idle
        }
    }

    private var buffer: ByteBuffer! = nil
    private var keepAlive = false
    private var state = State.idle

    private var infoSavedRequestHead: HTTPRequestHead?
    private var infoSavedBodyBytes: Int = 0

    private var continuousCount: Int = 0

    private var handler: ((ChannelHandlerContext, HTTPServerRequestPart) -> Void)?

    private let dispatcher: Dispatcher

    init(dispatcher: Dispatcher) {
        self.dispatcher = dispatcher
    }

    private func completeResponse(
        _ context: ChannelHandlerContext,
        trailers: HTTPHeaders?,
        promise: EventLoopPromise<Void>?
    ) {
        self.state.responseComplete()

        let promise = self.keepAlive ? promise : (promise ?? context.eventLoop.makePromise())
        if !self.keepAlive {
            promise!.futureResult.whenComplete { (_: Result<Void, Error>) in context.close(promise: nil) }
        }
        self.handler = nil

        context.writeAndFlush(self.wrapOutboundOut(.end(trailers)), promise: promise)
    }

    private func httpResponseHead(
        request: HTTPRequestHead,
        status: HTTPResponseStatus,
        headers: HTTPHeaders = HTTPHeaders()
    ) -> HTTPResponseHead {
        var head = HTTPResponseHead(version: request.version, status: status, headers: headers)
        let connectionHeaders: [String] = head.headers[canonicalForm: "connection"].map { $0.lowercased() }

        if !connectionHeaders.contains("keep-alive") && !connectionHeaders.contains("close") {
            // the user hasn't pre-set either 'keep-alive' or 'close', so we might need to add headers
            switch (request.isKeepAlive, request.version.major, request.version.minor) {
            case (true, 1, 0):
                // HTTP/1.0 and the request has 'Connection: keep-alive', we should mirror that
                head.headers.add(name: "Connection", value: "keep-alive")
            case (false, 1, let n) where n >= 1:
                // HTTP/1.1 (or treated as such) and the request has 'Connection: close', we should mirror that
                head.headers.add(name: "Connection", value: "close")
            default:
                // we should match the default or are dealing with some HTTP that we don't support, let's leave as is
                ()
            }
        }
        return head
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let reqPart = self.unwrapInboundIn(data)
        if let handler = self.handler {
            handler(context, reqPart)
            return
        }

        switch reqPart {
        case .head(let request):
            self.keepAlive = request.isKeepAlive
            self.state.requestReceived()

            var responseHead = httpResponseHead(
                request: request,
                status: HTTPResponseStatus.ok
            )

            self.buffer.clear()
            responseHead.headers.add(name: "content-length", value: "\(self.buffer!.readableBytes)")
            let response = HTTPServerResponsePart.head(responseHead)
            context.write(self.wrapOutboundOut(response), promise: nil)
        case .body(let bytes):
            dispatcher.enqueue(bytebuffer: bytes)
        case .end:
            self.state.requestComplete()
            let content = HTTPServerResponsePart.body(.byteBuffer(buffer!.slice()))
            context.write(self.wrapOutboundOut(content), promise: nil)
            self.completeResponse(context, trailers: nil, promise: nil)
        }
    }

    func channelReadComplete(context: ChannelHandlerContext) {
        context.flush()
    }

    func handlerAdded(context: ChannelHandlerContext) {
        self.buffer = context.channel.allocator.buffer(capacity: 0)
    }

    func userInboundEventTriggered(context: ChannelHandlerContext, event: Any) {
        switch event {
        case let evt as ChannelEvent where evt == ChannelEvent.inputClosed:
            // The remote peer half-closed the channel. At this time, any
            // outstanding response will now get the channel closed, and
            // if we are idle or waiting for a request body to finish we
            // will close the channel immediately.
            switch self.state {
            case .idle, .waitingForRequestBody:
                context.close(promise: nil)
            case .sendingResponse:
                self.keepAlive = false
            }
        default:
            context.fireUserInboundEventTriggered(event)
        }
    }
}

final class UpdatesServer {
    let host: String
    let port: Int
    var channel: Channel?
    var handler: Dispatcher

    private var group: EventLoopGroup?
    private var socketBootstrap: ServerBootstrap?

    init(host: String, port: Int, handler: Dispatcher) {
        self.host = host
        self.port = port
        self.handler = handler
    }

    func childChannelInitializer(channel: Channel) -> EventLoopFuture<Void> {
        return channel.pipeline
            .configureHTTPServerPipeline(withErrorHandling: true)
            .flatMap {
                channel.pipeline.addHandler(
                    UpdatesHandler(dispatcher: self.handler)
                )
        }
    }

    func start() throws -> Future<Void> {
        group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        socketBootstrap = ServerBootstrap(group: group!)
            // Specify backlog and enable SO_REUSEADDR for the server itself
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)

            // Set the handlers that are applied to the accepted Channels
            .childChannelInitializer(childChannelInitializer)

            // Enable SO_REUSEADDR for the accepted Channels
            .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 1)
            .childChannelOption(ChannelOptions.allowRemoteHalfClosure, value: true)

        let promise = group!.next().makePromise(of: Void.self)

        socketBootstrap!
            .bind(host: host, port: port)
            .whenSuccess { (channel) in
                self.channel = channel
                promise.succeed(())
        }
        return promise.futureResult
    }

    func stop() throws -> Future<Void> {
        guard let channel = channel else {
            throw BotError()
        }
        try group?.syncShutdownGracefully()
        return channel.close()
    }
}
