//
//  UIBezierPath+Extension.swift
//  CL
//
//  Created by Chen JmoVxia on 2020/11/24.
//  Copyright © 2020 JmoVxia. All rights reserved.
//
import UIKit

extension UIBezierPath {
    /// 圆形路径
    /// - Parameters:
    ///   - center: 中心
    ///   - radius: 半径
    convenience init(center: CGPoint, radius: CGFloat) {
        self.init()
        addArc(withCenter: center, radius: radius, startAngle: (.pi * 180) / 180, endAngle: (.pi * 270) / 180, clockwise: true)
        addArc(withCenter: center, radius: radius, startAngle: (.pi * 270) / 180, endAngle: (.pi * 360) / 180, clockwise: true)
        addArc(withCenter: center, radius: radius, startAngle: (.pi * 360) / 180, endAngle: (.pi * 90) / 180, clockwise: true)
        addArc(withCenter: center, radius: radius, startAngle: (.pi * 90) / 180, endAngle: (.pi * 180) / 180, clockwise: true)
        close()
    }
}

extension UIBezierPath {
    convenience init(roundedPolygonPathInRect rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat = 0, rotationOffset: CGFloat = 0) {
        self.init()

        let theta: CGFloat = 2.0 * CGFloat.pi / CGFloat(sides) // How much to turn at every corner
        let width = max(rect.size.width, rect.size.height) // Width of the square

        let center = CGPoint(x: rect.origin.x + rect.size.width / 2.0, y: rect.origin.y + rect.size.height / 2.0)

        // Radius of the circle that encircles the polygon
        // Notice that the radius is adjusted for the corners, that way the largest outer
        // dimension of the resulting shape is always exactly the width - linewidth
        let radius = (width + cornerRadius - (cos(theta) * cornerRadius)) / 2.0

        // Start drawing at a point, which by default is at the right hand edge
        // but can be offset
        var angle = CGFloat(rotationOffset)

        let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
        move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))

        for _ in 0 ..< sides {
            angle += theta

            let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
            let tip = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
            let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))

            addLine(to: start)
            addQuadCurve(to: end, controlPoint: tip)
        }

        close()
    }
}

extension UIBezierPath {
    /// 圆角
    struct PathCornerRadius {
        var topLeft: CGFloat = 0
        var topRight: CGFloat = 0
        var bottomLeft: CGFloat = 0
        var bottomRight: CGFloat = 0
    }

    /// 创建圆角长方形路径
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - edgeInsets: 内边距
    ///   - width: 长方形宽
    ///   - height: 长方形高
    /// - Returns: 圆角长方形路径
    convenience init(radius: PathCornerRadius, edgeInsets: UIEdgeInsets = .zero, width: CGFloat, height: CGFloat) {
        self.init()
        let topSpace = edgeInsets.top
        let leftSpace = edgeInsets.left
        let bottomSpace = edgeInsets.bottom
        let rightSpace = edgeInsets.right
        // 左上圆角
        addArc(withCenter: CGPoint(x: leftSpace + radius.topLeft, y: topSpace + radius.topLeft), radius: radius.topLeft, startAngle: (.pi * 180) / 180, endAngle: (.pi * 270) / 180, clockwise: true)
        // 右上圆角
        addArc(withCenter: CGPoint(x: width - radius.topRight - rightSpace, y: radius.topRight + topSpace), radius: radius.topRight, startAngle: (.pi * 270) / 180, endAngle: (.pi * 360) / 180, clockwise: true)
        // 右下圆角
        addArc(withCenter: CGPoint(x: width - rightSpace - radius.bottomRight, y: height - radius.bottomRight - bottomSpace), radius: radius.bottomRight, startAngle: (.pi * 360) / 180, endAngle: (.pi * 90) / 180, clockwise: true)
        // 左下圆角
        addArc(withCenter: CGPoint(x: leftSpace + radius.bottomLeft, y: height - radius.bottomLeft - bottomSpace), radius: radius.bottomLeft, startAngle: (.pi * 90) / 180, endAngle: (.pi * 180) / 180, clockwise: true)
        close()
    }
}
