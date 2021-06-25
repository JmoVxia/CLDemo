//
//  CLDrawerTransitionDelegate.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/3/23.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

class CLDrawerTransitionDelegate: NSObject {
    let slideAnimation = CLDrawerSlideAnimation()
}
extension CLDrawerTransitionDelegate: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CLDrawerPresentationController(presentedViewController: presented, presenting: presenting)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slideAnimation.isPresenting = true
        return slideAnimation
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slideAnimation.isPresenting = false
        return slideAnimation
    }
}
