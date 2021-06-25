//
//  CLChatImageProgressView.swift
//  Potato
//
//  Created by AUG on 2019/12/20.
//

import UIKit

class CLChatImageProgressView: UIView {
    // 环形进度
    private var progess: CGFloat = 0.0
    // 中心文本显示
    private var label: UILabel?
    // 环形的宽
    private var lineWidth: CGFloat = 2.0
    // 进度条的layer层
    private var foreLayer: CAShapeLayer?
    override init(frame: CGRect) {
        super.init(frame: frame)
        seup(rect: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
extension CLChatImageProgressView {
    func seup(rect: CGRect) -> Void {
        // 背景圆环（灰色背景）
        let shapeLayer: CAShapeLayer = CAShapeLayer.init()
        // 设置frame
        shapeLayer.frame = CGRect.init(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.hex("#373747").cgColor

        let center: CGPoint = CGPoint.init(x: rect.size.width/2, y: rect.size.height/2)
        // 画出曲线（贝塞尔曲线）
        let bezierPath: UIBezierPath = UIBezierPath.init(arcCenter: center, radius: (rect.size.width - lineWidth)/2, startAngle: CGFloat(-0.5 * Double.pi), endAngle: CGFloat(1.5 * Double.pi), clockwise: true)
        shapeLayer.path = bezierPath.cgPath
        layer.addSublayer(shapeLayer)

        // 渐变色 加蒙版 显示蒙版区域
        let gradientLayer: CAGradientLayer = CAGradientLayer.init()
        gradientLayer.frame = bounds
        gradientLayer.colors = NSArray.init(array: [UIColor.hex("#5F98FC").cgColor, UIColor.hex("#47BF00").cgColor]) as? [Any]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0, y: 1)
        layer.addSublayer(gradientLayer)

        foreLayer = CAShapeLayer.init()
        foreLayer?.frame = bounds
        foreLayer?.fillColor = UIColor.clear.cgColor
        foreLayer?.lineWidth = lineWidth
        
        foreLayer?.strokeColor = UIColor.red.cgColor
        foreLayer?.strokeEnd = 0
        foreLayer?.lineCap = CAShapeLayerLineCap.round
        foreLayer?.path = bezierPath.cgPath
        gradientLayer.mask = foreLayer

        label = UILabel.init(frame: bounds)
        label?.text = ""
        addSubview(label!)
        label?.font = PingFangSCMedium(12)
        label?.textColor = UIColor.white
        label?.textAlignment = NSTextAlignment.center
        updateProgress(value: 0.0)
    }
    func updateProgress(value: CGFloat) -> Void {
        progess = value
        label?.text = String.init(format: "%.f%%", progess * 100)
        foreLayer?.strokeEnd = progess
        isHidden = progess == 1.0
        if progess == 1.0 {
            foreLayer?.strokeEnd = 0.0
        }
    }
}
