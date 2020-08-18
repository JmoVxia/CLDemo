//
//  UITextField+CLExtension.swift
//  CL
//
//  Created by JmoVxia on 2020/4/2.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

extension UITextField {
    /// 设置占位文字
    /// - Parameters:
    ///   - string: 字符串
    ///   - color: 颜色
    ///   - font: 字体
    func setPlaceholder(_ string: String, color: UIColor? = nil, font: UIFont? = nil) {
        let attributedString = NSMutableAttributedString(string: string)
        if let color = color {
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: color], range: NSRange(location: 0, length: string.count))
        }
        if let font = font {
            attributedString.addAttributes([NSAttributedString.Key.font: font], range: NSRange(location: 0, length: string.count))
        }
        attributedPlaceholder = attributedString
    }
}
