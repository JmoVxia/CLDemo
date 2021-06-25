//
//  CLFlopBottomView.swift
//  FUSHENG
//
//  Created by JmoVxia on 2019/12/26.
//  Copyright © 2019 FuSheng. All rights reserved.
//

import UIKit

class CLFlopBottomView: UIView {
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage.init(named: "FlopWant")
        return iconImageView
    }()
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "想要"
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = .hex("#FFFFFF")
        return titleLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconImageView)
        addSubview(titleLabel)

        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(0)
            make.left.equalTo(iconImageView.snp.right).offset(6)
            make.top.bottom.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
