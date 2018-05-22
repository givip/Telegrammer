//
//  Dispatcher.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 09.04.2018.
//

import NIO
import HeliumLogger
import LoggerAPI
import HTTP

public enum DispatchStatus {
    case success
    case failed
}

public class Dispatcher {
    
    public let bot: Bot
    public let worker: Worker
    public let updateQueue: Worker
    public let jobQueue: Worker
    
    public var handlers: [Int: [Handler]] = [:]
    public var errorHandlers: [ErrorHandlerCallback] = []
    
    public init(bot: Bot,
                updateQueue: Worker = MultiThreadedEventLoopGroup(numThreads: 1),
                jobQueue: Worker = MultiThreadedEventLoopGroup(numThreads: 1),
                workers: Int = 4) {
        self.bot = bot
        self.updateQueue = updateQueue
        self.jobQueue = jobQueue
        self.worker = MultiThreadedEventLoopGroup(numThreads: workers)
    }
    
    public func add(handler: Handler, group: Int = 0) {
        if handlers[group] == nil {
            handlers[group] = [handler]
        } else {
            handlers[group]?.append(handler)
        }
    }
    
    public func add(errorHandler: @escaping ErrorHandlerCallback) {
        errorHandlers.append(errorHandler)
    }
    
    public func remove(handler: Handler, group: Int) {
        //TODO: Implement
    }
    
    public func remove(errorHandler: ErrorHandlerCallback) {
        //TODO: Implement
    }
    
    public func enqueue(updates: [Update]) {
        let groups = Array<Int>(handlers.keys).sorted()
        let sortedGroups = groups.compactMap { handlers[$0] }
        
        for update in updates {
            for group in sortedGroups {
                let handler = group.first { $0.check(update: update) }
                guard let _handler = handler else { continue }
                updateQueue.eventLoop.execute {
                    _handler.handle(update: update, dispatcher: self)
                }
            }
        }
    }
}

extension Dispatcher: HTTPServerResponder {
    public func respond(to request: HTTPRequest, on worker: Worker) -> Future<HTTPResponse> {
        return request.body.consumeData(on: worker)
            .flatMap { (data) -> EventLoopFuture<Update> in
                Log.info(self.logResponse(data))
                return Future.map(on: worker, { try JSONDecoder().decode(Update.self, from: data) })
            }
            .do { (update) in
                self.enqueue(updates: [update])
            }
            .flatMap { (update) -> EventLoopFuture<HTTPResponse> in
                return Future.map(on: worker, { HTTPResponse(status: .ok) })
            }
            .catchFlatMap { (error) -> (EventLoopFuture<HTTPResponse>) in
                Log.error(error.localizedDescription)
                return Future.map(on: worker, { HTTPResponse(status: .badRequest) })
        }
    }
    
    private func logResponse(_ data: Data) -> String {
        guard let json = String(data: data, encoding: .utf8) else {
            return "Occured error while casting HTTPResponse body Data to String"
        }
        return """
        
        Received webhook update
        \(json)
        
        """
    }
}
