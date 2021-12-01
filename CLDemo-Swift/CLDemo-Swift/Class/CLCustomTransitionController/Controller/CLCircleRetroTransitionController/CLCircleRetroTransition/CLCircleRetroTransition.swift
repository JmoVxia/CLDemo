//
//  CLCircleRetroTransition.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/16.
//

import UIKit

class CLCircleRetroTransition: NSObject {
    var animationEndedCallback: (() -> ())?
    var duration: TimeInterval = 0.5
}
extension CLCircleRetroTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let from = transitionContext.viewController(forKey: .from),
              let to = transitionContext.viewController(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        containerView.addSubview(to.view)
        containerView.addSubview(from.view)
        
        let radius = sqrt(pow(from.view.bounds.height / 2, 2) + pow(from.view.bounds.width / 2, 2))
        let circlePathStart = UIBezierPath(arcCenter: CGPoint(x: from.view.bounds.width / 2,y: from.view.bounds.height / 2), radius: CGFloat(radius), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let circlePathEnd = UIBezierPath(arcCenter: CGPoint(x: from.view.bounds.width / 2,y: from.view.bounds.height / 2), radius: CGFloat(1), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePathStart.cgPath
        shapeLayer.bounds = CGRect.init(x: 0, y: 0, width: from.view.bounds.width, height: from.view.bounds.height)
        shapeLayer.position = CGPoint(x: from.view.bounds.width / 2, y: from.view.bounds.height / 2)
        
        from.view.layer.mask = shapeLayer
        
        let animation : CLCABasicAnimation = CLCABasicAnimation()
        animation.keyPath = "path"
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.duration = duration
        animation.fromValue = circlePathStart.cgPath
        animation.toValue = circlePathEnd.cgPath
        animation.autoreverses = false
        animation.animationDidStopCallback = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            from.view.removeFromSuperview()
            from.view.layer.mask = nil
        }
        shapeLayer.add(animation, forKey: "path")
    }
    func animationEnded(_ transitionCompleted: Bool) {
        animationEndedCallback?()
    }
}
