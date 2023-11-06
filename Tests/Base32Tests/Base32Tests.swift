//
//  Base32Tests.swift
//  Base32
//
//  Created by 野村 憲男 on 1/24/15.
//
//  Copyright (c) 2015 Norio Nomura
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import XCTest
@testable import Base32

class Base32Tests: XCTestCase {
    
    let vectors: [(String,String,String, String, String)] = [
        ("", "", "", "", ""),
        ("f", "MY======", "MY", "CO======", "CO"),
        ("fo", "MZXQ====", "MZXQ", "CPNG====", "CPNG"),
        ("foo", "MZXW6===","MZXW6", "CPNMU===", "CPNMU"),
        ("foob", "MZXW6YQ=","MZXW6YQ", "CPNMUOG=", "CPNMUOG"),
        ("fooba", "MZXW6YTB","MZXW6YTB", "CPNMUOJ1", "CPNMUOJ1"),
        ("foobar", "MZXW6YTBOI======","MZXW6YTBOI", "CPNMUOJ1E8======", "CPNMUOJ1E8"),
    ]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: https://tools.ietf.org/html/rfc4648
    
    func test_RFC4648_base32Encode() {
        let convertedVectors = self.vectors.map {($0.dataUsingUTF8StringEncoding, $1, $2, $3, $4)}
        self.measure{
            for _ in 0...100 {
                for (test, expect, expectNotPadded, _, _) in convertedVectors {
                    let result = base32Encode(test)
                    XCTAssertEqual(result, expect, "base32Encode for \(test)")
                    
                    let not_padded_result = base32Encode(test, padding: false)
                    XCTAssertEqual(not_padded_result, expectNotPadded, "base32Encode without padding for \(test)")
                }
            }
        }
    }
    
    func test_RFC4648_base32Decode() {
        let convertedVectors = self.vectors.map {($0.dataUsingUTF8StringEncoding, $1, $2, $3, $4)}
        self.measure{
            for _ in 0...100 {
                for (expect, test, not_padded_test, _, _) in convertedVectors {
                    let result = base32DecodeToData(test)
                    XCTAssertEqual(result!, expect, "base32Decode for \(test)")
                    
                    let not_padded_result = base32DecodeToData(not_padded_test)
                    XCTAssertEqual(not_padded_result!, expect, "not padded base32Decode for \(not_padded_test)")
                }
            }
        }
    }
    
    func test_RFC4648_base32HexEncode() {
        let convertedVectors = self.vectors.map {($0.dataUsingUTF8StringEncoding, $1, $2, $3, $4)}
        self.measure{
            for _ in 0...100 {
                for (test, _, _, expectHex, notPaddedexpectHex) in convertedVectors {
                    let resultHex = base32HexEncode(test)
                    XCTAssertEqual(resultHex, expectHex, "base32HexEncode for \(test)")
                    let notPaddedResult = base32HexEncode(test, padding: false)
                    XCTAssertEqual(notPaddedResult, notPaddedexpectHex, "not padded base32HexEncode for \(test)")
                }
            }
        }
    }
    
    func test_RFC4648_base32HexDecode() {
        let convertedVectors = self.vectors.map {($0.dataUsingUTF8StringEncoding, $1, $2, $3, $4)}
        self.measure{
            for _ in 0...100 {
                for (expect, _, _, testHex, notPaddedExpectHex) in convertedVectors {
                    let resultHex = base32HexDecodeToData(testHex)
                    XCTAssertEqual(resultHex!, expect, "base32HexDecode for \(testHex)")
                    let notPaddedResultHex = base32HexDecodeToData(notPaddedExpectHex)
                    XCTAssertEqual(notPaddedResultHex!, expect, "not padded base32HexDecode for \(testHex)")
                }
            }
        }
    }
    
    // MARK: -
    
    func test_base32ExtensionString() {
        self.measure{
            for _ in 0...100 {
                for (test, expect, notPaddedExpect, expectHex, notPaddedHexExpect) in self.vectors {
                    let result = test.base32EncodedString
                    let notPaddedResult = test.base32EncodedStringNoPadding
                    let resultHex = test.base32HexEncodedString
                    let NotPaddedResultHex = test.base32HexEncodedStringNoPadding
                    XCTAssertEqual(result, expect, "\(test).base32EncodedString")
                    XCTAssertEqual(notPaddedResult, notPaddedExpect, "\(test).base32EncodedStringNoPadding")
                    XCTAssertEqual(resultHex, expectHex, "\(test).base32HexEncodedString")
                    XCTAssertEqual(NotPaddedResultHex, notPaddedHexExpect, "\(test).base32HexEncodedStringNoPadding")
                    let decoded = result.base32DecodedString()
                    let notPaddedDecoded = notPaddedResult.base32DecodedString()
                    let decodedHex = resultHex.base32HexDecodedString()
                    let notPaddedDecodedHex = NotPaddedResultHex.base32HexDecodedString()
                    XCTAssertEqual(decoded!, test, "\(result).base32DecodedString()")
                    XCTAssertEqual(notPaddedDecoded!, test, "not padded \(result).base32DecodedString()")
                    XCTAssertEqual(decodedHex!, test, "\(resultHex).base32HexDecodedString()")
                    XCTAssertEqual(notPaddedDecodedHex!, test, "not padded \(resultHex).base32HexDecodedString()")
                }
            }
        }
    }
    
