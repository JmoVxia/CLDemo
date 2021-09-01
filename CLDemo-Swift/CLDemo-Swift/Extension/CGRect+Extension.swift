//
//  CGRect+Extension.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/8/16.
//

import Foundation

extension CGRect {
    func containsVisibleRect(_ rect: CGRect) -> Bool {
        let intersection = intersection(rect)
        return (intersection.width > 0 && intersection.height > 0)
    }
}
