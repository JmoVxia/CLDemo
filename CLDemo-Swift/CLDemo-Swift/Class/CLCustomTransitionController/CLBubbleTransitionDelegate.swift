//
//  CLBubbleTransitionDelegate.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/14.
//

import UIKit

class CLBubbleTransitionDelegate: NSObject {
    let transition = CLBubbleTransition()
    let interactiveTransition = CLBubbleInteractiveTransition()
    private var startCallback: (() -> (center: CGPoint, color: UIColor))!
    private var endCallback: (() -> (center: CGPoint, color: UIColor))!
    init(startCallback: @escaping (() -> (center: CGPoint, color: UIColor)), endCallback: @escaping (() -> (center: CGPoint, color: UIColor))) {
        self.startCallback = startCallback
        self.endCallback = endCallback
    }
}
extension CLBubbleTransitionDelegate: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.itemCallback = startCallback
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.itemCallback = endCallback
        return transition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
}
