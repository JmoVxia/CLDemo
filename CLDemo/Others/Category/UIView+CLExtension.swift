//
//  UIView+CLExtension.swift
//  CL
//
//  Created by JmoVxia on 2020/3/12.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

extension UIView {
    ///查找控制器
    func findController() -> UIViewController? {
        return self.findControllerWithClass(UIViewController.self)
    }
    ///查找导航控制器
    func findNavigationController() -> UINavigationController? {
        return self.findControllerWithClass(UINavigationController.self)
    }
    ///根据类型查找控制器
    func findControllerWithClass<T>(_ class: AnyClass) -> T? {
        var responder = next
        while(responder != nil) {
            if (responder!.isKind(of: `class`)) {
                return responder as? T
            }
            responder = responder?.next
        }
        return nil
    }
    ///设置新frame
    func setNewFrame(_ frame: CGRect) {
        if self.frame != frame {
            self.frame = frame
        }
    }
}
///圆角
struct CLCornerRadius {
    var topLeft: CGFloat = 0
    var topRight: CGFloat = 0
    var bottomLeft: CGFloat = 0
    var bottomRight: CGFloat = 0
}
extension UIView {
    ///设置圆角
    func setCornerRadius(with radius: CLCornerRadius, borderLayerCallback: (() -> (CAShapeLayer))? = nil) {
        let maskBezierPath = UIBezierPath()
        maskBezierPath.addArc(withCenter: CGPoint(x: bounds.minX + radius.topLeft, y: bounds.minY + radius.topLeft), radius: radius.topLeft, startAngle: .pi, endAngle: .pi * 1.5, clockwise: true)
        maskBezierPath.addArc(withCenter: CGPoint(x: bounds.maxX - radius.topRight, y: bounds.minY + radius.topRight), radius: radius.topRight, startAngle: .pi * 1.5, endAngle: 0, clockwise: true)
        maskBezierPath.addArc(withCenter: CGPoint(x: bounds.maxX - radius.bottomRight, y: bounds.maxY - radius.bottomRight), radius: radius.bottomRight, startAngle: 0, endAngle: .pi * 0.5, clockwise: true)
        maskBezierPath.addArc(withCenter: CGPoint(x: bounds.minX + radius.bottomLeft, y: bounds.maxY - radius.bottomLeft), radius: radius.bottomLeft, startAngle: .pi * 0.5, endAngle: .pi, clockwise: true)
        maskBezierPath.close()
        if let borderLayer = borderLayerCallback?() {
            borderLayer.frame = bounds
            borderLayer.path = maskBezierPath.cgPath
            layer.addSublayer(borderLayer)
        }
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskBezierPath.cgPath
        layer.mask = maskLayer
    }
}
