import XCTest

import telegrammer_nioTests

var tests = [XCTestCaseEntry]()
tests += telegrammer_nioTests.allTests()
XCTMain(tests)