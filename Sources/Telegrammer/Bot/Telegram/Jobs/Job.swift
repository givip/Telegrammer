//
//  Job.swift
//  Telegrammer
//
//  Created by Givi on 14/03/2019.
//

import Foundation
import NIO

public protocol Job: Equatable {
    var id: String { get }

    /// Do not call this callback explicitly, use method `run`
    var callback: () throws -> () { get }

    var name: String? { get }
    var enabled: Bool { get }
    var removed: Bool { get }
    var repeateable: Bool { get }

    var startTime: Date { get }
    var interval: TimeAmount { get }
    var days: [Day] { get }

    var context: Any? { get }
    var jobQueue: JobQueue? { get }

    func run(bot: BotProtocol)
    func scheduleRemoval()
}

public extension Job {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == lhs.id
    }
}

public class AnyJob: Job {
    public var id: String { return _id() }

    public var callback: () throws -> () { return _callback() }

    public var name: String? { return _name() }
    public var enabled: Bool { return _enabled() }
    public var removed: Bool { return _removed() }
    public var repeateable: Bool { return _repeateable() }
    public var startTime: Date { return _startTime() }
    public var interval: TimeAmount { return _interval() }
    public var days: [Day] { return _days() }
    public var context: Any? { return _context() }
    public var jobQueue: JobQueue? { return _jobQueue() }

    private var _id: () -> (String)
    private var _callback: () -> (() throws -> ())

    private var _name: () -> (String?)
    private var _enabled: () -> (Bool)
    private var _removed: () -> (Bool)
    private var _repeateable: () -> (Bool)

    private var _startTime: () -> (Date)
    private var _interval: () -> (TimeAmount)
    private var _days: () -> ([Day])

    private var _context: () -> (Any?)
    private var _jobQueue: () -> (JobQueue?)

    private var _run: (BotProtocol) -> ()
    private var _scheduleRemoval: () -> ()

    required init<J: Job>(_ job: J) {
        self._id = { job.id }
        self._callback = { job.callback }

        self._name = { job.name }
        self._enabled = { job.enabled }
        self._removed = { job.removed }
        self._repeateable = { job.repeateable }
        self._startTime = { job.startTime }
        self._interval = { job.interval }
        self._days = { job.days }
        self._context = { job.context }
        self._jobQueue = { job.jobQueue }

        self._run = job.run
        self._scheduleRemoval = job.scheduleRemoval
    }

    public func run(bot: BotProtocol) {
        _run(bot)
    }

    public func scheduleRemoval() {
        _scheduleRemoval()
    }
}