    func test_base32ExtensionData() {
        let dataVectors = vectors.map {
            (
                $0.dataUsingUTF8StringEncoding,
                $1.dataUsingUTF8StringEncoding,
                $2.dataUsingUTF8StringEncoding,
                $3.dataUsingUTF8StringEncoding,
                $4.dataUsingUTF8StringEncoding
            )
        }
        self.measure{
            for _ in 0...100 {
                for (test, expect, _, expectHex, _) in dataVectors {
                    let result = test.base32EncodedData
                    let resultHex = test.base32HexEncodedData
                    XCTAssertEqual(result, expect, "\(test).base32EncodedData")
                    XCTAssertEqual(resultHex, expectHex, "\(test).base32HexEncodedData")
                    let decoded = result.base32DecodedData
                    let decodedHex = resultHex.base32HexDecodedData
                    XCTAssertEqual(decoded!, test, "\(result).base32DecodedData")
                    XCTAssertEqual(decodedHex!, test, "\(resultHex).base32HexDecodedData")
                }
            }
        }
    }
    
    func test_base32ExtensionDataAndString() {
        let dataAndStringVectors = vectors.map {($0.dataUsingUTF8StringEncoding, $1, $2, $3, $4)}
        self.measure{
            for _ in 0...100 {
                for (test, expect, _,  expectHex, _) in dataAndStringVectors {
                    let result = test.base32EncodedString
                    let resultHex = test.base32HexEncodedString
                    XCTAssertEqual(result, expect, "\(test).base32EncodedString")
                    XCTAssertEqual(resultHex, expectHex, "\(test).base32HexEncodedString")
                    let decoded = result.base32DecodedData
                    let decodedHex = resultHex.base32HexDecodedData
                    XCTAssertEqual(decoded!, test, "\(result).base32DecodedData")
                    XCTAssertEqual(decodedHex!, test, "\(resultHex).base32HexDecodedData")
                }
            }
        }
    }
    
    // MARK:
    
    func test_base32DecodeStringAcceptableLengthPatterns() {
        // "=" stripped valid string
        let strippedVectors = vectors.map {
            (
                $0.dataUsingUTF8StringEncoding,
                $1.replacingOccurrences(of: "=", with:""),
                $2.replacingOccurrences(of: "=", with:""),
                $3.replacingOccurrences(of: "=", with:""),
                $4.replacingOccurrences(of: "=", with:"")
            )
        }
        for (expect, test, _, testHex, _) in strippedVectors {
            let result = base32DecodeToData(test)
            let resultHex = base32HexDecodeToData(testHex)
            XCTAssertEqual(result!, expect, "base32Decode for \(test)")
            XCTAssertEqual(resultHex!, expect, "base32HexDecode for \(testHex)")
        }
        
        // invalid length string with padding
        let invalidVectorWithPaddings: [(String,String)] = [
            ("M=======", "C======="),
            ("MYZ=====", "COZ====="),
            ("MZXW6Z==", "CPNMUZ=="),
            ("MZXW6YTBO=======", "CPNMUOJ1E======="),
        ]
        for (test, testHex) in invalidVectorWithPaddings {
            let result = base32DecodeToData(test)
            let resultHex = base32HexDecodeToData(testHex)
            XCTAssertNil(result, "base32Decode for \(test)")
            XCTAssertNil(resultHex, "base32HexDecode for \(test)")
        }
        
        // invalid length string without padding
        let invalidVectorWithoutPaddings = invalidVectorWithPaddings.map {
            (
                $0.replacingOccurrences(of: "=", with:""),
                $1.replacingOccurrences(of: "=", with:"")
            )
        }
        for (test, testHex) in invalidVectorWithoutPaddings {
            let result = base32DecodeToData(test)
            let resultHex = base32HexDecodeToData(testHex)
            XCTAssertNil(result, "base32Decode for \(test)")
            XCTAssertNil(resultHex, "base32HexDecode for \(test)")
        }
    }

    func testBase32Decode() {
        self.measure{
            let b32 = "AY22KLPRBYJXNH6TRM4I3LPBYA======"
            for _ in 0...100 {
                _ = b32.base32DecodedData
            }
        }
    }
}

extension Base32Tests {
    static var allTests: [(String, (Base32Tests) -> () throws -> Void)] {
        return [
            ("test_RFC4648_base32Encode", test_RFC4648_base32Encode),
            ("test_RFC4648_base32Decode", test_RFC4648_base32Decode),
            ("test_RFC4648_base32HexEncode", test_RFC4648_base32HexEncode),
            ("test_RFC4648_base32HexDecode", test_RFC4648_base32HexDecode),
            ("test_base32ExtensionString", test_base32ExtensionString),
            ("test_base32ExtensionData", test_base32ExtensionData),
            ("test_base32ExtensionDataAndString", test_base32ExtensionDataAndString),
            ("test_base32DecodeStringAcceptableLengthPatterns", test_base32DecodeStringAcceptableLengthPatterns),
            ("testBase32Decode", testBase32Decode)
        ]
    }
}
