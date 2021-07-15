//
//  CLCABasicAnimation.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/16.
//

import UIKit

class CLCABasicAnimation: CABasicAnimation, CAAnimationDelegate {
    var animationDidStopCallback: (() -> ())?
    override init() {
        super.init()
        delegate = self
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animationDidStopCallback?()
    }
}
