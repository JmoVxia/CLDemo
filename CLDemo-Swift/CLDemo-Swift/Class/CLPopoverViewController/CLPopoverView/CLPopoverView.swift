//
//  CLPopoverView.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/12/7.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLPopoverViewConfigure {
    ///箭头大小
    var arrowSize: CGSize = CGSize(width: 10, height: 10)
    ///边框圆角
    var popoverRadius: CGFloat = 8.0
    ///最小边距
    var sideEdge: CGFloat = 0
    ///箭头方向
    var arrowDirection: CLPopoverView.popoverDirection = .bottom
    ///遮罩颜色
    var maskBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.35)
    ///模糊
    var overlayBlur: UIBlurEffect? = nil
    ///气泡颜色
    var popoverColor: UIColor = .white
    ///遮罩是否允许点击消失
    var dismissOnBlackOverlayTap: Bool = true
    ///显示遮罩
    var showMask: Bool = true
    ///高亮FromView
    var highlightFromView: Bool = false
    ///高亮FromView圆角
    var highlightCornerRadius: CGFloat = 8
    ///显示阴影
    var showShadowy: Bool = true
    ///箭头所在位置比例
    var arrowPositionRatio: CGFloat = 0.5
    ///显示动画时间
    var showTimeInterval: TimeInterval = 0.35
    ///隐藏动画时间
    var dismissTimeInterval: TimeInterval = 0.35
    ///动画阻尼
    var springDamping: CGFloat = 0.8
    ///动画初始速度
    var initialSpringVelocity: CGFloat = 2
}

class CLPopoverView: UIView {
    enum popoverDirection: Int {
        case top
        case bottom
        case left
        case right
    }
    
    var willShowHandler: (() -> ())?
    var didShowHandler: (() -> ())?
    var willDismissHandler: (() -> ())?
    var didDismissHandler: (() -> ())?
    
    private var configure: CLPopoverViewConfigure = CLPopoverViewConfigure()
    private var blackOverlay: UIControl = UIControl()
    private var containerView: UIView!
    private var contentView: UIView!
    private var contentViewFrame: CGRect!
    private var arrowShowPoint: CGPoint!
    
