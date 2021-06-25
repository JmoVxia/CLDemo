//
//  CLBubbleInteractiveTransition.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/14.
//

import UIKit

extension CLBubbleInteractiveTransition {
    enum BubbleInteractiveTransitionSwipeDirection: CGFloat {
      case up = -1
      case down = 1
    }
}

class CLBubbleInteractiveTransition: UIPercentDrivenInteractiveTransition {
    private var interactionStarted = false
    private var interactionShouldFinish = false
    private weak var controller: UIViewController?
    
    var interactionThreshold: CGFloat = 0.3
    
    var swipeDirection: BubbleInteractiveTransitionSwipeDirection = .down
    
    func attach(to: UIViewController) {
        controller = to
        controller?.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:))))
        if #available(iOS 10.0, *) {
            wantsInteractiveStart = false
        }
    }
}

extension CLBubbleInteractiveTransition {
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        guard let controller = controller, let view = controller.view else { return }
        
        let translation = gesture.translation(in: controller.view.superview)
        
        let delta = swipeDirection.rawValue * (translation.y / view.bounds.height)
        let movement = fmaxf(Float(delta), 0.0)
        let percent = fminf(movement, 1.0)
        let progress = CGFloat(percent)
        
        switch gesture.state {
        case .began:
            interactionStarted = true
            controller.dismiss(animated: true, completion: nil)
        case .changed:
            interactionShouldFinish = progress > interactionThreshold
            update(progress)
        case .cancelled:
            interactionShouldFinish ? finish() : cancel()
        case .ended:
            interactionStarted = false
            interactionShouldFinish ? finish() : cancel()
        default:
            break
        }
    }
}
