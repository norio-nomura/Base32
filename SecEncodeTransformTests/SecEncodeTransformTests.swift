//
//  SecEncodeTransformTests.swift
//  Base32
//
//  Created by 野村 憲男 on 1/25/15.
//  Copyright (c) 2015 Norio Nomura. All rights reserved.
//

import Foundation
import XCTest
import Security

class SecEncodeTransformTests: XCTestCase {
    
    let vectors: [(String,String,String)] = [
        ("", "", ""),
        ("f", "MY======", "CO======"),
        ("fo", "MZXQ====", "CPNG===="),
        ("foo", "MZXW6===", "CPNMU==="),
        ("foob", "MZXW6YQ=", "CPNMUOG="),
        ("fooba", "MZXW6YTB", "CPNMUOJ1"),
        ("foobar", "MZXW6YTBOI======", "CPNMUOJ1E8======"),
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
    
    // MARK: Using SecEncodeTransform
    func test_RFC4648_Encode_UsingSecEncodeTransform() {
        let convertedVectors = self.vectors.map {($0.dataUsingUTF8StringEncoding, $1, $2)}
        self.measureBlock{
            for _ in 0...100 {
                for (test, expect, expectHex) in convertedVectors {
                    let result = TTTBase32EncodedStringFromData(test)
                    XCTAssertEqual(result, expect, "TTTBase32EncodedStringFromData for \(test)")
                }
            }
        }
    }
    
    func test_RFC4648_Decode_UsingSecEncodeTransform() {
        let convertedVectors = self.vectors.map {($0.dataUsingUTF8StringEncoding, $1, $2)}
        self.measureBlock{
            for _ in 0...100 {
                for (expect, test, testHex) in convertedVectors {
                    let result = TTTDataFromBase32EncodedString(test)
                    XCTAssertEqual(result, expect, "TTTDataFromBase32EncodedString for \(test)")
                }
            }
        }
    }
}
