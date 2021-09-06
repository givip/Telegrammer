//
//  Dispatcher.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 09.04.2018.
//

import Dispatch
import Foundation
import NIO
import Logging
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
 
    private var prevData: Data?

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

    /**
     Enqueue update as ByteBuffer to Updates queue

     - Parameters:
     - bytebuffer: Array of Telegram updates
     */
    public func enqueue(bytebuffer: ByteBuffer) {
        guard let dataArr = bytebuffer.getBytes(at: 0, length: bytebuffer.writerIndex) else {
            return
        }
        let data = Data(dataArr)

        if enqueue(from: data) {
            return
        } else if let prevData = prevData, enqueue(from: prevData + data) {
            return
        } else {
            if prevData != nil {
                prevData?.append(data)
            } else {
                prevData = Data(data)
            }
        }
    }

    private func enqueue(from data: Data) -> Bool {
        if let update = try? JSONDecoder().decode(Update.self, from: data) {
            enqueue(updates: [ update ])
            prevData = nil
            return true
        }
        return false
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
        handlersQueue.add(handler, to: group)
    }

    /**
     Remove handler from specific group of `Dispatchers`'s queue
     
     Note: If in one group present more then one handlers with the same name, they both will be deleted
     
     - Parameters:
     - handler: Handler to be removed
     - group: Group from which handlers will be removed
     */
    func remove(handler: Handler, from group: HandlerGroup) {
        handlersQueue.remove(handler, from: group)
    }
}

private extension Dispatcher {
    func submit(update: Update) {
        handlersQueue.next(for: update).forEach { (handler) in
            worker.next().execute {
                #if compiler(>=5.5)
                if #available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *) {
                    Task {
                        await handler.handle(update: update, dispatcher: self)
                    }
                }
                #else
                handler.handle(update: update, dispatcher: self)
                #endif
            }
        }
    }
}
