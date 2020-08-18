//
//  CLScrollComputingValue.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/8/18.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLScrollComputingValue: NSObject {
    private (set) var startValue: CGFloat = 0.0
    private (set) var midValue: CGFloat = 0.0
    private (set) var endValue: CGFloat = 0.0
    private (set) var frontLine: (k: CGFloat, b: CGFloat) = (0, 0)
    private (set) var backLine: (k: CGFloat, b: CGFloat) = (0, 0)
    init(startValue: CGFloat, midValue: CGFloat, endValue: CGFloat) {
        super.init()
        self.startValue = startValue
        self.midValue = midValue
        self.endValue = endValue
        frontLine = (calculateSlope(x1: startValue, y1: 0, x2: midValue, y2: 1), calculateConstant(x1: startValue, y1: 0, x2: midValue, y2: 1))
        backLine = (calculateSlope(x1: midValue, y1: 1, x2: endValue, y2: 0), calculateConstant(x1: midValue, y1: 1, x2: endValue, y2: 0))
    }
    func outputValue(_ inputValue: CGFloat) -> CGFloat {
        if (inputValue <= startValue) {
            return 0
        } else if (inputValue <= midValue) {
            return frontLine.k * inputValue + frontLine.b
        } else if (inputValue <= endValue) {
            return backLine.k * inputValue + backLine.b
        } else {
            return 0
        }
    }
}
private extension CLScrollComputingValue {
    func calculateSlope(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) -> CGFloat {
        return x2 == x1 ? 0 : (y2 - y1) / (x2 - x1)
    }
    func calculateConstant(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) -> CGFloat {
        return x2 == x1 ? 0 : (y1 * (x2 - x1) - x1 * (y2 - y1)) / (x2 - x1)
    }
}
