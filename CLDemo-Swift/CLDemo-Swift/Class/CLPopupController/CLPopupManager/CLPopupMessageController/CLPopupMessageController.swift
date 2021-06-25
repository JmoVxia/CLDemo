//
//  CLMessagePopupController.swift
//  Potato
//
//  Created by Emma on 2020/1/9.
//

import UIKit


enum CLPopupMessageType {
    ///一个按钮
    case one
    ///两个按钮
    case two
}

class CLPopupMessageController: CLPopupManagerController {
    var type: CLPopupMessageType = .one
    var sureCallBack: (() -> ())?
    var leftCallBack: (() -> ())?
    var rightCallBack: (() -> ())?
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .hex("0xc3c3c8")
        contentView.alpha = 0.0
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        return contentView
    }()
    private lazy var titleBackgroundView: UIView = {
        let titleBackgroundView = UIView()
        titleBackgroundView.backgroundColor = UIColor.white
        return titleBackgroundView
    }()
    private lazy var messageBackgroundView: UIView = {
        let messageBackgroundView = UIView()
        messageBackgroundView.backgroundColor = UIColor.white
        return messageBackgroundView
    }()
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        return titleLabel
    }()
    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.backgroundColor = UIColor.clear
        messageLabel.textColor = UIColor.black
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 13)
        return messageLabel
    }()
    lazy var sureButton: UIButton = {
        let sureButton = UIButton()
        sureButton.setBackgroundImage(.imageWithColor(UIColor.white), for: .normal)
        sureButton.setBackgroundImage(.imageWithColor(UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.00)), for: .highlighted)
        sureButton.setTitleColor(UIColor.hex("0x007ee5"), for: .normal)
        sureButton.setTitleColor(UIColor.hex("0x007ee5"), for: .selected)
        sureButton.setTitleColor(UIColor.hex("0x007ee5"), for: .highlighted)
        sureButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        sureButton.addTarget(self, action: #selector(sureButtonAction), for: .touchUpInside)
        return sureButton
    }()
    lazy var leftButton: UIButton = {
        let leftButton = UIButton()
        leftButton.setBackgroundImage(.imageWithColor(UIColor.white), for: .normal)
        leftButton.setBackgroundImage(.imageWithColor(UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.00)), for: .highlighted)
        leftButton.setTitleColor(UIColor.hex("0x007ee5"), for: .normal)
        leftButton.setTitleColor(UIColor.hex("0x007ee5"), for: .selected)
        leftButton.setTitleColor(UIColor.hex("0x007ee5"), for: .highlighted)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        leftButton.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        return leftButton
    }()
    lazy var rightButton: UIButton = {
        let rightButton = UIButton()
        rightButton.setBackgroundImage(.imageWithColor(UIColor.white), for: .normal)
        rightButton.setBackgroundImage(.imageWithColor(UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.00)), for: .highlighted)
        rightButton.setTitleColor(UIColor.hex("0x007ee5"), for: .normal)
        rightButton.setTitleColor(UIColor.hex("0x007ee5"), for: .selected)
        rightButton.setTitleColor(UIColor.hex("0x007ee5"), for: .highlighted)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        rightButton.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        return rightButton
    }()
}
extension CLPopupMessageController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        showAnimation()
    }
}
extension CLPopupMessageController {
    private func initUI() {
        view.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.00)
        view.addSubview(contentView)
        contentView.addSubview(titleBackgroundView)
        contentView.addSubview(messageBackgroundView)
        titleBackgroundView.addSubview(titleLabel)
        messageBackgroundView.addSubview(messageLabel)
        contentView.addSubview(sureButton)
        contentView.addSubview(leftButton)
        contentView.addSubview(rightButton)
        sureButton.isHidden = type != .one
        leftButton.isHidden = type == .one
        rightButton.isHidden = type == .one
    }
    private func makeConstraints() {
        let hasTitle: Bool = titleLabel.text != nil
        let hasMessage: Bool = messageLabel.text != nil
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(270)
        }
        titleBackgroundView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(hasTitle ? 20 : 0)
            make.bottom.equalToSuperview().offset(hasTitle ? -20 : 0)
        }
        messageBackgroundView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleBackgroundView.snp.bottom)
        }
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(hasMessage ? -20 : 0)
            make.top.equalToSuperview().offset((hasMessage && !hasTitle) ? 20 : 0)
        }
        sureButton.snp.makeConstraints { (make) in
            make.top.equalTo(messageBackgroundView.snp.bottom).offset(1/UIScreen.main.scale)
            make.height.equalTo(44)
            make.left.right.bottom.equalToSuperview()
        }
        leftButton.snp.makeConstraints { (make) in
            make.top.equalTo(messageBackgroundView.snp.bottom).offset(1/UIScreen.main.scale)
            make.height.equalTo(44)
            make.width.equalTo((270 - 1/UIScreen.main.scale) * 0.5)
            make.left.bottom.equalToSuperview()
        }
        rightButton.snp.makeConstraints { (make) in
            make.top.equalTo(messageBackgroundView.snp.bottom).offset(1/UIScreen.main.scale)
            make.height.equalTo(44)
            make.width.equalTo((270 - 1/UIScreen.main.scale) * 0.5)
            make.right.bottom.equalToSuperview()
        }
    }
}
extension CLPopupMessageController {
    private func showAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.40)
            self.contentView.alpha = 1.0
        }
        contentView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        UIView.animate(withDuration: 0.35, delay: 0.0, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(7<<16)), animations: {
            self.contentView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    private func dismissAnimation(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.00)
            self.contentView.alpha = 0.0
        }, completion: completion)
    }
}
extension CLPopupMessageController {
    @objc func sureButtonAction() {
        dismissAnimation { (_) in
            
            CLPopupManager.dismiss(self.configure.identifier)
            self.sureCallBack?()
            self.sureCallBack = nil
        }
    }
    @objc func leftButtonAction() {
        dismissAnimation { (_) in
            
            CLPopupManager.dismiss(self.configure.identifier)
            self.leftCallBack?()
            self.leftCallBack = nil;
        }
    }
    @objc func rightButtonAction() {
        dismissAnimation { (_) in
            
            CLPopupManager.dismiss(self.configure.identifier)
            self.rightCallBack?()
            self.rightCallBack = nil;
        }
    }
}
