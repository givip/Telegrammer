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

public class Dispatcher {
	
    public let bot: Bot
    public let updateQueue: DispatchQueue
    public let jobsQueue: Worker
    
	public var handlersList: HandlersQueue
    
    public init(bot: Bot, jobsQueue: Worker = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)) {
        self.bot = bot
		self.jobsQueue = jobsQueue
        self.updateQueue = DispatchQueue(label: "Telegrammer Updates Queue",
										 qos: .default,
										 attributes: .concurrent,
										 autoreleaseFrequency: .inherit,
										 target: nil)
		self.handlersList = HandlersQueue()
    }
	
	public func enqueue(updates: [Update]) {
		updates.forEach { (update) in
			updateQueue.async {
				self.submit(update: update)
			}
		}
	}

	private func submit(update: Update) {
		handlersList.handlers(for: update).forEach { (handler) in
			_ = jobsQueue.eventLoop.submit { () -> Void in
				try handler.handle(update: update, dispatcher: self)
			}
		}
	}
}

public extension Dispatcher {
	public func add<T: Handler>(handler: T, to group: HandlerGroup = .zero) {
		self.handlersList.add(handler, to: group)
	}
	
	public func add(errorHandler: ErrorHandler) {
		self.handlersList.add(errorHandler)
	}
	
	public func remove<T: Handler>(handler: T, from group: HandlerGroup) {
		self.handlersList.remove(handler, from: group)
	}
	
	public func remove(errorHandler: ErrorHandler) {
		self.handlersList.remove(errorHandler)
	}
}

extension Dispatcher: HTTPServerResponder {
    public func respond(to request: HTTPRequest, on worker: Worker) -> Future<HTTPResponse> {
        Log.info("""
            \nReceived telegram webhook request
            
            \(request.description)
            
            """)
        return request.body.consumeData(on: worker)
            .flatMap { (data) -> EventLoopFuture<Update> in
                return Future.map(on: worker, { try JSONDecoder().decode(Update.self, from: data) })
            }
            .do { (update) in
                Log.info("Update \(update.updateId) enqueued to handlers")
                self.enqueue(updates: [update])
            }
            .flatMap { (update) -> EventLoopFuture<HTTPResponse> in
                let ok = HTTPResponse(status: .ok)
                Log.info("\nResponding: \(ok.description)")
                return Future.map(on: worker, { ok })
            }
            .catchFlatMap { (error) -> (EventLoopFuture<HTTPResponse>) in
                let bad = HTTPResponse(status: .badRequest)
                Log.info("\nResponding: \(bad.description)")
                Log.error(error.localizedDescription)
                return Future.map(on: worker, { bad })
        }
    }
}
