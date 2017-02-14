import XCTest

@testable import Base32Tests

XCTMain([
    testCase(Base16Tests.allTests),
    testCase(Base32Tests.allTests),
    testCase(StringExtensionTests.allTests)
    ])
