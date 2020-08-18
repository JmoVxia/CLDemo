//
//  UIColor+CLExtension.swift
//  CL
//
//  Created by JmoVxia on 2020/2/25.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

extension UIColor {
    //16进制颜色
    @objc class func hexColor(with string: String, alpha: CGFloat = 1.0) -> UIColor {
        let hexString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
         
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        if hexString.hasPrefix("0x") {
            scanner.scanLocation = 2
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
         
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
         
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
         
        return self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    ///颜色16进制字符串
    @objc func hexString() -> String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        guard getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        if a == 1.0 {
            return String(format: "%0.2X%0.2X%0.2X", UInt(r * 255),UInt(g * 255), UInt(b * 255))
        } else {
            return String(format: "%0.2X%0.2X%0.2X%0.2X", UInt(r * 255), UInt(g * 255), UInt(b * 255), UInt(a * 255))
        }
    }
    ///主题色
    @objc class var themeColor: UIColor {
        return hexColor(with: "2DD178")
    }
    ///随机色
    @objc class var randomColor: UIColor {
        let red = CGFloat(arc4random()%256)/255.0
        let green = CGFloat(arc4random()%256)/255.0
        let blue = CGFloat(arc4random()%256)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
