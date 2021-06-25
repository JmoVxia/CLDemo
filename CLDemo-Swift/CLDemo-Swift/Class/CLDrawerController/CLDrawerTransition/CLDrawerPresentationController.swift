//
//  CLDrawerPresentationController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/3/23.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

class CLDrawerPresentationController: UIPresentationController {
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.0
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPresentedController))
        view.addGestureRecognizer(tapRecognizer)
        return view
    }()
}
extension CLDrawerPresentationController {
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width * 0.6, height: parentSize.height)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return .zero
        }
        return CGRect(x: containerView.bounds.width * 0.4, y: 0, width: containerView.bounds.width * 0.6, height: containerView.bounds.height)
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func presentationTransitionWillBegin() {
        guard  let containerView = containerView else {
            return
        }

        containerView.insertSubview(dimmingView, at: 0)
        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1
            return
        }
        coordinator.animate { (_) in
            self.dimmingView.alpha = 1
        }
    }

    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0
            return
        }
        coordinator.animate { (_) in
            self.dimmingView.alpha = 0
        }
    }
}
extension CLDrawerPresentationController {
    @objc private func dismissPresentedController() {
        presentedViewController.dismiss(animated: true)
    }
}
