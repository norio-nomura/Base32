//
//  StringExtension.swift
//  Base32
//
//  Created by 野村 憲男 on 2/7/15.
//  Copyright (c) 2015 Norio Nomura. All rights reserved.
//

import Foundation

// MARK: - private

extension String {
    /// NSData never nil
    internal var dataUsingUTF8StringEncoding: NSData {
        let length = nulTerminatedUTF8.count - 1
        return nulTerminatedUTF8.withUnsafeBufferPointer {
            return NSData(bytes: $0.baseAddress, length: length)
        }
    }
    
    /// Array<UInt8>
    internal var arrayUsingUTF8StringEncoding: [UInt8] {
        let length = nulTerminatedUTF8.count - 1
        return nulTerminatedUTF8.withUnsafeBufferPointer {
            return Array(UnsafeBufferPointer(start: $0.baseAddress, count: length))
        }
    }
}
