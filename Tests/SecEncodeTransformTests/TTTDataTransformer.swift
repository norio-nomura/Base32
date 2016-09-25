//
//  TTTDataTransformer.swift
//  Base32
//
//  Created by 野村 憲男 on 9/25/16.
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
import Security

#if os(macOS)

func TTTBase32EncodedString(from data: Data) -> String? {
    if let transform = SecEncodeTransformCreate(kSecBase32Encoding, nil),
        SecTransformSetAttribute(transform, kSecTransformInputAttributeName, data as NSData, nil),
        let encodedData = SecTransformExecute(transform, nil) as? Data {
        return String.init(data: encodedData, encoding: .utf8)
    }
    return nil
}

func TTTData(fromBase32EncodedString string: String) -> Data? {
    if let data = string.data(using: .utf8) as NSData?,
        let transform = SecDecodeTransformCreate(kSecBase32Encoding, nil),
        SecTransformSetAttribute(transform, kSecTransformInputAttributeName, data, nil),
        let decodedData = SecTransformExecute(transform, nil) as? Data {
        return decodedData
    }
    return nil
}

#endif
