//
//  CLBubbleTransition.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/14.
//

import UIKit

class CLBubbleTransition: NSObject {
    enum BubbleTransitionMode: Int {
        case present, dismiss
    }
    var duration = 0.5
    var transitionMode: BubbleTransitionMode = .present
    var itemCallback: (() -> (center: CGPoint, color: UIColor))?
}
extension CLBubbleTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let item = itemCallback?() else {  return }
        
        let containerView = transitionContext.containerView
        
        let fromViewController = transitionContext.viewController(forKey: .from)
        
        let toViewController = transitionContext.viewController(forKey: .to)
        
        if transitionMode == .present {
            guard let toControllerView = transitionContext.view(forKey: .to) else { return }
            fromViewController?.beginAppearanceTransition(false, animated: true)
            if toViewController?.modalPresentationStyle == .custom {
                toViewController?.beginAppearanceTransition(true, animated: true)
            }
            
            let originalCenter = toControllerView.center
            let originalSize = toControllerView.frame.size
            
            let bubble = UIView()
            bubble.frame = frameForBubble(originalCenter, size: originalSize, start: item.center)
            bubble.layer.cornerRadius = bubble.frame.size.height / 2
            bubble.center = item.center
            bubble.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            bubble.backgroundColor = item.color
            containerView.addSubview(bubble)
            
            toControllerView.center = item.center
            toControllerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            toControllerView.alpha = 0
            containerView.addSubview(toControllerView)
            
            UIView.animate(withDuration: duration, animations: {
                bubble.transform = .identity
                toControllerView.transform = CGAffineTransform.identity
                toControllerView.alpha = 1
                toControllerView.center = originalCenter
            }, completion: { (_) in
                transitionContext.completeTransition(true)
                bubble.isHidden = true
                if toViewController?.modalPresentationStyle == .custom {
                    toViewController?.endAppearanceTransition()
                }
                fromViewController?.endAppearanceTransition()
            })
        } else {
            guard let fromControllerView = transitionContext.view(forKey: .from) else { return }
            if fromViewController?.modalPresentationStyle == .custom {
                fromViewController?.beginAppearanceTransition(false, animated: true)
            }
            toViewController?.beginAppearanceTransition(true, animated: true)
                        
            let originalCenter = fromControllerView.center
            let originalSize = fromControllerView.frame.size

            let bubble = UIView()
            bubble.frame = frameForBubble(originalCenter, size: originalSize, start: item.center)
            bubble.layer.cornerRadius = bubble.frame.size.height / 2
            bubble.backgroundColor = item.color
            bubble.center = item.center
            bubble.transform = .identity
            containerView.addSubview(bubble)
            
            containerView.addSubview(fromControllerView)

            UIView.animate(withDuration: duration, animations: {
                bubble.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                fromControllerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                fromControllerView.center = item.center
                fromControllerView.alpha = 0
            }, completion: { (completed) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                bubble.removeFromSuperview()

                if !transitionContext.transitionWasCancelled {
                    fromControllerView.center = originalCenter
                    fromControllerView.removeFromSuperview()
                    
                    if fromViewController?.modalPresentationStyle == .custom {
                        fromViewController?.endAppearanceTransition()
                    }
                    toViewController?.endAppearanceTransition()
                }
            })
        }
    }
}
extension CLBubbleTransition {
    func frameForBubble(_ originalCenter: CGPoint, size originalSize: CGSize, start: CGPoint) -> CGRect {
        let lengthX = fmax(start.x, originalSize.width - start.x)
        let lengthY = fmax(start.y, originalSize.height - start.y)
        let offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2
        let size = CGSize(width: offset, height: offset)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
}

