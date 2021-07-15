//
//  CLTheme.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/15.
//

import UIKit


extension CLTheme {
    /// 模式
    enum Mode: String, CaseIterable {
        ///跟随系统
        case follow
        ///白天
        case light
        ///夜间
        case dark

        @available(iOS 13.0, *)
        /// 风格
        var style: UIUserInterfaceStyle {
            switch self {
                case .follow: return .unspecified
                case .light: return .light
                case .dark: return .dark
            }
        }
    }
}

class CLTheme {
    @CLUserDefaultStorage(keyName: "appTheme")
    private static var appTheme: String?

    ///模式
    static var mode: Mode {
        get { return Mode(rawValue: appTheme ?? "") ?? .follow }
        set { appTheme = newValue.rawValue }
    }
    /// 创造颜色
    static func makeColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { $0.userInterfaceStyle == .light ? light : dark }
        } else {
            return CLTheme.mode == .light ? light : dark
        }
    }
    /// 创造图片
    static func makeImage(light: UIImage, dark: UIImage) -> UIImage {
        if #available(iOS 13.0, *) {
            let image = UIImage()
            image.imageAsset?.register(light, with: .init(userInterfaceStyle: .light))
            image.imageAsset?.register(dark, with: .init(userInterfaceStyle: .dark))
            return image
        } else {
            return CLTheme.mode == .light ? light : dark
        }
    }
}

extension UIColor {
    static func color(light: UIColor, dark: UIColor) -> UIColor {
        return CLTheme.makeColor(light: light, dark: dark)
    }
}

extension UIImage {
    static func image(light: UIImage, dark: UIImage) -> UIImage {
        return CLTheme.makeImage(light: light, dark: dark)
    }
}
