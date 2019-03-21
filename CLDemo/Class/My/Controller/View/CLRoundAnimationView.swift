//
//  CLRoundAnimationView.swift
//  CLDemo
//
//  Created by AUG on 2019/3/21.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

import UIKit

class CLRoundAnimationView: UIView {
    let animationLayer = CALayer()
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    override init(frame: CGRect) {
        super.init(frame: frame)
        width = frame.size.width
        height = frame.size.height
        
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.mask = shapeLayer(start: 0, end: 1)
        animationLayer.frame = layer.bounds
        animationLayer.backgroundColor = UIColor.orange.cgColor
        animationLayer.mask = shapeLayer(start: 0, end: 0.2)
        layer.addSublayer(animationLayer)
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.repeatCount = MAXFLOAT
        rotationAnimation.duration = 0.8
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.fillMode = .forwards
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        animationLayer.add(rotationAnimation, forKey: "rotationAnnimation")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shapeLayer(start:CGFloat, end:CGFloat) -> CAShapeLayer {
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: width * 0.5, y: height * 0.5), radius: height * 0.5 - 5, startAngle: 0, endAngle: .pi * 2.0, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor;
        shapeLayer.strokeColor = UIColor.white.cgColor;
        shapeLayer.lineWidth = 5;
        shapeLayer.strokeStart = start;
        shapeLayer.strokeEnd = end;
        shapeLayer.lineCap = .round;
        shapeLayer.lineDashPhase = 0.8;
        shapeLayer.path = bezierPath.cgPath;
        return shapeLayer;
    }
}
