//
//  CLChatPhotoAlbumBottomBar.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/6/30.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLChatPhotoAlbumBottomBar: UIView {
    var sendCallback: (() -> ())?
    var closeCallback: (() -> ())?
    ///是否可以发送
    var seletedNumber: Int = 0 {
        didSet {
            if oldValue != seletedNumber {
                let text = seletedNumber == 0 ? "  发送  " : "发送 (\(seletedNumber))"
                sendButton.setTitle(text, for: .normal)
                sendButton.setTitle(text, for: .selected)
                sendButton.setTitle(text, for: .highlighted)
                if seletedNumber > 0 {
                    sendButton.isUserInteractionEnabled = true
                    sendButton.setTitleColor(.white, for: .normal)
                    sendButton.setTitleColor(.white, for: .selected)
                    sendButton.setTitleColor(.white, for: .highlighted)
                    sendButton.backgroundColor = .hex("#2DD178")
                }else {
                    sendButton.isUserInteractionEnabled = false
                    sendButton.setTitleColor(.hex("#666666"), for: .normal)
                    sendButton.setTitleColor(.hex("#666666"), for: .selected)
                    sendButton.setTitleColor(.hex("#666666"), for: .highlighted)
                    sendButton.backgroundColor = .hex("#EEEEED")
                }
            }
        }
    }
    ///发送按钮
    private lazy var sendButton: UIButton = {
        let view = UIButton()
        view.isUserInteractionEnabled = false
        view.setTitle("  发送  ", for: .normal)
        view.setTitle("  发送  ", for: .selected)
        view.setTitle("  发送  ", for: .highlighted)
        view.setTitleColor(.hex("#666666"), for: .normal)
        view.setTitleColor(.hex("#666666"), for: .selected)
        view.setTitleColor(.hex("#666666"), for: .highlighted)
        view.backgroundColor = .hex("#EEEEED")
        view.titleLabel?.font = PingFangSCMedium(16)
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        view.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        view.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        return view
    }()
    ///关闭按钮
    private lazy var closeButton: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = PingFangSCMedium(16)
        view.setTitleColor(.hex("#333333"), for: .normal)
        view.setTitleColor(.hex("#333333"), for: .selected)
        view.setTitleColor(.hex("#333333"), for: .highlighted)
        view.setTitle("关闭", for: .normal)
        view.setTitle("关闭", for: .selected)
        view.setTitle("关闭", for: .highlighted)
        view.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        initUI()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLChatPhotoAlbumBottomBar {
    private func initUI() {
        seletedNumber = 0
        addSubview(closeButton)
        addSubview(sendButton)
    }
    private func makeConstraints() {
        closeButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        }
        sendButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
            make.height.equalTo(30)
        }
    }
}
extension CLChatPhotoAlbumBottomBar {
    @objc private func sendButtonAction() {
       sendCallback?()
    }
    @objc private func closeButtonAction() {
        closeCallback?()
    }
}
