//
//  UIView+CLExtension.swift
//  CL
//
//  Created by JmoVxia on 2020/3/12.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

extension UIView {
    var controller: UIViewController? {
        return findController(with: UIViewController.self)
    }
    var navigationController: UIViewController? {
        return findController(with: UINavigationController.self)
    }
    var tabbarController: UITabBarController? {
        return findController(with: UITabBarController.self)
    }
    ///根据类型查找控制器
    func findController<T: UIViewController>(with class: T.Type) -> T? {
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
extension UIView {
    ///抖动方向枚举
    enum ShakeDirection: Int {
        ///水平抖动
        case horizontal
        ///垂直抖动
        case vertical
    }
    /// 抖动
    /// - Parameters:
    ///   - direction: 抖动方向（默认是水平方向）
    ///   - times: 抖动次数（默认5次）
    ///   - interval: 每次抖动时间（默认0.1秒）
    ///   - delta: 抖动偏移量（默认2）
    ///   - completion: 抖动动画结束后的回调
    func shake(direction: UIView.ShakeDirection = .horizontal,
               times: Int = 5,
               interval: TimeInterval = 0.1,
               delta: CGFloat = 2,
               completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: interval, animations: {
            switch direction {
            case .horizontal:
                self.layer.setAffineTransform(CGAffineTransform(translationX: delta, y: 0))
                break
            case .vertical:
                self.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: delta))
                break
            }
        }) { (_) in
            if (times == 0) {
                UIView.animate(withDuration: interval, animations: {
                    self.layer.setAffineTransform(.identity)
                }, completion: { (_) in
                    completion?()
                })
            }else {
                self.shake(direction: direction,
                           times: times - 1,
                           interval: interval,
                           delta: delta * -1,
                           completion:completion)
            }
        }
    }
}
extension UIView {
    ///圆角
    struct CLCornerRadius {
        var topLeft: CGFloat = 0
        var topRight: CGFloat = 0
        var bottomLeft: CGFloat = 0
        var bottomRight: CGFloat = 0
    }
    
    /// 设置圆角
    /// - Parameters:
    ///   - radius: 圆角
    ///   - borderLayer: 边框 Layer
    func setCornerRadius(with radius: UIView.CLCornerRadius, borderLayer: CAShapeLayer? = nil) {
        let maskBezierPath = UIBezierPath()
        maskBezierPath.addArc(withCenter: CGPoint(x: bounds.minX + radius.topLeft, y: bounds.minY + radius.topLeft), radius: radius.topLeft, startAngle: .pi, endAngle: .pi * 1.5, clockwise: true)
        maskBezierPath.addArc(withCenter: CGPoint(x: bounds.maxX - radius.topRight, y: bounds.minY + radius.topRight), radius: radius.topRight, startAngle: .pi * 1.5, endAngle: 0, clockwise: true)
        maskBezierPath.addArc(withCenter: CGPoint(x: bounds.maxX - radius.bottomRight, y: bounds.maxY - radius.bottomRight), radius: radius.bottomRight, startAngle: 0, endAngle: .pi * 0.5, clockwise: true)
        maskBezierPath.addArc(withCenter: CGPoint(x: bounds.minX + radius.bottomLeft, y: bounds.maxY - radius.bottomLeft), radius: radius.bottomLeft, startAngle: .pi * 0.5, endAngle: .pi, clockwise: true)
        maskBezierPath.close()
        if let borderLayer = borderLayer {
            borderLayer.frame = bounds
            borderLayer.path = maskBezierPath.cgPath
            layer.addSublayer(borderLayer)
        }
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskBezierPath.cgPath
        layer.mask = maskLayer
    }
}
extension UIView {
    /// 按照view大小截图
    var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
