//
//  CLRotateImageView.swift
//  CLDemo
//
//  Created by AUG on 2019/3/29.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit

class CLRotateImageView: UIImageView {

    private let rotationAnimation: CABasicAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
    private var isPause: Bool = false
    private weak var fatherView: UIView!
    
    init(frame: CGRect, superview: UIView) {
        super.init(frame: frame)
        image = UIImage.init(named: "icon_friend")
        superview.addSubview(self)
        fatherView = superview
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showAnimating() {
        alpha = 1
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = .pi * 2.0;
        rotationAnimation.duration = 1.0;
        rotationAnimation.isCumulative = true;
        rotationAnimation.repeatCount = MAXFLOAT;
        layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func hiddenAnimating() {
        let keyWindow = UIApplication.shared.keyWindow
        keyWindow?.addSubview(self)
        let oldFrame: CGRect = convert(bounds, to: keyWindow)
        let newFrame: CGRect = CGRect(x: oldFrame.minX, y: oldFrame.minY - 100.0, width: oldFrame.width, height: oldFrame.height)
        
        UIView.animate(withDuration: 2, animations: {
            self.frame = newFrame
            self.alpha = 0;
        }) { (finish) in
            self.fatherView.addSubview(self)
            self.frame = oldFrame
        }
    }
}

