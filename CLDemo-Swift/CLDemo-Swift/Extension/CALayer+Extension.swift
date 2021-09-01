//
//  CALayer+Extension.swift
//  CL
//
//  Created by Chen JmoVxia on 2020/11/9.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

extension CALayer {
    /// Apply all 6 sketch shadow properties to the View
    func applySketchShadow(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat, y: CGFloat, blur: CGFloat, spread: CGFloat = 0) {
        shadowColor   = color.cgColor
        shadowOpacity = alpha
        shadowOffset  = CGSize(width: x, height: y)
        shadowRadius  = blur / UIScreen.main.scale
        masksToBounds = false
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx     = -spread
            let rect   = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
