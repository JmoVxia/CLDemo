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

    private var isReversed: Bool = false

    private let lock = NSRecursiveLock()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
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
        lock.lock()
        guard let topView, let bottomView else {
            lock.unlock()
            return
        }
        let fromView = isReversed ? bottomView : topView
        let toView = isReversed ? topView : bottomView
        let options: UIView.AnimationOptions = isReversed ? .transitionFlipFromLeft : .transitionFlipFromRight
        UIView.transition(from: fromView, to: toView, duration: duration, options: options) { _ in
            completion?()
            self.isReversed = false
            self.lock.unlock()
        }
    }
}
