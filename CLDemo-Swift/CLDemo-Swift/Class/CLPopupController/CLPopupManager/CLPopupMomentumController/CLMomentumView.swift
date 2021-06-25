//
//  CLMomentumView.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/10/10.
//  Copyright © 2020 JmoVxia. All rights reserved.
// from https://github.com/jackhub/fluid-interfaces

import UIKit

class CLMomentumPanGestureRecognizer: UIPanGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.state = .began
    }
}

class CLMomentumView: CLGradientLayerView {
    var closedTransform: CGAffineTransform = .identity {
        didSet {
            transform = closedTransform
        }
    }
    private lazy var panRecognier: CLMomentumPanGestureRecognizer = {
        let pan = CLMomentumPanGestureRecognizer()
        pan.addTarget(self, action: #selector(panned))
        return pan
    }()
    private (set) var isOpen = false
    private var animator = UIViewPropertyAnimator()
    private var animationProgress: CGFloat = 0
    private lazy var handleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(panRecognier)
        colors = [UIColor.hex("#fdbb2d").cgColor, UIColor.hex("#22c1c3").cgColor]
        addSubview(handleView)
        handleView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 50, height: 6))
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLMomentumView {
    @objc private func panned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startAnimationIfNeeded()
            animator.pauseAnimation()
            animationProgress = animator.fractionComplete
        case .changed:
            var fraction = -recognizer.translation(in: self).y / closedTransform.ty
            if isOpen { fraction *= -1 }
            if animator.isReversed { fraction *= -1 }
            animator.fractionComplete = fraction + animationProgress
        case .ended, .cancelled:
            let yVelocity = recognizer.velocity(in: self).y
            let shouldClose = yVelocity > 0
            if yVelocity == 0 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            if isOpen {
                if !shouldClose && !animator.isReversed { animator.isReversed.toggle() }
                if shouldClose && animator.isReversed { animator.isReversed.toggle() }
            } else {
                if shouldClose && !animator.isReversed { animator.isReversed.toggle() }
                if !shouldClose && animator.isReversed { animator.isReversed.toggle() }
            }
            let fractionRemaining = 1 - animator.fractionComplete
            let distanceRemaining = fractionRemaining * closedTransform.ty
            if distanceRemaining == 0 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            let relativeVelocity = min(abs(yVelocity) / distanceRemaining, 5)
            let timingParameters = UISpringTimingParameters(damping: 0.8, response: 0.3, initialVelocity: CGVector(dx: relativeVelocity, dy: relativeVelocity))
            let preferredDuration = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters).duration
            let durationFactor = CGFloat(preferredDuration / animator.duration)
            animator.continueAnimation(withTimingParameters: timingParameters, durationFactor: durationFactor)
        default: break
        }
    }
    private func startAnimationIfNeeded() {
        if animator.isRunning { return }
        let timingParameters = UISpringTimingParameters(damping: 1, response: 0.4)
        animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
        animator.addAnimations {
            self.transform = self.isOpen ? self.closedTransform : .identity
        }
        animator.addCompletion { position in
            if position == .end { self.isOpen.toggle() }
        }
        animator.startAnimation()
    }
}
