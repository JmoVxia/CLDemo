//
//  CLIndexView.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/5/1.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLIndexView: UIView {
    var triangleColor: UIColor?
    var lineHeight: CGFloat = 0.0
}
extension CLIndexView {
    override func draw(_ rect: CGRect) {
         UIColor.clear.set()
         UIRectFill(self.bounds)
         let context = UIGraphicsGetCurrentContext()
         context?.setLineWidth(1)
         context?.beginPath()
         context?.move(to: CGPoint.init(x: 0, y: 0))
         context?.addLine(to: CGPoint.init(x: bounds.width, y: 0))
         context?.addLine(to: CGPoint.init(x: bounds.width * 0.5, y: bounds.width * 0.5))
         context?.addLine(to: CGPoint.init(x: 0, y: 0))
         context?.move(to: CGPoint.init(x: bounds.width * 0.5, y: bounds.width * 0.5))
        context?.addLine(to: CGPoint.init(x: bounds.width * 0.5, y: lineHeight + bounds.width * 0.5))
         context?.closePath()
         triangleColor?.setFill()
         triangleColor?.setStroke()
         context?.drawPath(using: .fillStroke)
     }
}
