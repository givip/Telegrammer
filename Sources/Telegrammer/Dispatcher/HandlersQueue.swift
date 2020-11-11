//
//  HandlersQueue.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 08.06.2018.
//

import Foundation

/**
 Sorted by priority Handlers Queue
 queue is thread safe, you can read, add and remove from any threads.
 Note, that operations of adding/removing handlers to/from queue
 will perform after all pending read operations finished
 */
public final class HandlersQueue {

    public var handlers: [HandlerGroup: [Handler]] {
        var handlers: [HandlerGroup: [Handler]] = [:]
        concurrentQueue.sync {
            handlers = _handlers
        }
        return handlers
    }

    private var _handlers: [HandlerGroup: [Handler]] = [:]
    private var _handlersGroup: [[Handler]] = []

    private let concurrentQueue = DispatchQueue(
        label: "TLGRM-HANDLERS-QUEUE",
        attributes: .concurrent
    )
}

public extension HandlersQueue {
    func add(_ handler: Handler, to group: HandlerGroup) {
        concurrentQueue.async(flags: .barrier) {
            if var groupHandlers = self._handlers[group] {
                groupHandlers = groupHandlers.filter( { $0.name != handler.name } )
                groupHandlers.append(handler)
                self._handlers[group] = groupHandlers
            } else {
                self._handlers[group] = [handler]
            }
            self.sortGroups()
        }
    }

    func remove(_ handler: Handler, from group: HandlerGroup) {
        concurrentQueue.async(flags: .barrier) {
            guard var groupHandlers = self._handlers[group] else { return }
            groupHandlers = groupHandlers.filter({ $0.name != handler.name })

            if groupHandlers.isEmpty {
                self._handlers.removeValue(forKey: group)
            } else {
                self._handlers[group] = groupHandlers
            }
            self.sortGroups()
        }
    }

    func next(for update: Update) -> [Handler] {
        var handlers: [Handler] = []
        for group in _handlersGroup {
            concurrentQueue.sync {
                guard let handler = group.first(where: { $0.check(update: update) }) else {
                    return
                }
                handlers.append(handler)
            }
        }
        return handlers
    }
}

private extension HandlersQueue {
    func sortGroups() {
        _handlersGroup = self._handlers
            .keys
            .sorted { $0.id < $1.id }
            .compactMap { _handlers[$0] }
    }
}
