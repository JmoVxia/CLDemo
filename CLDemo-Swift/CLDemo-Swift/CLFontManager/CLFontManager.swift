//
//  CLFontManager.swift
//  CL
//
//  Created by Chen JmoVxia on 2020/9/10.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLFontManager: NSObject {
    private override init() {
        super.init()
        let coefficient = UserDefaults.standard.integer(forKey: "CLFontSize.key.JmoVxia")
        if coefficient != 0 {
            self.coefficient = coefficient
        }
    }
    static let shared = CLFontManager()
    ///字体等级
    private (set) var coefficient: Int = 2
}
extension CLFontManager {
    /// 设置字体等级
    static func setFontSizeCoefficient(_ coefficient: Int) {
        shared.coefficient = coefficient
        UserDefaults.standard.setValue(coefficient, forKey: "CLFontSize.key.JmoVxia")
        UserDefaults.standard.synchronize()
    }
    /// 字体等级
    static var fontSizeCoefficient: Int {
        return shared.coefficient
    }
    /// 字体比例系数
    static var scaleCoefficient: CGFloat {
        return 0.075 * CGFloat(shared.coefficient - 2) + 1
    }
}
