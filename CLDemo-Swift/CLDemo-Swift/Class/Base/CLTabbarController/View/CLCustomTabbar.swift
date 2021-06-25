//
//  CLCustomTabbar.swift
//  CKD
//
//  Created by JmoVxia on 2020/6/12.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLCustomTabbar: UITabBar {
    var bulgeCallBack: ((UITabBarItem) -> ())?
    private lazy var bulgeButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "recording"), for: .normal)
        view.setImage(UIImage(named: "recording"), for: .selected)
        view.setImage(UIImage(named: "recording"), for: .highlighted)
        view.addTarget(self, action: #selector(bulgeButtonAction), for: .touchUpInside)
        return view
    }()
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .hex("EEEEEE")
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        backgroundImage = UIImage()
        shadowImage = UIImage()
        tintColor = .hex("#666666")
        isTranslucent = false
        addSubview(lineView)
        addSubview(bulgeButton)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLCustomTabbar {
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = bounds.width
        let height = bounds.height
        var index = 0
        for subviews in subviews {
            if ("UITabBarButton" == NSStringFromClass(type(of: subviews).self)) {
                if index == 2 {
                    subviews.isHidden = true
                }
                index += 1
            }
        }
        bulgeButton.frame = CGRect(x: 0, y: 0, width: 81, height: 60)
        bulgeButton.center = CGPoint(x: width * 0.5, y: (height - safeAreaEdgeInsets.bottom) * 0.5 - 5)
        lineView.frame = CGRect(x: 0, y: 0, width: width, height: 0.5)
    }
}
extension CLCustomTabbar {
    ///判断点是否在响应范围
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let circle = UIBezierPath(arcCenter: bulgeButton.center, radius: 28, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        let tabbar = UIBezierPath(rect: bounds)
        if circle.contains(point) || tabbar.contains(point) {
            return true
        }
        return super.point(inside: point, with: event)
    }
}
@objc extension CLCustomTabbar {
    func bulgeButtonAction() {
        guard let item = items?[safe: 2] else { return }
        bulgeCallBack?(item)
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.mass = 0.6
        animation.stiffness = 80
        animation.damping = 10
        animation.initialVelocity = 0.5
        animation.duration = 0.5
        animation.fromValue = 0.25
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.6, 0.1, 0.30, 0.90)
        bulgeButton.layer.add(animation, forKey: nil)
    }
}
extension CLCustomTabbar {
    ///显示小红点
    func showBadgeOnItem(index: Int, badgeValue: Int) {
        guard let items = items, items.count > index else {
            return
        }
        let item = items[index]
        if badgeValue > 99 {
            item.badgeValue = "99+"
        }else {
            item.badgeValue = "\(badgeValue)"
        }
    }
    ///移除小红点
    func hiddenBadgeOnItem(index: Int) {
        guard let items = items, items.count > index else {
            return
        }
        let item = items[index]
        item.badgeValue = nil
    }
}
