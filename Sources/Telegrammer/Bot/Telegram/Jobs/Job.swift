//
//  Job.swift
//  Telegrammer
//
//  Created by Givi on 14/03/2019.
//

import Foundation
import NIO

public protocol Job: Equatable {
    associatedtype Context

    var id: String { get }

    /// Do not call this callback explicitly, use method `run`
    var callback: (_ context: Context?) throws -> Void { get }

    var name: String? { get }
    var enabled: Bool { get }
    var scheduledRemoval: Bool { get }

    var startTime: Date { get }
    var interval: TimeAmount { get }

    var context: Context? { get }

    func run(_ bot: BotProtocol) throws
    func scheduleRemoval()
}

public extension Job {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == lhs.id
    }
}

public class AnyJob<C>: Job {
    public typealias Context = C

    public var id: String { return _id() }
    public var callback: (_ context: C?) throws -> Void { return _callback() }
    public var name: String? { return _name() }
    public var enabled: Bool { return _enabled() }
    public var scheduledRemoval: Bool { return _scheduledRemoval() }
    public var startTime: Date { return _startTime() }
    public var interval: TimeAmount { return _interval() }
    public var context: C? { return _context() }

    private var _id: () -> (String)
    private var _callback: () -> ((_ context: C?) throws -> Void)
    private var _name: () -> (String?)
    private var _enabled: () -> (Bool)
    private var _scheduledRemoval: () -> (Bool)
    private var _startTime: () -> (Date)
    private var _interval: () -> (TimeAmount)
    private var _context: () -> (C?)

    private var _run: (BotProtocol) throws -> Void
    private var _scheduleRemoval: () -> Void

    public required init<J: Job>(_ job: J) where J.Context == C {
        self._id = { job.id }
        self._callback = { job.callback }
        self._name = { job.name }
        self._enabled = { job.enabled }
        self._scheduledRemoval = { job.scheduledRemoval }
        self._startTime = { job.startTime }
        self._interval = { job.interval }
        self._context = { job.context }

        self._run = job.run
        self._scheduleRemoval = job.scheduleRemoval
    }

    public func run(_ bot: BotProtocol) throws {
        try _run(bot)
    }

    public func scheduleRemoval() {
        _scheduleRemoval()
    }
}
