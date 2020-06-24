//
//  TimeInterval+Extension.swift
//  Potato
//
//  Created by AUG on 2019/12/25.
//

import UIKit

extension TimeInterval {
    ///时分秒
    var hourMinuteSecond: String {
        return String(format:"%d:%02d:%02d", hour, minute, second)
    }
    ///分秒
    var minuteSecond: String {
        return String(format:"%d:%02d", minute, second)
    }
    ///小时
    var hour: Int {
        return Int((self/3600).truncatingRemainder(dividingBy: 60))
    }
    ///分钟
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    ///秒
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    ///毫秒
    var millisecond: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}
