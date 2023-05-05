//
//  UIColor+Extension.swift
//  CL
//
//  Created by JmoVxia on 2020/2/25.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

extension UIColor {
    /// 颜色16进制字符串
    var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        if a == 1.0 {
            return String(format: "%0.2X%0.2X%0.2X", UInt(r * 255), UInt(g * 255), UInt(b * 255))
        } else {
            return String(format: "%0.2X%0.2X%0.2X%0.2X", UInt(r * 255), UInt(g * 255), UInt(b * 255), UInt(a * 255))
        }
    }

    /// 主题色
    @objc static let theme: UIColor = "#1F70FF".uiColor

    /// 随机色
    static var random: UIColor {
        let red = CGFloat(arc4random() % 256) / 255.0
        let green = CGFloat(arc4random() % 256) / 255.0
        let blue = CGFloat(arc4random() % 256) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 0.35)
    }

    // 获取反色(补色)
    var invertColor: UIColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return UIColor(red: 1.0 - r, green: 1.0 - g, blue: 1.0 - b, alpha: 1)
    }
}

// MARK: - JmoVxia---16进制颜色扩展

extension UIColor {
    private enum ColorType {
        case RGBshort(rgb: String)
        case RGBshortAlpha(rgba: String)
        case RGB(rgb: String)
        case RGBA(rgba: String)

        init?(from hex: String) {
            let hexString: String = if hex.hasPrefix("#") {
                hex.replacingOccurrences(of: "#", with: "")
            } else if hex.hasPrefix("0x") {
                hex.replacingOccurrences(of: "0x", with: "")
            } else {
                hex
            }
            switch hexString.count {
            case 3:
                self = .RGBshort(rgb: hexString)
            case 4:
                self = .RGBshortAlpha(rgba: hexString)
            case 6:
                self = .RGB(rgb: hexString)
            case 8:
                self = .RGBA(rgba: hexString)
            default:
                return nil
            }
        }

        var value: String {
            switch self {
            case let .RGBshort(rgb):
                rgb
            case let .RGBshortAlpha(rgba):
                rgba
            case let .RGB(rgb):
                rgb
            case let .RGBA(rgba):
                rgba
            }
        }

        func components() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
            var hexValue: UInt32 = 0
            guard Scanner(string: value).scanHexInt32(&hexValue) else {
                return nil
            }

            let r, g, b, a, divisor: CGFloat

            switch self {
            case .RGBshort:
                divisor = 15
                r = CGFloat((hexValue & 0xF00) >> 8) / divisor
                g = CGFloat((hexValue & 0x0F0) >> 4) / divisor
                b = CGFloat(hexValue & 0x00F) / divisor
                a = 1
            case .RGBshortAlpha:
                divisor = 15
                r = CGFloat((hexValue & 0xF000) >> 12) / divisor
                g = CGFloat((hexValue & 0x0F00) >> 8) / divisor
                b = CGFloat((hexValue & 0x00F0) >> 4) / divisor
                a = CGFloat(hexValue & 0x000F) / divisor
            case .RGB:
                divisor = 255
                r = CGFloat((hexValue & 0xFF0000) >> 16) / divisor
                g = CGFloat((hexValue & 0x00FF00) >> 8) / divisor
                b = CGFloat(hexValue & 0x0000FF) / divisor
                a = 1
            case .RGBA:
                divisor = 255
                r = CGFloat((hexValue & 0xFF00_0000) >> 24) / divisor
                g = CGFloat((hexValue & 0x00FF_0000) >> 16) / divisor
                b = CGFloat((hexValue & 0x0000_FF00) >> 8) / divisor
                a = CGFloat(hexValue & 0x0000_00FF) / divisor
            }
            return (red: r, green: g, blue: b, alpha: a)
        }
    }

    /// 通过16进制字符串创建颜色
    convenience init(_ hex: String, alpha: CGFloat? = nil) {
        if let hexType = ColorType(from: hex), let components = hexType.components() {
            self.init(red: components.red, green: components.green, blue: components.blue, alpha: alpha ?? components.alpha)
        } else {
            self.init(white: 0, alpha: 0)
        }
    }
}

// MARK: - JmoVxia---字符串颜色支持

extension String {
    var uiColor: UIColor {
        .init(self)
    }

    var cgColor: CGColor {
        uiColor.cgColor
    }
}

// MARK: - JmoVxia---16进制数字颜色支持

extension Int {
    var uiColor: UIColor {
        .init(String(format: "%02X", self))
    }

    var cgColor: CGColor {
        uiColor.cgColor
    }
}
