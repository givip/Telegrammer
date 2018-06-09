//
//  HandlersQueue.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 08.06.2018.
//

import Foundation

/// Sorted by priority Handlers Queue
/// queue is thread safe, you can read, add and remove from any threads.
/// Note, that operations of adding/removing handlers to/from queue
/// will perform after all pending read operations finished
public final class HandlersQueue {
	
	public var handlers: [HandlerGroup: [Handler]] {
		var handlers: [HandlerGroup: [Handler]] = [:]
		concurrentQueue.sync {
			handlers = _handlers
		}
		return handlers
	}
	public var errorHandlers: [ErrorHandler] {
		var errorHandlers: [ErrorHandler] = []
		concurrentQueue.sync {
			errorHandlers = _errorHandlers
		}
		return errorHandlers
	}
	
	private var _handlers: [HandlerGroup: [Handler]] = [:]
	private var _handlersGroup: [[Handler]] = []
	private var _errorHandlers: [ErrorHandler] = []
	
	private let concurrentQueue = DispatchQueue(label: "Telegrammer Handlers Queue", attributes: .concurrent)
	
	public func add<T: Handler>(_ handler: T, to group: HandlerGroup) {
		concurrentQueue.async(flags: .barrier) {
			if var groupHandlers = self._handlers[group] {
				groupHandlers.append(handler)
				self._handlers[group] = groupHandlers
			} else {
				self._handlers[group] = [handler]
			}
			self.sortGroups()
		}
	}
	
	public func remove<T: Handler>(_ handler: T, from group: HandlerGroup) {
		concurrentQueue.async(flags: .barrier) {
			guard var groupHandlers = self._handlers[group] else { return }
            groupHandlers.removeAll(where: { (elem) -> Bool in
                return elem.name == handler.name
            })
			
			if groupHandlers.isEmpty {
				self._handlers.removeValue(forKey: group)
				self.sortGroups()
			} else {
				self._handlers[group] = groupHandlers
			}
		}
	}
	
	public func add(_ errorHandler: ErrorHandler) {
		_errorHandlers.append(errorHandler)
	}
	
	public func remove(_ errorHandler: ErrorHandler) {
        _errorHandlers.removeAll(where: { (elem) -> Bool in
            return elem.name == errorHandler.name
        })
	}
	
	private func sortGroups() {
		_handlersGroup = self._handlers.keys.sorted { $0.id < $1.id }.compactMap { _handlers[$0] }
	}
	
	public func handlers(for update: Update) -> [Handler] {
		var handlers: [Handler] = []
		for group in _handlersGroup {
			concurrentQueue.sync {
				guard let handler = group.first(where: { (handler) -> Bool in
					return handler.check(update: update)
				}) else { return }
				handlers.append(handler)
			}
		}
		return handlers
	}
}
