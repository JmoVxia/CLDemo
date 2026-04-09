//
//  Data+Extension.swift
//  CL
//
//  Created by Chen JmoVxia on 2021/2/5.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import Foundation

extension Data {
    var bool: Bool {
        int8 == 1
    }

    var int64: Int64 {
        integerValue()
    }

    var int8: Int8 {
        integerValue()
    }

    var int16: Int16 {
        integerValue()
    }

    var int32: Int32 {
        integerValue()
    }

    private func integerValue<T: FixedWidthInteger>() -> T {
        var value: T = 0
        Swift.withUnsafeMutableBytes(of: &value) { (destination: UnsafeMutableRawBufferPointer) in
            _ = copyBytes(to: destination)
        }
        return value
    }
}
