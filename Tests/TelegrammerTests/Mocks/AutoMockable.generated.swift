// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif














class FilterMock: Filter {
    var name: String {
        get { return underlyingName }
        set(value) { underlyingName = value }
    }
    var underlyingName: String!

    //MARK: - filter

    var filterMessageCallsCount = 0
    var filterMessageCalled: Bool {
        return filterMessageCallsCount > 0
    }
    var filterMessageReceivedMessage: Message?
    var filterMessageReceivedInvocations: [Message] = []
    var filterMessageReturnValue: Bool!
    var filterMessageClosure: ((Message) -> Bool)?

    func filter(message: Message) -> Bool {
        filterMessageCallsCount += 1
        filterMessageReceivedMessage = message
        filterMessageReceivedInvocations.append(message)
        return filterMessageClosure.map({ $0(message) }) ?? filterMessageReturnValue
    }

}
class HandlerMock: Handler {
    var name: String {
        get { return underlyingName }
        set(value) { underlyingName = value }
    }
    var underlyingName: String!

    //MARK: - check

    var checkUpdateCallsCount = 0
    var checkUpdateCalled: Bool {
        return checkUpdateCallsCount > 0
    }
    var checkUpdateReceivedUpdate: Update?
    var checkUpdateReceivedInvocations: [Update] = []
    var checkUpdateReturnValue: Bool!
    var checkUpdateClosure: ((Update) -> Bool)?

    func check(update: Update) -> Bool {
        checkUpdateCallsCount += 1
        checkUpdateReceivedUpdate = update
        checkUpdateReceivedInvocations.append(update)
        return checkUpdateClosure.map({ $0(update) }) ?? checkUpdateReturnValue
    }

    //MARK: - handle

    var handleUpdateDispatcherCallsCount = 0
    var handleUpdateDispatcherCalled: Bool {
        return handleUpdateDispatcherCallsCount > 0
    }
    var handleUpdateDispatcherReceivedArguments: (update: Update, dispatcher: Dispatcher)?
    var handleUpdateDispatcherReceivedInvocations: [(update: Update, dispatcher: Dispatcher)] = []
    var handleUpdateDispatcherClosure: ((Update, Dispatcher) -> Void)?

    func handle(update: Update, dispatcher: Dispatcher) {
        handleUpdateDispatcherCallsCount += 1
        handleUpdateDispatcherReceivedArguments = (update: update, dispatcher: dispatcher)
        handleUpdateDispatcherReceivedInvocations.append((update: update, dispatcher: dispatcher))
        handleUpdateDispatcherClosure?(update, dispatcher)
    }

}