    init(configureCallback: ((CLPopoverViewConfigure) -> ())? = nil) {
        super.init(frame: .zero)
        configureCallback?(configure)
        backgroundColor = .clear
        accessibilityViewIsModal = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLPopoverView {
    private var isCornerLeftArrow: Bool {
        return arrowShowPoint.x == frame.origin.x
    }
    private var isCornerRightArrow: Bool {
        return arrowShowPoint.x == frame.origin.x + bounds.width
    }
}
extension CLPopoverView {
    func show(_ contentView: UIView, fromView: UIView) {
        guard let rootView = UIApplication.shared.keyWindow else {
            return
        }
        show(contentView, fromView: fromView, inView: rootView)
    }
    @objc func dismiss() {
        if superview != nil {
            willDismissHandler?()
            UIView.animate(withDuration: configure.dismissTimeInterval, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
                self.blackOverlay.alpha = 0
            }){ _ in
                self.contentView.removeFromSuperview()
                self.blackOverlay.removeFromSuperview()
                self.removeFromSuperview()
                self.transform = CGAffineTransform.identity
                self.didDismissHandler?()
            }
        }
    }
}
extension CLPopoverView {
    private func show(_ contentView: UIView, fromView: UIView, inView: UIView) {
        let point: CGPoint
        switch configure.arrowDirection {
        case .top:
            point = inView.convert(
                CGPoint(
                    x: fromView.frame.origin.x + (fromView.frame.size.width / 2),
                    y: fromView.frame.origin.y
            ), from: fromView.superview)
            break
        case .bottom:
            point = inView.convert(
                CGPoint(
                    x: fromView.frame.origin.x + (fromView.frame.size.width / 2),
                    y: fromView.frame.origin.y + fromView.frame.size.height
            ), from: fromView.superview)
            break
        case .left:
            point = inView.convert(
                CGPoint(
                    x: fromView.frame.origin.x,
                    y: fromView.frame.origin.y + fromView.frame.height / 2.0
            ), from: fromView.superview)
            break
        case .right:
            point = inView.convert(
                CGPoint(
                    x: fromView.frame.origin.x + fromView.frame.size.width,
                    y: fromView.frame.origin.y + fromView.frame.height / 2.0
            ), from: fromView.superview)
            break
        }
        if configure.highlightFromView {
            createHighlightLayer(fromView: fromView, inView: inView)
        }
        show(contentView, point: point, inView: inView)
    }
    private func show(_ contentView: UIView, point: CGPoint, inView: UIView) {
        if configure.dismissOnBlackOverlayTap || configure.showMask {
            blackOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blackOverlay.frame = inView.bounds
            inView.addSubview(blackOverlay)
            if configure.showMask {
                if let overlayBlur = configure.overlayBlur {
                    let effectView = UIVisualEffectView(effect: overlayBlur)
                    effectView.frame = blackOverlay.bounds
                    effectView.isUserInteractionEnabled = false
                    blackOverlay.addSubview(effectView)
                } else {
                    if !configure.highlightFromView {
                        blackOverlay.backgroundColor = configure.maskBackgroundColor
                    }
                    blackOverlay.alpha = 0
                }
            }
            if configure.dismissOnBlackOverlayTap {
                blackOverlay.addTarget(self, action: #selector(CLPopoverView.dismiss), for: .touchUpInside)
            }
        }
        containerView = inView
        self.contentView = contentView
        contentView.backgroundColor = UIColor.clear
        contentView.layer.cornerRadius = configure.popoverRadius
        contentView.layer.masksToBounds = true
        arrowShowPoint = point
        show()
    }
    private func show() {
        setNeedsDisplay()
        setUI()
        willShowHandler?()
        transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: configure.showTimeInterval, delay: 0, usingSpringWithDamping: configure.springDamping, initialSpringVelocity: configure.initialSpringVelocity, options: UIView.AnimationOptions(), animations: {
            self.transform = CGAffineTransform.identity
        }, completion: { (_) in
            self.didShowHandler?()
        })
        UIView.animate(withDuration: configure.showTimeInterval, delay: 0, options: .curveLinear) {
            self.blackOverlay.alpha = 1
        }
    }
}
extension CLPopoverView {
    private func radians(_ degrees: CGFloat) -> CGFloat {
        return CGFloat.pi * degrees / 180
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let arrow = UIBezierPath()
        let color = configure.popoverColor
        let arrowPoint = containerView.convert(arrowShowPoint, to: self)
        switch configure.arrowDirection {
        case .top:
            arrow.move(to: CGPoint(x: arrowPoint.x, y: bounds.height))
            arrow.addLine(to: CGPoint(x: arrowPoint.x - configure.arrowSize.width * 0.5, y: isCornerLeftArrow ? configure.arrowSize.height : bounds.height - configure.arrowSize.height))
            arrow.addLine(to: CGPoint(x: configure.popoverRadius, y: bounds.height - configure.arrowSize.height))
            arrow.addArc(withCenter: CGPoint(x: configure.popoverRadius, y: bounds.height - configure.arrowSize.height - configure.popoverRadius),
                         radius: configure.popoverRadius,
                         startAngle: radians(90),
                         endAngle: radians(180),
                         clockwise: true)
            arrow.addLine(to: CGPoint(x: 0, y: configure.popoverRadius))
            arrow.addArc(withCenter: CGPoint(x: configure.popoverRadius, y: configure.popoverRadius),
                         radius: configure.popoverRadius,
                         startAngle: radians(180),
                         endAngle: radians(270),
                         clockwise: true)
            arrow.addLine(to: CGPoint(x: bounds.width - configure.popoverRadius, y: 0))
            arrow.addArc(withCenter: CGPoint(x: bounds.width - configure.popoverRadius, y: configure.popoverRadius),
                         radius: configure.popoverRadius,
                         startAngle: radians(270),
                         endAngle: radians(0),
                         clockwise: true)
            arrow.addLine(to: CGPoint(x: bounds.width, y: bounds.height - configure.arrowSize.height - configure.popoverRadius))
            arrow.addArc(withCenter: CGPoint(x: bounds.width - configure.popoverRadius, y: bounds.height - configure.arrowSize.height - configure.popoverRadius),
                         radius: configure.popoverRadius,
                         startAngle: radians(0),
                         endAngle: radians(90),
                         clockwise: true)
            arrow.addLine(to: CGPoint(x: arrowPoint.x + configure.arrowSize.width * 0.5, y: isCornerRightArrow ? configure.arrowSize.height : bounds.height - configure.arrowSize.height))
            break
        case .bottom:
            arrow.move(to: CGPoint(x: arrowPoint.x, y: 0))
            arrow.addLine(to: CGPoint(x: arrowPoint.x + configure.arrowSize.width * 0.5, y: isCornerRightArrow ? configure.arrowSize.height + bounds.height : configure.arrowSize.height))
            arrow.addLine(to: CGPoint(x: bounds.width - configure.popoverRadius, y: configure.arrowSize.height))
            arrow.addArc(withCenter: CGPoint(x: bounds.width - configure.popoverRadius, y: configure.arrowSize.height + configure.popoverRadius),
                         radius: configure.popoverRadius,
                         startAngle: radians(270.0),
                         endAngle: radians(0),
                         clockwise: true)
            arrow.addLine(to: CGPoint(x: bounds.width, y: bounds.height - configure.popoverRadius))
            arrow.addArc(withCenter: CGPoint(x: bounds.width - configure.popoverRadius, y: bounds.height - configure.popoverRadius),
                         radius: configure.popoverRadius,
                         startAngle: radians(0),
                         endAngle: radians(90),
                         clockwise: true)
            arrow.addLine(to: CGPoint(x: 0, y: bounds.height))
            arrow.addArc(withCenter: CGPoint(x: configure.popoverRadius, y: bounds.height - configure.popoverRadius),
                         radius: configure.popoverRadius,
                         startAngle: radians(90),
                         endAngle: radians(180),
                         clockwise: true)
            arrow.addLine(to: CGPoint(x: 0, y: configure.arrowSize.height + configure.popoverRadius))
            arrow.addArc(withCenter: CGPoint(x: configure.popoverRadius, y: configure.arrowSize.height + configure.popoverRadius),
                         radius: configure.popoverRadius,
                         startAngle: radians(180),
                         endAngle: radians(270),
                         clockwise: true)
            arrow.addLine(to: CGPoint(x: arrowPoint.x - configure.arrowSize.width * 0.5, y: isCornerLeftArrow ? configure.arrowSize.height + bounds.height : configure.arrowSize.height))
            break
        case .left:
            arrow.move(to: CGPoint(x: bounds.width, y: arrowPoint.y))
            arrow.addLine(to: CGPoint(x: bounds.width - configure.arrowSize.width, y: arrowPoint.y + configure.arrowSize.height * 0.5))
            arrow.addLine(to: CGPoint(x: bounds.width - configure.arrowSize.width, y: bounds.height - configure.popoverRadius))
            arrow.addArc(withCenter: CGPoint(x: bounds.width - configure.arrowSize.width - configure.popoverRadius, y: bounds.height - configure.popoverRadius),
                         radius: configure.popoverRadius,
                         startAngle: radians(0),
                         endAngle: radians(90),
                         clockwise: true)
            arrow.addLine(to: CGPoint(x: configure.popoverRadius, y: bounds.height))
            arrow.addArc(withCenter: CGPoint(x: configure.popoverRadius, y: bounds.height - configure.popoverRadius),
                         radius: configure.popoverRadius,
                         startAngle: radians(90),
                         endAngle: radians(180),
                         clockwise: true)
            arrow.addLine(to: CGPoint(x: 0, y: configure.popoverRadius))
            arrow.addArc(withCenter: CGPoint(x:configure.popoverRadius, y: configure.popoverRadius),
                         radius: configure.popoverRadius,
                         startAngle: radians(180),
                         endAngle: radians(270),
                         clockwise: true)
            arrow.addLine(to: CGPoint(x: bounds.width - configure.popoverRadius - configure.arrowSize.width, y: 0))
            arrow.addArc(withCenter: CGPoint(x: bounds.width - configure.popoverRadius - configure.arrowSize.width, y: configure.popoverRadius),
                         radius: configure.popoverRadius,
                         startAngle: radians(270),
                         endAngle: radians(0),
                         clockwise: true)
            arrow.addLine(to: CGPoint(x: bounds.width - configure.arrowSize.width, y: arrowPoint.y - configure.arrowSize.height * 0.5))
            break
        case .right:
            arrow.move(to: CGPoint(x: 0, y: arrowPoint.y))
            arrow.addLine(to: CGPoint(x: configure.arrowSize.width, y: arrowPoint.y - configure.arrowSize.height * 0.5))
            arrow.addLine(to: CGPoint(x: configure.arrowSize.width, y: configure.popoverRadius))
            arrow.addArc(withCenter: CGPoint(x:configure.arrowSize.width + configure.popoverRadius, y: configure.popoverRadius),
                         radius: configure.popoverRadius,
                         startAngle: radians(180),
                         endAngle: radians(270),
                         clockwise: true)
            arrow.addLine(to: CGPoint(x: bounds.width - configure.popoverRadius, y: 0))
            arrow.addArc(withCenter: CGPoint(x: bounds.width - configure.popoverRadius, y: configure.popoverRadius),
                         radius: configure.popoverRadius,
                         startAngle: radians(270),
                         endAngle: radians(0),
                         clockwise: true)
            arrow.addLine(to: CGPoint(x: bounds.width, y: bounds.height - configure.popoverRadius))
            arrow.addArc(withCenter: CGPoint(x: bounds.width - configure.popoverRadius, y: bounds.height - configure.popoverRadius),
                         radius: configure.popoverRadius,
                         startAngle: radians(0),
                         endAngle: radians(90),
                         clockwise: true)
            arrow.addLine(to: CGPoint(x: configure.popoverRadius, y: bounds.height))
            arrow.addArc(withCenter: CGPoint(x: configure.popoverRadius + configure.arrowSize.width, y: bounds.height - configure.popoverRadius),
                         radius: configure.popoverRadius,
                         startAngle: radians(90),
                         endAngle: radians(180),
                         clockwise: true)
            arrow.addLine(to: CGPoint(x: configure.arrowSize.width, y: arrowPoint.y + configure.arrowSize.height * 0.5))
            break
        }
        color.setFill()
        arrow.fill()
    }
}
extension CLPopoverView {
    private func createHighlightLayer(fromView: UIView, inView: UIView) {
        let path = UIBezierPath(rect: inView.bounds)
        let highlightRect = inView.convert(fromView.frame, from: fromView.superview)
        let highlightPath = UIBezierPath(roundedRect: highlightRect, cornerRadius: configure.highlightCornerRadius)
        path.append(highlightPath)
        path.usesEvenOddFillRule = true
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor = configure.maskBackgroundColor.cgColor
        blackOverlay.layer.addSublayer(fillLayer)
    }
    private func setUI()  {
        switch configure.arrowDirection {
        case .top:
            contentView.frame.origin.y = 0.0
        case .bottom:
            contentView.frame.origin.y = configure.arrowSize.height
        case .left:
            contentView.frame.origin.x = 0.0
        case .right:
            contentView.frame.origin.x = configure.arrowSize.width
        }
        addSubview(contentView)
        containerView.addSubview(self)
        create()
    }
    private func create() {
        var frame = contentView.frame
        switch configure.arrowDirection {
        case .top:
            frame = dealPopoverViewFrameInHorizontal(frame)
            break
        case .bottom:
            frame = dealPopoverViewFrameInHorizontal(frame)
            break
        case .left:
            frame.origin.y = arrowShowPoint.y - frame.size.height * configure.arrowPositionRatio
            break
        case .right:
            frame.origin.y = arrowShowPoint.y - frame.size.height * configure.arrowPositionRatio
            break
        }
        self.frame = frame
        
        let arrowPoint = containerView.convert(arrowShowPoint, to: self)
        var anchorPoint: CGPoint
        var tShadowOffset : CGSize = .zero
        switch configure.arrowDirection {
        case .top:
            frame.origin.y = arrowShowPoint.y - frame.height - configure.arrowSize.height
            anchorPoint = CGPoint(x: arrowPoint.x / frame.size.width, y: 1)
            frame.size.height += configure.arrowSize.height
            tShadowOffset = CGSize(width: 2, height: 0)
            break
        case .bottom:
            frame.origin.y = arrowShowPoint.y
            anchorPoint = CGPoint(x: arrowPoint.x / frame.size.width, y: 0)
            frame.size.height += configure.arrowSize.height
            tShadowOffset = CGSize(width: 2, height: 0)
            break
        case .left:
            frame.origin.x = arrowShowPoint.x - frame.width - configure.arrowSize.width
            anchorPoint = CGPoint(x: 1, y: arrowPoint.y / frame.size.height)
            frame.size.width += configure.arrowSize.width
            tShadowOffset = CGSize(width: 0, height: 2)
            break
        case .right:
            frame.origin.x = arrowShowPoint.x
            anchorPoint = CGPoint(x: 0, y: arrowPoint.y / frame.size.height)
            frame.size.width += configure.arrowSize.width
            tShadowOffset = CGSize(width: 0, height: 2)
            break
        }
        
        if configure.arrowSize == .zero {
            anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
        let lastAnchor = layer.anchorPoint
        layer.anchorPoint = anchorPoint
        let x = layer.position.x + (anchorPoint.x - lastAnchor.x) * layer.bounds.size.width
        let y = layer.position.y + (anchorPoint.y - lastAnchor.y) * layer.bounds.size.height
        layer.position = CGPoint(x: x, y: y)
                
        self.frame = frame
        if configure.showShadowy {
            layer.cornerRadius = 4
            layer.shadowColor = UIColor.init(red: 32.0 / 256.0 , green: 32.0 / 256.0, blue: 32.0 / 256.0, alpha: 0.5).cgColor
            layer.shadowOffset = tShadowOffset
            layer.shadowOpacity = 1
            layer.shadowRadius = 4
        }
    }
    private func dealPopoverViewFrameInHorizontal(_ frame : CGRect) -> CGRect {
        var tFrame = frame
        tFrame.origin.x = arrowShowPoint.x - tFrame.width * configure.arrowPositionRatio
        var sideEdge: CGFloat = 0.0
        if tFrame.width < containerView.frame.width {
            sideEdge = configure.sideEdge
        }
        let outerSideEdge = tFrame.maxX - containerView.bounds.width
        if outerSideEdge > 0 {
            tFrame.origin.x -= (outerSideEdge + sideEdge)
        } else if tFrame.minX < 0{
            tFrame.origin.x += abs(frame.minX) + sideEdge
        }
        return tFrame
    }
}

