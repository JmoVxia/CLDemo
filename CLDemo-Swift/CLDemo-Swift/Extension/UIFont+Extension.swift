//
//  UIFont+Extension.swift
//  CL
//
//  Created by Chen JmoVxia on 2021/11/30.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    /// PingFang-SC-Bold字体
    static func boldPingFangSC(_ size: CGFloat, scale: Bool = true) -> UIFont {
        let fontSize: CGFloat = scale ? size * CLFontManager.scaleCoefficient : size
        return UIFont(name: "HelveticaNeue-Medium", size: fontSize) ?? .boldSystemFont(ofSize: fontSize)
    }

    /// PingFang-SC-Medium字体
    static func mediumPingFangSC(_ size: CGFloat, scale: Bool = true) -> UIFont {
        let fontSize: CGFloat = scale ? size * CLFontManager.scaleCoefficient : size
        return UIFont(name: "HelveticaNeue", size: fontSize) ?? .systemFont(ofSize: fontSize)
    }
}
