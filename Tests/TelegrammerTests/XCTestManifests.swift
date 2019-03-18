import XCTest

extension JobQueueTests {
    static let __allTests = [
        ("testJobQueue_runOnce_correctIntervalValue", testJobQueue_runOnce_correctIntervalValue),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(JobQueueTests.__allTests),
    ]
}
#endif
