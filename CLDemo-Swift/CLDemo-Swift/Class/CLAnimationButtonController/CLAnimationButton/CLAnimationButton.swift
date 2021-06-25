//
//  CLAnimationButton.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/3/17.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit
import SnapKit

class CLAnimationButton: UIControl {
    private var lineLayers: [CAShapeLayer]!
    private lazy var imageShapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = imageColorOff.cgColor
        layer.actions = ["fillColor": NSNull()]
        layer.mask = CALayer()
        return layer
    }()
    private lazy var circleShapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = circleColor.cgColor
        layer.transform = CATransform3DMakeScale(0.0, 0.0, 1.0)
        layer.mask = circleMaskLayer
        return layer
    }()
    private lazy var circleMaskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillRule = .evenOdd
        return layer
    }()
    private lazy var circleTransformAnimation: CAKeyframeAnimation = {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.333 // 0.0333 * 10
        animation.values = [
            CATransform3DMakeScale(0.0,  0.0,  1.0),    //  0/10
            CATransform3DMakeScale(0.5,  0.5,  1.0),    //  1/10
            CATransform3DMakeScale(1.0,  1.0,  1.0),    //  2/10
            CATransform3DMakeScale(1.2,  1.2,  1.0),    //  3/10
            CATransform3DMakeScale(1.3,  1.3,  1.0),    //  4/10
            CATransform3DMakeScale(1.37, 1.37, 1.0),    //  5/10
            CATransform3DMakeScale(1.4,  1.4,  1.0),    //  6/10
            CATransform3DMakeScale(1.4,  1.4,  1.0)     // 10/10
        ]
        animation.keyTimes = [
            0.0,    //  0/10
            0.1,    //  1/10
            0.2,    //  2/10
            0.3,    //  3/10
            0.4,    //  4/10
            0.5,    //  5/10
            0.6,    //  6/10
            1.0     // 10/10
        ]
        return animation
    }()
    private lazy var circleMaskTransformAnimation: CAKeyframeAnimation = {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.333 // 0.0333 * 10
        animation.keyTimes = [
            0.0,    //  0/10
            0.2,    //  2/10
            0.3,    //  3/10
            0.4,    //  4/10
            0.5,    //  5/10
            0.6,    //  6/10
            0.7,    //  7/10
            0.9,    //  9/10
            1.0     // 10/10
        ]
        return animation
    }()
    private lazy var lineStrokeStartAnimation: CAKeyframeAnimation = {
        let animation = CAKeyframeAnimation(keyPath: "strokeStart")
        animation.duration = 0.6 //0.0333 * 18
        animation.values = [
            0.0,    //  0/18
            0.0,    //  1/18
            0.18,   //  2/18
            0.2,    //  3/18
            0.26,   //  4/18
            0.32,   //  5/18
            0.4,    //  6/18
            0.6,    //  7/18
            0.71,   //  8/18
            0.89,   // 17/18
            0.92    // 18/18
        ]
        animation.keyTimes = [
            0.0,    //  0/18
            0.056,  //  1/18
            0.111,  //  2/18
            0.167,  //  3/18
            0.222,  //  4/18
            0.278,  //  5/18
            0.333,  //  6/18
            0.389,  //  7/18
            0.444,  //  8/18
            0.944,  // 17/18
            1.0,    // 18/18
        ]
        return animation
    }()
    private lazy var lineStrokeEndAnimation: CAKeyframeAnimation = {
        let animation = CAKeyframeAnimation(keyPath: "strokeEnd")
        animation.duration = 0.6 //0.0333 * 18
        animation.values = [
            0.0,    //  0/18
            0.0,    //  1/18
            0.32,   //  2/18
            0.48,   //  3/18
            0.64,   //  4/18
            0.68,   //  5/18
            0.92,   // 17/18
            0.92    // 18/18
        ]
        animation.keyTimes = [
            0.0,    //  0/18
            0.056,  //  1/18
            0.111,  //  2/18
            0.167,  //  3/18
            0.222,  //  4/18
            0.278,  //  5/18
            0.944,  // 17/18
            1.0,    // 18/18
        ]
        return animation
    }()
    private lazy var lineOpacityAnimation: CAKeyframeAnimation = {
        let animation = CAKeyframeAnimation(keyPath: "opacity")
        animation.duration = 1.0 //0.0333 * 30
        animation.values = [
            1.0,    //  0/30
            1.0,    // 12/30
            0.0     // 17/30
        ]
        animation.keyTimes = [
            0.0,    //  0/30
            0.4,    // 12/30
            0.567   // 17/30
        ]
        return animation
    }()
    private lazy var imageTransformAnimation: CAKeyframeAnimation = {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 1.0 //0.0333 * 30
        animation.values = [
            CATransform3DMakeScale(0.0,   0.0,   1.0),  //  0/30
            CATransform3DMakeScale(0.0,   0.0,   1.0),  //  3/30
            CATransform3DMakeScale(1.2,   1.2,   1.0),  //  9/30
            CATransform3DMakeScale(1.25,  1.25,  1.0),  // 10/30
            CATransform3DMakeScale(1.2,   1.2,   1.0),  // 11/30
            CATransform3DMakeScale(0.9,   0.9,   1.0),  // 14/30
            CATransform3DMakeScale(0.875, 0.875, 1.0),  // 15/30
            CATransform3DMakeScale(0.875, 0.875, 1.0),  // 16/30
            CATransform3DMakeScale(0.9,   0.9,   1.0),  // 17/30
            CATransform3DMakeScale(1.013, 1.013, 1.0),  // 20/30
            CATransform3DMakeScale(1.025, 1.025, 1.0),  // 21/30
            CATransform3DMakeScale(1.013, 1.013, 1.0),  // 22/30
            CATransform3DMakeScale(0.96,  0.96,  1.0),  // 25/30
            CATransform3DMakeScale(0.95,  0.95,  1.0),  // 26/30
            CATransform3DMakeScale(0.96,  0.96,  1.0),  // 27/30
            CATransform3DMakeScale(0.99,  0.99,  1.0),  // 29/30
            CATransform3DIdentity                       // 30/30
        ]
        animation.keyTimes = [
            0.0,    //  0/30
            0.1,    //  3/30
            0.3,    //  9/30
            0.333,  // 10/30
            0.367,  // 11/30
            0.467,  // 14/30
            0.5,    // 15/30
            0.533,  // 16/30
            0.567,  // 17/30
            0.667,  // 20/30
            0.7,    // 21/30
            0.733,  // 22/30
            0.833,  // 25/30
            0.867,  // 26/30
            0.9,    // 27/30
            0.967,  // 29/30
            1.0     // 30/30
        ]
        return animation
    }()
    var imageColorOn: UIColor = UIColor(red: 255/255, green: 172/255, blue: 51/255, alpha: 1.0) {
        didSet {
            if (isSelected) {
                imageShapeLayer.fillColor = imageColorOn.cgColor
            }
        }
    }
    var imageColorOff: UIColor = UIColor(red: 136/255, green: 153/255, blue: 166/255, alpha: 1.0) {
        didSet {
            if (!isSelected) {
                imageShapeLayer.fillColor = imageColorOff.cgColor
            }
        }
    }
    var circleColor: UIColor = UIColor(red: 255/255, green: 172/255, blue: 51/255, alpha: 1.0) {
        didSet {
            circleShapeLayer.fillColor = circleColor.cgColor
        }
    }
    var lineColor: UIColor = UIColor(red: 250/255, green: 120/255, blue: 68/255, alpha: 1.0) {
        didSet {
            for line in lineLayers {
                line.strokeColor = lineColor.cgColor
            }
        }
    }
    var duration: Double = 1.0 {
        didSet {
            circleTransformAnimation.duration = 0.333 * duration // 0.0333 * 10
            circleMaskTransformAnimation.duration = 0.333 * duration // 0.0333 * 10
            lineStrokeStartAnimation.duration = 0.6 * duration //0.0333 * 18
            lineStrokeEndAnimation.duration = 0.6 * duration //0.0333 * 18
            lineOpacityAnimation.duration = 1.0 * duration //0.0333 * 30
            imageTransformAnimation.duration = 1.0 * duration //0.0333 * 30
        }
    }
    override var isSelected: Bool {
        didSet {
            if (oldValue != isSelected) {
                if isSelected {
                    imageShapeLayer.fillColor = imageColorOn.cgColor
                }else {
                    deselect()
                }
            }
        }
    }
    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        DispatchQueue.main.async {
            self.createLayers(image: image)
        }
        addTargets()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLAnimationButton {
    func select() {
        isSelected = true
        imageShapeLayer.fillColor = imageColorOn.cgColor
        CATransaction.begin()
        circleShapeLayer.add(circleTransformAnimation, forKey: "transform")
        circleMaskLayer.add(circleMaskTransformAnimation, forKey: "transform")
        imageShapeLayer.add(imageTransformAnimation, forKey: "transform")
        lineLayers.forEach { (layer) in
            layer.add(lineStrokeStartAnimation, forKey: "strokeStart")
            layer.add(lineStrokeEndAnimation, forKey: "strokeEnd")
            layer.add(lineOpacityAnimation, forKey: "opacity")
        }
        CATransaction.commit()
    }
    func deselect() {
        isSelected = false
        imageShapeLayer.fillColor = imageColorOff.cgColor
        circleShapeLayer.removeAllAnimations()
        circleMaskLayer.removeAllAnimations()
        imageShapeLayer.removeAllAnimations()
        lineLayers.forEach { (layer) in
            layer.removeAllAnimations()
        }
    }
}
private extension CLAnimationButton {
    private func addTargets() {
        addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
        addTarget(self, action: #selector(touchDragExit(_:)), for: .touchDragExit)
        addTarget(self, action: #selector(touchDragEnter(_:)), for: .touchDragEnter)
        addTarget(self, action: #selector(touchCancel(_:)), for: .touchCancel)
    }
    private func createLayers(image: UIImage) {
        layer.sublayers = nil

        let imageFrame = CGRect(x: frame.width * 0.5 - frame.width * 0.25, y: frame.height * 0.5 - frame.height * 0.25, width: frame.width * 0.5, height: frame.height * 0.5)
        let imageCenterPoint = CGPoint(x: imageFrame.midX, y: imageFrame.midY)
        let lineFrame = CGRect(x: imageFrame.origin.x - imageFrame.width * 0.25, y: imageFrame.origin.y - imageFrame.height + 0.25, width: imageFrame.width * 2, height: imageFrame.height * 2)

        circleShapeLayer.bounds = imageFrame
        circleShapeLayer.position = imageCenterPoint
        circleShapeLayer.path = UIBezierPath(ovalIn: imageFrame).cgPath
        layer.addSublayer(circleShapeLayer)

        circleMaskLayer.bounds = imageFrame
        circleMaskLayer.position = imageCenterPoint
        circleMaskLayer.path = {
            let maskPath = UIBezierPath(rect: imageFrame)
            maskPath.addArc(withCenter: imageCenterPoint, radius: 0.1, startAngle: CGFloat(0.0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
            return maskPath.cgPath
        }()

        lineLayers = []
        for i in 0 ..< 5 {
            let lineLayer = CAShapeLayer()
            lineLayer.bounds = lineFrame
            lineLayer.position = imageCenterPoint
            lineLayer.masksToBounds = true
            lineLayer.actions = ["strokeStart": NSNull(), "strokeEnd": NSNull()]
            lineLayer.strokeColor = lineColor.cgColor
            lineLayer.lineWidth = 1.25
            lineLayer.miterLimit = 1.25
            lineLayer.lineCap = .round
            lineLayer.lineJoin = .round
            lineLayer.strokeStart = 0.0
            lineLayer.strokeEnd = 0.0
            lineLayer.opacity = 0.0
            lineLayer.transform = CATransform3DMakeRotation(CGFloat(Double.pi) * 0.2 * (CGFloat(i) * 2 + 1), 0.0, 0.0, 1.0)
            lineLayer.path = {
                let path = CGMutablePath()
                path.move(to: CGPoint(x: lineFrame.midX, y: lineFrame.midY))
                path.addLine(to: CGPoint(x: lineFrame.origin.x + lineFrame.width * 0.5, y: lineFrame.origin.y))
                return path
            }()
            layer.addSublayer(lineLayer)
            lineLayers.append(lineLayer)
        }

        
        imageShapeLayer.bounds = imageFrame
        imageShapeLayer.position = imageCenterPoint
        imageShapeLayer.path = UIBezierPath(rect: imageFrame).cgPath
        imageShapeLayer.mask?.contents = image.cgImage
        imageShapeLayer.mask?.bounds = imageFrame
        imageShapeLayer.mask?.position = imageCenterPoint
        layer.addSublayer(imageShapeLayer)

        circleMaskTransformAnimation.values = [
            CATransform3DIdentity,                                                              //  0/10
            CATransform3DIdentity,                                                              //  2/10
            CATransform3DMakeScale(imageFrame.width * 1.25,  imageFrame.height * 1.25,  1.0),   //  3/10
            CATransform3DMakeScale(imageFrame.width * 2.688, imageFrame.height * 2.688, 1.0),   //  4/10
            CATransform3DMakeScale(imageFrame.width * 3.923, imageFrame.height * 3.923, 1.0),   //  5/10
            CATransform3DMakeScale(imageFrame.width * 4.375, imageFrame.height * 4.375, 1.0),   //  6/10
            CATransform3DMakeScale(imageFrame.width * 4.731, imageFrame.height * 4.731, 1.0),   //  7/10
            CATransform3DMakeScale(imageFrame.width * 5.0,   imageFrame.height * 5.0,   1.0),   //  9/10
            CATransform3DMakeScale(imageFrame.width * 5.0,   imageFrame.height * 5.0,   1.0)    // 10/10
        ]
    }
}
@objc extension CLAnimationButton {
    @objc func touchDown(_ sender: CLAnimationButton) {
        layer.opacity = 0.4
    }
    @objc func touchUpInside(_ sender: CLAnimationButton) {
        layer.opacity = 1.0
    }
    @objc func touchDragExit(_ sender: CLAnimationButton) {
        layer.opacity = 1.0
    }
    @objc func touchDragEnter(_ sender: CLAnimationButton) {
        layer.opacity = 0.4
    }
    @objc func touchCancel(_ sender: CLAnimationButton) {
        layer.opacity = 1.0
    }
}

