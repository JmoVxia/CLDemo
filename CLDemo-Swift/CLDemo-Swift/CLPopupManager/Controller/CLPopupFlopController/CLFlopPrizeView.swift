//
//  CLFlopPrizeView.swift
//  FUSHENG
//
//  Created by JmoVxia on 2019/12/27.
//  Copyright © 2019 FuSheng. All rights reserved.
//

import UIKit

class CLFlopPrizeView: UIView {
    var numberImage: UIImage? {
        didSet {
            numberImageView.image = numberImage
        }
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Prize")
        return imageView
    }()

    private lazy var numberImageView: UIImageView = {
        let numberImageView = UIImageView()
        numberImageView.image = UIImage(named: "number-2")
        return numberImageView
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "商品需要2人助力即可免费获得"
        titleLabel.font = UIFont.systemFont(ofSize: 14.5)
        titleLabel.textColor = .init("#FFFFFF")
        return titleLabel
    }()

    private lazy var flopBottomView: CLFlopBottomView = {
        let flopBottomView = CLFlopBottomView()
        flopBottomView.iconImageView.image = UIImage(named: "share")
        flopBottomView.titleLabel.text = "邀请好友助力"
        flopBottomView.titleLabel.textColor = .init("#F90815")
        flopBottomView.titleLabel.font = UIFont.systemFont(ofSize: 13)
        flopBottomView.isUserInteractionEnabled = false
        return flopBottomView
    }()

    private lazy var bottomButton: UIButton = {
        let bottomButton = UIButton()
        bottomButton.setImage(UIImage(named: "FlopBottomButton2"), for: .normal)
        bottomButton.setImage(UIImage(named: "FlopBottomButton2"), for: .selected)
        bottomButton.setImage(UIImage(named: "FlopBottomButton2"), for: .highlighted)
        bottomButton.addTarget(self, action: #selector(bottomButtonAction), for: .touchUpInside)
        return bottomButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.addSubview(numberImageView)
        imageView.addSubview(titleLabel)
        addSubview(bottomButton)
        bottomButton.addSubview(flopBottomView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(324)
            make.width.equalTo(247)
            make.top.equalToSuperview()
        }
        numberImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-38.5)
        }
        bottomButton.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.width.equalTo(208)
            make.centerX.bottom.equalToSuperview()
        }
        flopBottomView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        setNeedsLayout()
        layoutIfNeeded()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CLFlopPrizeView {
    @objc func bottomButtonAction() {}
}
