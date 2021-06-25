//
//  NSDecimalNumber+Extension.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/5/1.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

extension NSDecimalNumber {
    /// 根据范例小数点位数格式化
    func formatter(withExample example: NSDecimalNumber) -> NSDecimalNumber {
        let number = example.stringValue.components(separatedBy: ".").last?.count ?? 0
        let roundBankers = NSDecimalNumberHandler(
            roundingMode: .plain,
            scale: Int16(number),
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: false)
        return rounding(accordingToBehavior: roundBankers)
    }
    /// 根据小数位格式化
    func formatter(withDecimalsNumber decimalsNumber: Int16) -> NSDecimalNumber {
        let roundBankers = NSDecimalNumberHandler(
            roundingMode: .plain,
            scale: decimalsNumber,
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: false)
        return rounding(accordingToBehavior: roundBankers)
    }
    /// 根据范例小数点位数格式化
    func stringFormatter(withExample example: NSDecimalNumber) -> String {
        let decimal = formatter(withExample: example)
        var string = decimal.stringValue
        var currentNumber = string.components(separatedBy: ".").last?.count ?? 0
        let exampleNumber = example.stringValue.components(separatedBy: ".").last?.count ?? 0
        if !example.stringValue.contains(".") {
            return string
        }else {
            if !string.contains(".") {
                currentNumber = 0
                string += "."
            }
            for _ in 0..<max(exampleNumber - currentNumber, 0) {
                string += "0"
            }
            return string
        }
    }
    /// 根据小数位格式化
    func stringFormatter(withDecimalsNumber decimalsNumber: Int16) -> String {
        let decimal = formatter(withDecimalsNumber: decimalsNumber)
        var string = decimal.stringValue
        var currentNumber = string.components(separatedBy: ".").last?.count ?? 0
        if !string.contains(".") && decimalsNumber != 0 {
            currentNumber = 0
            string += "."
        }
        for _ in 0..<max(Int(decimalsNumber) - currentNumber, 0) {
            string += "0"
        }
        return string
    }
}
extension NSDecimalNumber {
    func moreThen(_ decimalsNumber: NSDecimalNumber) -> Bool {
        return compare(decimalsNumber) == .orderedDescending
    }
    func lessThen(_ decimalsNumber: NSDecimalNumber) -> Bool {
        return compare(decimalsNumber) == .orderedAscending
    }
}
