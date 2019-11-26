//
//  Dispatcher.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 09.04.2018.
//

import Dispatch
import Foundation
import NIO
import AsyncHTTPClient

/**
 This class dispatches all kinds of updates to its registered handlers.
 It supports handlers for different kinds of data: Updates from Telegram, basic text commands and even arbitrary types.
 */
public class Dispatcher {

    /// Telegram bot instance
    public let bot: Bot
    
    /// Queue in which passes all incoming updates
    public let updateQueue: DispatchQueue
    
    /// Worker which handle updates with appropriate handlers. Uses all available CPU cores by default.
    public let worker: Worker
    
    /// Queue which keep all added handlers and gives appropriates
    public var handlersQueue: HandlersQueue
    
    public init(bot: Bot, worker: Worker = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)) {
        self.bot = bot
        self.worker = worker
        self.updateQueue = DispatchQueue(
            label: "TLGRM-UPDATES-QUEUE",
            qos: .default,
            attributes: .concurrent,
            autoreleaseFrequency: .inherit,
            target: nil
        )
        self.handlersQueue = HandlersQueue()
    }

    
    /**
     Enqueue new updates array to Updates queue

     - Parameters:
     - updates: Array of Telegram updates
     */
    public func enqueue(updates: [Update]) {
        updates.forEach { (update) in
            updateQueue.async {
                self.submit(update: update)
            }
        }
    }
}

public extension Dispatcher {
    /**
     Add new handler to group
     
     - Parameters:
     - handler: Handler to add in `Dispatcher`'s handlers queue
     - group: Group of `Dispatcher`'s handler queue, `zero` group by default
     */
    func add(handler: Handler, to group: HandlerGroup = .zero) {
        self.handlersQueue.add(handler, to: group)
    }

    /**
     Add new error handler to group
     
     - Parameters:
     - handler: Error Handler to add in `Dispatcher`'s handlers queue
     */
    func add(errorHandler: ErrorHandler) {
        self.handlersQueue.add(errorHandler)
    }

    /**
     Remove handler from specific group of `Dispatchers`'s queue
     
     Note: If in one group present more then one handlers with the same name, they both will be deleted
     
     - Parameters:
     - handler: Handler to be removed
     - group: Group from which handlers will be removed
     */
    func remove(handler: Handler, from group: HandlerGroup) {
        self.handlersQueue.remove(handler, from: group)
    }

    /**
     Removes error handler
     
     - Parameters:
     - handler: Handler to be removed
     */
    func remove(errorHandler: ErrorHandler) {
        self.handlersQueue.remove(errorHandler)
    }
}

private extension Dispatcher {
    func submit(update: Update) {
        handlersQueue.next(for: update).forEach { (handler) in
            _ = worker.next().submit { () -> Void in
                try handler.handle(update: update, dispatcher: self)
            }
        }
    }
}

extension Dispatcher {
    public func respond(to request: HTTPClient.Request, on worker: Worker) -> Future<HTTPClient.Response> {
        log.info("""
            \nReceived telegram webhook request
            
            \(request.description)
            
            """)
        guard let body = request.body else {
            return worker.next().submit {
                HTTPClient.Response(
                    host: request.host,
                    status: .badRequest,
                    headers: .empty,
                    body: nil
                )
            }
        }

        body.stream(

        return worker.next()
            .flatSubmit { () -> Future<HTTPClient.Response> in
                let data = body.
                try JSONDecoder().decode(Update.self, from: Data())
        }

        return request.body.consumeData(on: worker)
            .flatMap { (data) -> EventLoopFuture<Update> in
                return Future.map(on: worker, { try JSONDecoder().decode(Update.self, from: data) })
            }
            .do { (update) in
                log.info("Update \(update.updateId) enqueued to handlers")
                self.enqueue(updates: [update])
            }
            .flatMap { (update) -> EventLoopFuture<HTTPResponse> in
                let ok = HTTPResponse(status: .ok)
                log.info("\nResponding: \(ok.description)")
                return Future.map(on: worker, { ok })
            }
            .catchFlatMap { (error) -> (EventLoopFuture<HTTPResponse>) in
                let bad = HTTPResponse(status: .badRequest)
                log.info("\nResponding: \(bad.description)")
                log.error(error.logMessage)
                return Future.map(on: worker, { bad })
        }
    }
}
