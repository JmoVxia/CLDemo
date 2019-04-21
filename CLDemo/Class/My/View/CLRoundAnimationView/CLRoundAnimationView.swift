//
//  CLRoundAnimationView.swift
//  CLDemo
//
//  Created by AUG on 2019/3/21.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

import UIKit

/// 动画位置
///
/// - animationOut: 外侧
/// - animationMiddle: 中间
/// - animationIn: 内侧
enum CLAnimationPosition: NSInteger {
    case animationOut = 0
    case animationMiddle = 1
    case animationIn = 2
}

class CLRoundAnimationViewConfigure: NSObject {
    ///外圆背景色
    var outBackgroundColor: UIColor = UIColor.lightGray
    ///内圆背景色
    var inBackgroundColor: UIColor = UIColor.orange
    ///外圆线宽
    var outLineWidth: CGFloat = 5
    ///内圆线宽
    var inLineWidth: CGFloat = 5
    ///开始起点
    var strokeStart: CGFloat = 0
    ///开始结束点
    var strokeEnd: CGFloat = 0.2
    ///动画时间
    var duration: CFTimeInterval = 0.8
    ///动画位置
    var position: CLAnimationPosition = .animationOut
    
    fileprivate class func defaultConfigure() -> CLRoundAnimationViewConfigure {
        let configure = CLRoundAnimationViewConfigure()
        return configure
    }
}

class CLRoundAnimationView: UIView {
    
    private let backgroundLayer: CALayer = CALayer()
    private let animationLayer: CALayer = CALayer()
    private let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    private let configure: CLRoundAnimationViewConfigure = CLRoundAnimationViewConfigure.defaultConfigure()
    private var width: CGFloat = 0.0
    private var height: CGFloat = 0.0
    private var isPause: Bool = false

    ///更新配置
    func updateWithConfigure(_ configureBlock: ((CLRoundAnimationViewConfigure) -> (Void))?) -> Void {
        configureBlock?(configure)
        configure.inLineWidth = min(configure.inLineWidth, configure.outLineWidth)
        backgroundLayer.backgroundColor = configure.outBackgroundColor.cgColor
        backgroundLayer.mask = shapeLayer(lineWidth: configure.outLineWidth, start: 0, end: 1, outLayer: true)
        animationLayer.mask = shapeLayer(lineWidth: configure.inLineWidth, start: configure.strokeStart, end: configure.strokeEnd, outLayer: false)
        animationLayer.backgroundColor = configure.inBackgroundColor.cgColor
        rotationAnimation.duration = configure.duration;
    }
}
extension CLRoundAnimationView {
    ///开始动画
    func startAnimation() -> Void {
        animation()
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(animationLayer)
    }
    ///停止动画
    func stopAnimation() -> Void {
        backgroundLayer.removeFromSuperlayer()
        animationLayer.removeFromSuperlayer()
        animationLayer.removeAllAnimations()
    }
    ///暂停动画
    func pauseAnimation() {
        if isPause {
            return
        }
        isPause = true
        //取出当前时间,转成动画暂停的时间
        let pausedTime = animationLayer.convertTime(CACurrentMediaTime(), from: nil)
        //设置动画运行速度为0
        animationLayer.speed = 0.0;
        //设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
        animationLayer.timeOffset = pausedTime
    }
    ///恢复动画
    func resumeAnimation() {
        if !isPause {
            return
        }
        isPause = false
        //获取暂停的时间差
        let pausedTime = animationLayer.timeOffset
        animationLayer.speed = 1.0
        animationLayer.timeOffset = 0.0
        animationLayer.beginTime = 0.0
        //用现在的时间减去时间差,就是之前暂停的时间,从之前暂停的时间开始动画
        let timeSincePause = animationLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        animationLayer.beginTime = timeSincePause
    }
}
extension CLRoundAnimationView {
    private func animation() {
        width = frame.size.width
        height = frame.size.height
        
        backgroundLayer.frame = layer.bounds
        backgroundLayer.mask = shapeLayer(lineWidth: configure.outLineWidth, start: 0, end: 1, outLayer: true)
        backgroundLayer.backgroundColor = configure.outBackgroundColor.cgColor
        
        animationLayer.frame = layer.bounds
        animationLayer.mask = shapeLayer(lineWidth: configure.inLineWidth, start: configure.strokeStart, end: configure.strokeEnd, outLayer: false)
        animationLayer.backgroundColor = configure.inBackgroundColor.cgColor
        backgroundLayer.addSublayer(animationLayer)
        
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.repeatCount = MAXFLOAT
        rotationAnimation.duration = configure.duration
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.fillMode = .forwards
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        animationLayer.add(rotationAnimation, forKey: "rotationAnnimation")
    }
    private func shapeLayer(lineWidth: CGFloat, start: CGFloat, end: CGFloat, outLayer: Bool) -> CAShapeLayer {
        var offset: CGFloat = 0
        switch (configure.position) {
        case .animationOut:
            offset = 0;
            break;
        case .animationMiddle:
            offset = outLayer ? 0 : configure.outLineWidth - configure.inLineWidth;
            break;
        case .animationIn:
            offset = outLayer ? 0 : (configure.outLineWidth - configure.inLineWidth) * 2;
            break;
        }
        let radius: CGFloat = (height - lineWidth - offset) * 0.5;
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: width * 0.5, y: height * 0.5), radius: radius, startAngle: 0, endAngle: .pi * 2.0, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor;
        shapeLayer.strokeColor = UIColor.white.cgColor;
        shapeLayer.lineWidth = lineWidth;
        shapeLayer.strokeStart = start;
        shapeLayer.strokeEnd = end;
        shapeLayer.lineCap = .round;
        shapeLayer.lineDashPhase = 0.8;
        shapeLayer.path = bezierPath.cgPath;
        return shapeLayer;
    }
}
