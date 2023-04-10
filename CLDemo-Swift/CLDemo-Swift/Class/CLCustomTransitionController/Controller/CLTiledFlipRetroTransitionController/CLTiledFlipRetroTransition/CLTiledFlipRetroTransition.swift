//
//  CLTiledFlipRetroTransition.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/16.
//

import UIKit

class CLTiledFlipRetroTransition: NSObject {
    var animationEndedCallback: (() -> Void)?
    var duration: TimeInterval = 0.5
}

extension CLTiledFlipRetroTransition {
    private func flipSegment(toViewImage: UIImage, fromViewImage: UIImage, delay: TimeInterval, rect: CGRect, animationTime: CGFloat, parentView: UIView) {
        guard let cgToImage = toViewImage.cgImage,
              let cgFromImage = fromViewImage.cgImage,
              let toImageRef = cgToImage.cropping(to: CGRect(x: toViewImage.scale * rect.origin.x, y: toViewImage.scale * rect.origin.y, width: toViewImage.scale * rect.size.width, height: toViewImage.scale * rect.size.height)),
              let fromImageRef = cgFromImage.cropping(to: CGRect(x: fromViewImage.scale * rect.origin.x, y: fromViewImage.scale * rect.origin.y, width: fromViewImage.scale * rect.size.width, height: fromViewImage.scale * rect.size.height))
        else {
            return
        }

        let toImage = UIImage(cgImage: toImageRef)
        let toImageView = UIImageView()
        toImageView.clipsToBounds = true
        toImageView.frame = rect
        toImageView.image = toImage

        let fromImage = UIImage(cgImage: fromImageRef)
        let fromImageView = UIImageView()
        fromImageView.clipsToBounds = true
        fromImageView.frame = rect
        fromImageView.image = fromImage

        let containerView = UIView()
        containerView.frame = fromImageView.frame
        containerView.backgroundColor = UIColor.clear

        fromImageView.frame.origin = CGPoint.zero
        toImageView.frame.origin = CGPoint.zero

        containerView.addSubview(fromImageView)
        parentView.addSubview(containerView)

        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .curveEaseInOut]
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.transition(with: containerView, duration: TimeInterval(animationTime), options: transitionOptions, animations: {
                containerView.addSubview(toImageView)
                fromImageView.removeFromSuperview()
            })
        }
    }
}

extension CLTiledFlipRetroTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to),
              let snapshotToVc = toVC.view.snapshot,
              let snapshotFromVc = fromVC.view.snapshot else { return }

        let containerView = transitionContext.containerView
        fromVC.view.removeFromSuperview()

        let parentView = UIView()
        parentView.backgroundColor = UIColor.clear
        parentView.frame = fromVC.view.frame
        containerView.addSubview(parentView)

        let squareSizeWidth: CGFloat = fromVC.view.bounds.size.width / 5
        let squareSizeHeight: CGFloat = fromVC.view.bounds.size.height / 10

        let numRows = 1 + Int(toVC.view.bounds.size.width / squareSizeWidth)
        let numCols = 1 + Int(toVC.view.bounds.size.height / squareSizeWidth)
        for x in 0 ... numRows {
            for y in 0 ... numCols {
                let rect = CGRect(x: CGFloat(x) * squareSizeWidth, y: CGFloat(y) * squareSizeHeight, width: squareSizeWidth, height: squareSizeHeight)

                let randomPercent = Float(arc4random()) / Float(UINT32_MAX)
                let delay = TimeInterval(Float(duration * 0.5) * randomPercent)

                flipSegment(toViewImage: snapshotToVc, fromViewImage: snapshotFromVc, delay: delay, rect: rect, animationTime: CGFloat(duration / 2), parentView: parentView)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(duration)) {
            containerView.addSubview(toVC.view)
            parentView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

    func animationEnded(_ transitionCompleted: Bool) {
        animationEndedCallback?()
    }
}
