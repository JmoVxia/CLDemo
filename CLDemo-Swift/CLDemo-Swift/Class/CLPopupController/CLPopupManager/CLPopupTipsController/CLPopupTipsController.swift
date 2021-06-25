//
//  CLPopupTipsController.swift
//  Potato
//
//  Created by Emma on 2020/1/8.
//

import UIKit


class CLPopupTipsController: CLPopupManagerController {
    var text: String? {
        didSet {
            label.text = text
        }
    }
    var dismissInterval: TimeInterval = 1.0
    var dissmissCallBack: (() -> ())?
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        return label
    }()
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.alpha = 0.0
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        return backgroundView
    }()
}
extension CLPopupTipsController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        showAnimation()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.layer.cornerRadius = backgroundView.frame.height * 0.25
        backgroundView.clipsToBounds = true
    }
}
extension CLPopupTipsController {
    private func initUI() {
        view.backgroundColor = UIColor.clear
        view.addSubview(backgroundView)
        backgroundView.addSubview(label)
    }
    private func makeConstraints() {
        backgroundView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.75)
        }
        label.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview().offset(-10)
        }
    }
}
extension CLPopupTipsController {
    private func showAnimation() {
        UIView.animate(withDuration: 0.35, animations: {
            self.backgroundView.alpha = 1.0
        }, completion: { (_) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.dismissInterval) {
                self.dismissAnimation { (_) in
                    CLPopupManager.dismiss(self.configure.identifier)
                    self.dissmissCallBack?()
                }
            }
        })
    }
    private func dismissAnimation(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.35, animations: {
            self.backgroundView.alpha = 0.0
        }, completion: completion)
    }
}
