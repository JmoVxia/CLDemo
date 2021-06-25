//
//  CLSectorAnimationView.swift
//  CLDemo
//
//  Created by AUG on 2019/6/22.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit

class CLSectorAnimationView: UIView {

    private lazy var animation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fillMode = CAMediaTimingFillMode.both
        animation.isRemovedOnCompletion = false
        return animation
    }()
    
    private lazy var maskLayer: CAShapeLayer = {
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath.init(arcCenter: CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.5), radius: self.frame.width / 4.0, startAngle: (-.pi * 0.5), endAngle:(3 * .pi / 2), clockwise: true)
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.lineWidth = self.frame.width / 2
        maskLayer.path = path.cgPath
        maskLayer.strokeEnd = 0.0
        return maskLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        layer.mask = maskLayer
        layer.backgroundColor = UIColor.orange.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///动画更新进度
    func updateProgressAnimation(fromValue: CGFloat, toValue: CGFloat, duration: CFTimeInterval) -> Void {
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        maskLayer.add(animation, forKey: "key")
    }
    ///更新进度
    func updateProgress(progress: CGFloat) {
        maskLayer.removeAllAnimations()
        maskLayer.strokeEnd = min(max(progress, 0), 1)
    }
}
