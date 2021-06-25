//
//  CLDataPickerTitleView.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/7.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLDataPickerTitleView: UIView {
    var text: String? {
        didSet {
            titleLabel.text = text
        }
    }
    var margin: CGFloat = 0.0{
        didSet {
            titleLabel.snp.updateConstraints { (make) in
                make.left.equalTo(self.snp.centerX).offset(margin)
            }
        }
    }
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .right
        titleLabel.textColor = .themeColor
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        return titleLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.centerX).offset(0)
            make.top.bottom.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
