//
//  CLPopupHudController.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/3/3.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit


/// 动画类型
enum CLHudType {
    ///成功动画
    case success
    ///错误动画
    case error
    ///加载中
    case loading
}


class CLPopupHudController: CLPopupManagerController {
    var animationType: CLHudType = .success
    var dismissCallback: (() -> ())?
    var text: String? {
        didSet {
            textLabel.text = text
        }
    }
    var strokeColor: UIColor = UIColor.orange {
        didSet {
            shapeLayer.strokeColor = strokeColor.cgColor
        }
    }
    var dismissDuration: CGFloat = 1.0
    var animationSize: CGSize = CGSize(width: 150, height: 150) {
        didSet {
            shapeLayer.frame = CGRect(x: 0, y: 0, width: animationSize.width, height: animationSize.height)
            leftLayer.frame = CGRect(x: 0, y: 0, width: animationSize.width, height: animationSize.height)
            rightLayer.frame = CGRect(x: 0, y: 0, width: animationSize.width, height: animationSize.height)
        }
    }
    var space: CGFloat = 30.0
    var lineWidth: CGFloat = 3.0

    lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.textColor = UIColor.white
        textLabel.textAlignment = .center
        textLabel.preferredMaxLayoutWidth = animationSize.width
        return textLabel
    }()
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .hex("0x000000", alpha: 0.8)
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        return contentView
    }()
    lazy var animationView: UIView = {
        let animationView = UIView()
        animationView.backgroundColor = UIColor.clear
        return animationView
    }()
    lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 0, y: 0, width: animationSize.width, height: animationSize.height)
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor;
        shapeLayer.strokeColor = strokeColor.cgColor;
        shapeLayer.lineCap = .round
        return shapeLayer
    }()
    lazy var leftLayer: CAShapeLayer = {
        let leftLayer = CAShapeLayer()
        leftLayer.frame = CGRect(x: 0, y: 0, width: animationSize.width, height: animationSize.height)
        leftLayer.fillColor = UIColor.clear.cgColor
        leftLayer.lineCap = .round
        leftLayer.lineWidth = lineWidth
        leftLayer.strokeColor = strokeColor.cgColor
        return leftLayer
    }()
    lazy var rightLayer: CAShapeLayer = {
        let rightLayer = CAShapeLayer()
        rightLayer.frame = CGRect(x: 0, y: 0, width: animationSize.width, height: animationSize.height)
        rightLayer.fillColor = UIColor.clear.cgColor
        rightLayer.lineCap = .round
        rightLayer.lineWidth = lineWidth
        rightLayer.strokeColor = strokeColor.cgColor
        return rightLayer
    }()
}
extension CLPopupHudController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        switch animationType {
        case .success:
            successAnimation()
            dismiss(duration: Double(dismissDuration))
        case .error:
            errorAnimation()
            dismiss(duration: Double(dismissDuration))
        case .loading:
            loadingAnimation()
        }
    }
}
extension CLPopupHudController {
    private func initUI() {
        view.addSubview(contentView)
        if textLabel.text != nil {
            contentView.addSubview(textLabel)
        }
        contentView.addSubview(animationView)
    }
    private func makeConstraints() {
        let hasText: Bool = textLabel.text != nil
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(contentView.snp.height)
        }
        animationView.snp.makeConstraints { (make) in
            make.top.equalTo(space * 0.5)
            make.size.equalTo(animationSize)
            make.centerX.equalToSuperview()
            if !hasText {
                make.bottom.equalTo(-space * 0.5)
            }
        }
        if hasText {
            textLabel.snp.makeConstraints { (make) in
                make.top.equalTo(animationView.snp.bottom).offset(space * 0.5)
                make.bottom.equalTo(-space * 0.5)
                make.centerX.equalToSuperview()
            }
        }
    }
}
extension CLPopupHudController {
    private func successAnimation() {
        animationView.layer.addSublayer(shapeLayer)
        addAlphaLineLayer()
        
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: animationSize.width / 2, y: animationSize.height / 2), radius: animationSize.width / 2 - lineWidth, startAngle: 67 * .pi / 180, endAngle: -158 * .pi / 180, clockwise: false)
        path.addLine(to: CGPoint(x: animationSize.width * 0.42, y: animationSize.width * 0.68))
        path.addLine(to: CGPoint(x: animationSize.width * 0.75, y: animationSize.width * 0.35))
        shapeLayer.path = path.cgPath
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.duration = 0.5
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0

        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.duration = 0.4
        strokeStartAnimation.beginTime = CACurrentMediaTime() + 0.2
        strokeStartAnimation.fromValue = 0.0
        strokeStartAnimation.toValue = 0.74
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.3, 0.6, 0.8, 1.1)
        
        shapeLayer.strokeStart = 0.74
        shapeLayer.strokeEnd = 1.0
        shapeLayer.add(strokeEndAnimation, forKey: "strokeEnd")
        shapeLayer.add(strokeStartAnimation, forKey: "strokeStart")
    }
    private func errorAnimation() {
        animationView.layer.addSublayer(shapeLayer)
        addAlphaLineLayer()
        
        let leftPath = UIBezierPath()
        leftPath.addArc(withCenter: CGPoint(x: shapeLayer.frame.size.width / 2, y: shapeLayer.frame.size.height / 2), radius: shapeLayer.frame.size.width / 2 - lineWidth, startAngle: -43 * .pi / 180, endAngle: -315 * .pi / 180, clockwise: false)
        leftPath.addLine(to: CGPoint(x: shapeLayer.frame.size.width * 0.35, y: shapeLayer.frame.size.width * 0.35))
        leftLayer.path = leftPath.cgPath
        shapeLayer.addSublayer(leftLayer)

        let rightPath = UIBezierPath()
        rightPath.addArc(withCenter: CGPoint(x: shapeLayer.frame.size.width / 2, y: shapeLayer.frame.size.height / 2), radius: shapeLayer.frame.size.width / 2 - lineWidth, startAngle: -128 * .pi / 180, endAngle: 133 * .pi / 180, clockwise: true)
        rightPath.addLine(to: CGPoint(x: shapeLayer.frame.size.width * 0.65, y: shapeLayer.frame.size.width * 0.35))
        rightLayer.path = rightPath.cgPath
        shapeLayer.addSublayer(rightLayer)
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.duration = 0.5
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0

        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.duration = 0.4
        strokeStartAnimation.beginTime = CACurrentMediaTime() + 0.2
        strokeStartAnimation.fromValue = 0.0
        strokeStartAnimation.toValue = 0.84
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.3, 0.6, 0.8, 1.1)
        
        leftLayer.strokeStart = 0.84
        leftLayer.strokeEnd = 1.0
        leftLayer.add(strokeEndAnimation, forKey: "strokeEnd")
        leftLayer.add(strokeStartAnimation, forKey: "strokeStart")
        
        rightLayer.strokeStart = 0.84
        rightLayer.strokeEnd = 1.0
        rightLayer.add(strokeEndAnimation, forKey: "strokeEnd")
        rightLayer.add(strokeStartAnimation, forKey: "strokeStart")
    }
    private func loadingAnimation() {
        animationView.layer.addSublayer(shapeLayer)
        addAlphaLineLayer()

        let drawLayer = CAShapeLayer()
        let progressPath = UIBezierPath()
        progressPath.addArc(withCenter: CGPoint(x: shapeLayer.frame.size.width / 2, y: shapeLayer.frame.size.height / 2), radius: shapeLayer.frame.size.width / 2 - lineWidth, startAngle: 0 * .pi / 180, endAngle: 360 * .pi / 180, clockwise: true)

        drawLayer.lineWidth = lineWidth
        drawLayer.fillColor = UIColor.clear.cgColor
        drawLayer.path = progressPath.cgPath
        drawLayer.frame = shapeLayer.bounds
        drawLayer.strokeColor = strokeColor.cgColor
        shapeLayer.addSublayer(drawLayer)
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0
        strokeEndAnimation.duration = 2
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0.80, 0.75, 1.00)
        strokeEndAnimation.repeatCount = MAXFLOAT
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0.0
        strokeStartAnimation.toValue = 1.0
        strokeStartAnimation.duration = 2
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.65, 0.0,  1.0, 1.0)
        strokeStartAnimation.repeatCount = MAXFLOAT
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = Double.pi / 180 * 360
        rotateAnimation.repeatCount = MAXFLOAT
        rotateAnimation.duration = 6
        
        drawLayer.add(strokeEndAnimation, forKey: "strokeEnd")
        drawLayer.add(strokeStartAnimation, forKey: "strokeStart")
        shapeLayer.add(rotateAnimation, forKey: "transfrom.rotation.z")
    }
}
extension CLPopupHudController {
    func addAlphaLineLayer() {
        let circlePath = UIBezierPath()
        circlePath.addArc(withCenter: CGPoint(x: animationSize.width / 2, y: animationSize.height / 2), radius: animationSize.width / 2 - lineWidth, startAngle: 0 * .pi / 180, endAngle: 360 * .pi / 180, clockwise: false)
        let alphaLineLayer = CAShapeLayer()
        alphaLineLayer.path = circlePath.cgPath
        alphaLineLayer.strokeColor = UIColor(cgColor: UIColor.white.cgColor).withAlphaComponent(0.1).cgColor
        alphaLineLayer.lineWidth = lineWidth
        alphaLineLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.addSublayer(alphaLineLayer)
    }
}
extension CLPopupHudController {
    private func dismiss(duration: Double) {
         DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration + 0.6) {
             UIView.animate(withDuration: 0.3, animations: {
                 self.contentView.alpha = 0.0
                 self.contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
             }) { (_) in
                 
            CLPopupManager.dismiss(self.configure.identifier)
                self.dismissCallback?()
             }
         }
     }
}
