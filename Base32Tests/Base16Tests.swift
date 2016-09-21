//
//  Base16Tests.swift
//  Base32
//
//  Created by 野村 憲男 on 2/7/15.
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

class Base16Tests: XCTestCase {

    let vectors: [(String, String)] = [
        ("", ""),
        ("f", "66"),
        ("fo", "666F"),
        ("foo", "666F6F"),
        ("foob", "666F6F62"),
        ("fooba", "666F6F6261"),
        ("foobar", "666F6F626172"),
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

    func test_RFC4648_base16Encode() {
        let convertedVectors = self.vectors.map {($0.dataUsingUTF8StringEncoding, $1)}
        self.measure{
            for _ in 0...100 {
                for (test, expect) in convertedVectors {
                    let result = base16Encode(test)
                    XCTAssertEqual(result, expect, "base16Encode for \(test)")
                }
            }
        }
    }
    
    func test_RFC4648_base16Decode() {
        let convertedVectors = self.vectors.map {($0.dataUsingUTF8StringEncoding, $1)}
        self.measure{
            for _ in 0...100 {
                for (expect, test) in convertedVectors {
                    let result = base16DecodeToData(test)
                    XCTAssertEqual(result!, expect, "base16Decode for \(test)")
                }
            }
        }
    }
    
    // MARK: -
    
    func test_Base16ExtensionString() {
        self.measure{
            for _ in 0...100 {
                for (test, expect) in self.vectors {
                    let result = test.base16EncodedString
                    XCTAssertEqual(result, expect, "\(test).base16EncodedString")
                    let decoded = result.base16DecodedString()
                    XCTAssertEqual(decoded!, test, "\(result).base16DecodedString()")
                }
            }
        }
    }
    
    func test_Base16ExtensionData() {
        let dataVectors = vectors.map {
            (
                $0.dataUsingUTF8StringEncoding,
                $1.dataUsingUTF8StringEncoding
            )
        }
        self.measure{
            for _ in 0...100 {
                for (test, expect) in dataVectors {
                    let result = test.base16EncodedData
                    XCTAssertEqual(result, expect, "\(test).base16EncodedData")
                    let decoded = result.base16DecodedData
                    XCTAssertEqual(decoded!, test, "\(result).base16DecodedData")
                }
            }
        }
    }
    
    func test_Base16ExtensionDataAndString() {
        let dataAndStringVectors = vectors.map {($0.dataUsingUTF8StringEncoding, $1)}
        self.measure{
            for _ in 0...100 {
                for (test, expect) in dataAndStringVectors {
                    let result = test.base16EncodedString
                    XCTAssertEqual(result, expect, "\(test).base16EncodedString")
                    let decoded = result.base16DecodedData
                    XCTAssertEqual(decoded!, test, "\(result).base16DecodedData")
                }
            }
        }
    }
    
    func test_lowercase() {
        let lowercaseDataString = "abcdef"
        
        let decodedArray = base16Decode(lowercaseDataString)!
        let encodedFromArray = base16Encode(decodedArray, uppercase: false)
        XCTAssertEqual(encodedFromArray, lowercaseDataString)
        
        let decodedData = base16DecodeToData(lowercaseDataString)!
        let encodedFromData = base16Encode(decodedData, uppercase: false)
        XCTAssertEqual(encodedFromData, lowercaseDataString)
    }
}
