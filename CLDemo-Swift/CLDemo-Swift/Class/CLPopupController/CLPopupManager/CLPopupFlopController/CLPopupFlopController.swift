//
//  CLPopupFlopController.swift
//  FUSHENG
//
//  Created by JmoVxia on 2019/12/25.
//  Copyright © 2019 FuSheng. All rights reserved.
//

import UIKit

class CLPopupFlopController: CLPopupManagerController {
    var clickWantCallBack: (() -> ())?
    private var isFlop: Bool = false
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.isUserInteractionEnabled = true
        return contentView
    }()
    private lazy var topImageView: UIImageView = {
        let topImageView = UIImageView()
        topImageView.isUserInteractionEnabled = true
        topImageView.image = UIImage.init(named: "FlopTop")
        topImageView.clipsToBounds = true
        return topImageView
    }()
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage.init(named: "FlopcloseButton"), for: .normal)
        closeButton.setImage(UIImage.init(named: "FlopcloseButton"), for: .selected)
        closeButton.setImage(UIImage.init(named: "FlopcloseButton"), for: .highlighted)
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        return closeButton
    }()
    private lazy var leftFlopButton: CLTwoSidedView = {
        let leftFlopButton = CLTwoSidedView()
        leftFlopButton.topView = UIImageView.init(image: UIImage.init(named: "FlopCard"))
        leftFlopButton.bottomView = self.prizeView
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(flopButtonAction(tap:)))
        leftFlopButton.addGestureRecognizer(tap)
        return leftFlopButton
    }()
    private lazy var middleFlopButton: CLTwoSidedView = {
        let middleFlopButton = CLTwoSidedView()
        middleFlopButton.topView = UIImageView.init(image: UIImage.init(named: "FlopCard"))
        middleFlopButton.bottomView = self.prizeView
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(flopButtonAction(tap:)))
        middleFlopButton.addGestureRecognizer(tap)
        return middleFlopButton
    }()
    private lazy var rightFlopButton: CLTwoSidedView = {
        let rightFlopButton = CLTwoSidedView()
        rightFlopButton.topView = UIImageView.init(image: UIImage.init(named: "FlopCard"))
        rightFlopButton.bottomView = self.prizeView
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(flopButtonAction(tap:)))
        rightFlopButton.addGestureRecognizer(tap)
        return rightFlopButton
    }()
    private lazy var prizeView: CLFlopPrizeView = {
        let prizeView = CLFlopPrizeView()
        return prizeView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        contentView.addSubview(topImageView)
        contentView.addSubview(closeButton)
        contentView.addSubview(leftFlopButton)
        contentView.addSubview(middleFlopButton)
        contentView.addSubview(rightFlopButton)
        contentView.snp.makeConstraints { (make) in
            make.width.height.centerX.equalToSuperview()
            make.top.equalTo(view.snp.top).offset(view.frame.height)
        }
        topImageView.snp.makeConstraints { (make) in
            make.top.equalTo(227.5)
            make.centerX.equalTo(view)
            make.width.equalTo(245)
            make.height.equalTo(111)
        }
        let width: CGFloat = view.frame.width / 3.0
        let height: CGFloat = 358.0 / 297.0 * width
        leftFlopButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(topImageView.snp.bottom)
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
        middleFlopButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(topImageView.snp.bottom)
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
        rightFlopButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.equalTo(topImageView.snp.bottom)
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(topImageView.snp.bottom).offset(272.5)
            make.size.equalTo(32)
            make.centerX.equalTo(view)
        }
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        self.view.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.00)
        UIView.animate(withDuration: 0.35) {
            self.contentView.snp.updateConstraints { (make) in
                make.top.equalTo(self.view.snp.top)
            }
            self.view.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.40)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    func dismiss(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.35, animations: {
           self.contentView.snp.updateConstraints { (make) in
               make.top.equalTo(self.view.snp.top).offset(self.view.frame.height)
           }
           self.view.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.00)
           self.view.setNeedsLayout()
           self.view.layoutIfNeeded()
        }, completion: completion)
    }
    
    @objc func closeButtonAction() {
        dismiss { (_) in
            CLPopupManager.dismiss(self.configure.identifier)
        }
    }
    @objc func flopButtonAction(tap: UITapGestureRecognizer) {
        guard let view = tap.view as? CLTwoSidedView, !isFlop else {
            return
        }
        isFlop = true
        UIView.animate(withDuration: 0.5) {
            self.topImageView.alpha = 0.0
            self.leftFlopButton.alpha = self.leftFlopButton != view ? 0.0 : 1.0
            self.middleFlopButton.alpha = self.middleFlopButton != view ? 0.0 : 1.0
            self.rightFlopButton.alpha = self.rightFlopButton != view ? 0.0 : 1.0
        }
        view.snp.updateConstraints { (make) in
            make.width.equalTo(274)
            make.height.equalTo(324 + 40.5 + 17.5)
        }
        view.setNeedsLayout()
        view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            view.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(182.5)
                make.width.equalTo(274)
                make.height.equalTo(324 + 40.5 + 17.5)
            }
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
        view.transition(withDuration: 1, completion: nil)
    }
}
