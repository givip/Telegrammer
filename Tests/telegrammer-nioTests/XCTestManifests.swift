import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(telegrammer_nioTests.allTests),
    ]
}
#endif