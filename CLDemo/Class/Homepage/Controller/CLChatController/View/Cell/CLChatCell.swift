//
//  CLChatCell.swift
//  CLDemo
//
//  Created by Emma on 2020/1/27.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import Lottie

class CLChatCell: UITableViewCell {
    ///数据item
    var item: CLChatItem? {
        didSet {
            guard let chatItem = item else {
                return
            }
            if chatItem != oldValue {
                upDateItem(chatItem)
            }
        }
    }
    ///底部内容view
    lazy var bottomContentView: UIView = {
        let bottomContentView = UIView()
        return bottomContentView
    }()
    ///发送中动画view
    lazy var sendingAnimation: AnimationView = {
        let view = AnimationView.init(animation: Animation.named("send_timeout"))
        view.loopMode = .loop
        view.isHidden = true
        view.backgroundBehavior = .pauseAndRestore
        return view
    }()
    ///发送失败
    lazy var sendFailButton: UIButton = {
        let sendFailButton = UIButton()
        sendFailButton.setImage(UIImage.init(named: "icon_failed"), for: .normal)
        sendFailButton.setImage(UIImage.init(named: "icon_failed"), for: .selected)
        sendFailButton.isHidden = true
        sendFailButton.addTarget(self, action: #selector(reSendMessage), for: .touchUpInside)
        return sendFailButton
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLChatCell {
    @objc private func reSendMessage() {
//        guard let chatItem = item  else {
//            return
//        }
//        presenter?.reSendMessageWithItem(chatItem)
    }
}
extension CLChatCell {
    ///创建UI
    @objc dynamic func initUI() {
        contentView.addSubview(bottomContentView)
        contentView.addSubview(sendingAnimation)
        contentView.addSubview(sendFailButton)
        backgroundColor = UIColor.clear
        selectionStyle = .none
    }
    ///布局
    @objc dynamic func makeConstraints() {
        sendingAnimation.snp.makeConstraints { (make) in
            make.size.equalTo(15)
            make.centerY.equalTo(bottomContentView)
            make.right.equalTo(bottomContentView.snp.left).offset(-7)
        }
        sendFailButton.snp.makeConstraints { (make) in
            make.size.equalTo(30)
            make.centerY.equalTo(bottomContentView)
            make.right.equalTo(bottomContentView.snp.left)
        }
    }
    @objc dynamic func upDateItem(_ item: CLChatItem) {
        if let _ = item as? CLChatTipsItem {
            return
        }
        if item.position == .right {
            switch item.messageSendState {
            case .sending:
                sendingAnimation.isHidden = false
                sendingAnimation.play()
                sendFailButton.isHidden = true
            case .sendFail:
                sendingAnimation.isHidden = true
                sendingAnimation.pause()
                sendFailButton.isHidden = false
            case .sendSucess:
                sendingAnimation.isHidden = true
                sendingAnimation.pause()
                sendFailButton.isHidden = true
            }
        }else {
            sendingAnimation.isHidden = true
            sendingAnimation.pause()
            sendFailButton.isHidden = true
        }
    }
}
