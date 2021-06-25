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
    @objc class func hex(_ string: String, alpha: CGFloat = 1.0) -> UIColor {
        // 存储转换后的数值
        var red: UInt64 = 0, green: UInt64 = 0, blue: UInt64 = 0
        var hex = string
        // 如果传入的十六进制颜色有前缀，去掉前缀
        if hex.hasPrefix("0x") || hex.hasPrefix("0X") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
        } else if hex.hasPrefix("#") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
        }
        // 如果传入的字符数量不足6位按照后边都为0处理，当然你也可以进行其它操作
        if hex.count < 6 {
            for _ in 0..<6-hex.count {
                hex += "0"
            }
        }

        // 分别进行转换
        // 红
        Scanner(string: String(hex[..<hex.index(hex.startIndex, offsetBy: 2)])).scanHexInt64(&red)
        // 绿
        Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)])).scanHexInt64(&green)
        // 蓝
        Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 4)...])).scanHexInt64(&blue)

        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)

        
    }
    ///颜色16进制字符串
    var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        if a == 1.0 {
            return String(format: "%0.2X%0.2X%0.2X", UInt(r * 255),UInt(g * 255), UInt(b * 255))
        } else {
            return String(format: "%0.2X%0.2X%0.2X%0.2X", UInt(r * 255), UInt(g * 255), UInt(b * 255), UInt(a * 255))
        }
    }
    ///主题色
    @objc class var themeColor: UIColor {
        return hex("2DD178")
    }
    ///随机色
    @objc class var randomColor: UIColor {
        let red = CGFloat(arc4random()%256)/255.0
        let green = CGFloat(arc4random()%256)/255.0
        let blue = CGFloat(arc4random()%256)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 0.35)
    }
    //获取反色(补色)
    var invertColor: UIColor {
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return UIColor(red:1.0-r, green: 1.0-g, blue: 1.0-b, alpha: 1)
    }
}
