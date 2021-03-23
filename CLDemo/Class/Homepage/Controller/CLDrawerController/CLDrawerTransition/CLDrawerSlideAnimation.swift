//
//  CLDrawerSlideAnimation.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/3/23.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

class CLDrawerSlideAnimation: NSObject {
    var isPresenting: Bool = true
}
extension CLDrawerSlideAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let key: UITransitionContextViewControllerKey = isPresenting ? .to : .from
        guard let presentedController = transitionContext.viewController(forKey: key) else {
            return
        }

        let containerView = transitionContext.containerView
        let presentedFrame = transitionContext.finalFrame(for: presentedController)
        let dismissedFrame = presentedFrame.offsetBy(dx: presentedFrame.width, dy: 0)

        if isPresenting {
            containerView.addSubview(presentedController.view)
        }

        let duration = transitionDuration(using: transitionContext)
        let wasCancelled = transitionContext.transitionWasCancelled

        let fromFrame = isPresenting ? dismissedFrame : presentedFrame
        let toFrame = isPresenting ? presentedFrame : dismissedFrame

        presentedController.view.frame = fromFrame

        UIView.animate(withDuration: duration) {
            presentedController.view.frame = toFrame
        } completion: { (_) in
            transitionContext.completeTransition(!wasCancelled)
        }
    }
}
