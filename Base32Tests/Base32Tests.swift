//
//  Base32Tests.swift
//  TOTP
//
//  Created by 野村 憲男 on 1/24/15.
//  Copyright (c) 2015 Norio Nomura. All rights reserved.
//

import Foundation
import XCTest
import Base32

class Base32Tests: XCTestCase {
    
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
    
    func test_RFC4648_Encode() {
        self.measureBlock{
            for _ in 0...100 {
                for (test, expect, expectHex) in self.vectors {
                    let data = test.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
                    let result = base32Encode(data)
                    XCTAssertEqual(result, expect, "base32Encode for \(test)")
                }
            }
        }
    }
    
    func test_RFC4648_Decode() {
        self.measureBlock{
            for _ in 0...100 {
                for (expect, test, testHex) in self.vectors {
                    let data = expect.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                    let result = base32DecodeToData(test)
                    XCTAssertEqual(result!, data!, "base32Decode for \(test)")
                }
            }
        }
    }
    
    func test_RFC4648_HexEncode() {
        self.measureBlock{
            for _ in 0...100 {
                for (test, expect, expectHex) in self.vectors {
                    let data = test.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
                    let resultHex = base32HexEncode(data)
                    XCTAssertEqual(resultHex, expectHex, "base32HexEncode for \(test)")
                }
            }
        }
    }
    
    func test_RFC4648_HexDecode() {
        self.measureBlock{
            for _ in 0...100 {
                for (expect, test, testHex) in self.vectors {
                    let data = expect.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                    let resultHex = base32HexDecodeToData(testHex)
                    XCTAssertEqual(resultHex!, data!, "base32HexDecode for \(testHex)")
                }
            }
        }
    }
    
    // MARK: -
    
    func test_ExtensionString() {
        self.measureBlock{
            for _ in 0...100 {
                for (test, expect, expectHex) in self.vectors {
                    let result = test.base32EncodedString
                    let resultHex = test.base32HexEncodedString
                    XCTAssertEqual(result, expect, "\(test).base32EncodedString")
                    XCTAssertEqual(resultHex, expectHex, "\(test).base32HexEncodedString")
                    let decoded = result.base32DecodedString()
                    let decodedHex = resultHex.base32HexDecodedString()
                    XCTAssertEqual(decoded!, test, "\(result).base32DecodedString()")
                    XCTAssertEqual(decodedHex!, test, "\(resultHex).base32HexDecodedString()")
                }
            }
        }
    }
    
    func test_ExtensionData() {
        let dataVectors = vectors.map {
            (
                $0.dataUsingEncoding(NSUTF8StringEncoding)!,
                $1.dataUsingEncoding(NSUTF8StringEncoding)!,
                $2.dataUsingEncoding(NSUTF8StringEncoding)!
            )
        }
        self.measureBlock{
            for _ in 0...100 {
                for (test, expect, expectHex) in dataVectors {
                    let result = test.base32EncodedData
                    let resultHex = test.base32HexEncodedData
                    XCTAssertEqual(result!, expect, "\(test).base32EncodedData")
                    XCTAssertEqual(resultHex!, expectHex, "\(test).base32HexEncodedData")
                    let decoded = result!.base32DecodedData
                    let decodedHex = resultHex!.base32HexDecodedData
                    XCTAssertEqual(decoded!, test, "\(result).base32DecodedData")
                    XCTAssertEqual(decodedHex!, test, "\(resultHex).base32HexDecodedData")
                }
            }
        }
    }
    
    func test_ExtensionDataAndString() {
        let dataAndStringVectors = vectors.map {($0.dataUsingEncoding(NSUTF8StringEncoding)!, $1, $2)}
        self.measureBlock{
            for _ in 0...100 {
                for (test, expect, expectHex) in dataAndStringVectors {
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
    
}
