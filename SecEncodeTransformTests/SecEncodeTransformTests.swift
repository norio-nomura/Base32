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

public func base32EncodeUsingSecEncodeTransform(data: NSData) -> String {
    var transform = SecEncodeTransformCreate(kSecBase32Encoding, nil)
    SecTransformSetAttribute(transform.takeUnretainedValue(), kSecTransformInputAttributeName, data, nil)
    let encodedData = SecTransformExecute(transform.takeUnretainedValue(), nil) as NSData
    transform.release()
    return NSString(data: encodedData, encoding: NSUTF8StringEncoding) as String
}

public func base32DecodeToDataUsingSecEncodeTransform(string: String) -> NSData? {
    var transform = SecDecodeTransformCreate(kSecBase32Encoding, nil)
    SecTransformSetAttribute(transform.takeUnretainedValue(), kSecTransformInputAttributeName, string.dataUsingEncoding(NSUTF8StringEncoding), nil)
    let decodedData = SecTransformExecute(transform.takeUnretainedValue(), nil) as NSData
    transform.release()
    return decodedData
}

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
        self.measureBlock{
            for _ in 0...100 {
                for (test, expect, expectHex) in self.vectors {
                    let data = test.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
                    let result = base32EncodeUsingSecEncodeTransform(data)
                    XCTAssertEqual(result, expect, "base32EncodeUsingSecEncodeTransform for \(test)")
                }
            }
        }
    }
    
    func test_RFC4648_DecodeUsingSecEncodeTransform() {
        self.measureBlock{
            for _ in 0...100 {
                for (expect, test, testHex) in self.vectors {
                    let data = expect.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                    let result = base32DecodeToDataUsingSecEncodeTransform(test)
                    XCTAssertEqual(result!, data!, "base32DecodeUsingSecEncodeTransform for \(test)")
                }
            }
        }
    }
}
