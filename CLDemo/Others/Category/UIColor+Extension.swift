//
//  UIColor+Extension.swift
//  CLDemo
//
//  Created by JmoVxia on 2019/12/26.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit

func hexColor(_ hexString: String)  -> UIColor {
    let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
    let scanner = Scanner(string: hexString)
     
    if hexString.hasPrefix("#") {
        scanner.scanLocation = 1
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
    return UIColor.init(red: red, green: green, blue: blue, alpha: 1)
}
extension UIColor {
///返回随机颜色
    class var randomColor:UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    // UIColor -> Hex String
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
         
        let multiplier = CGFloat(255.999999)
         
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
         
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}
