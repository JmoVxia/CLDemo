//
//  CLPopupMomentumController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/10/10.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLPopupMomentumController: CLPopupManagerController {
    private lazy var momentumView: CLMomentumView = {
        let view = CLMomentumView()
        view.backgroundColor = .orange
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
}
extension CLPopupMomentumController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        showAnimation()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            print(size.height * 0.6)
            let momentumView = self.momentumView
            momentumView.closedTransform = momentumView.isOpen ? .identity : CGAffineTransform(translationX: 0, y: (momentumView.bounds.height) * 0.6)
        }, completion: nil)
    }
}
extension CLPopupMomentumController {
    private func initUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        view.addSubview(momentumView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hidden))
        view.addGestureRecognizer(tap)
    }
    private func makeConstraints() {
        momentumView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(8)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-8)
            make.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(120)
        }
    }
}
extension CLPopupMomentumController {
    private func showAnimation() {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        let height = momentumView.bounds.height
        momentumView.closedTransform = .init(translationX: 0, y: height)
        UIView.animate(withDuration: 0.35) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
            self.momentumView.closedTransform = .init(translationX: 0, y: height * 0.6)
        }
    }
    private func dismissAnimation(completion: ((Bool) -> Void)? = nil) {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        let height = momentumView.bounds.height
        UIView.animate(withDuration: 0.35, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.momentumView.closedTransform = .init(translationX: 0, y: height)
        }, completion: completion)
    }
    @objc private func hidden() {
        dismissAnimation { (_) in
            CLPopupManager.dismiss(self.configure.identifier)
        }
    }
}
