//
//  CLTwoSidedView.swift
//  CLDemo
//
//  Created by JmoVxia on 2019/12/27.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit

class CLTwoSidedView: UIView {
    var topView: UIView? {
        didSet {
            guard let view = topView else {
                return
            }
            addSubview(view)
        }
    }
    var bottomView: UIView?
    
    private var isTurning: Bool = false
    private var isReversed: Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        topView?.frame = bounds
        bottomView?.frame = bounds
    }
}
extension CLTwoSidedView {
    func transition(withDuration duration: TimeInterval, completion: (() -> Void)?) {
        guard !isTurning, let top = topView, let bottom = bottomView else {
            return
        }
        isTurning = true
        if isReversed {
            UIView.transition(from: bottom, to: top, duration: duration, options: .transitionFlipFromLeft) { _ in
                completion?()
                self.isTurning = false
                self.isReversed = false
            }
        } else {
            UIView.transition(from: top, to: bottom, duration: duration, options: .transitionFlipFromRight) { _ in
                completion?()
                self.isTurning = false
                self.isReversed = true
            }
        }
    }
}
