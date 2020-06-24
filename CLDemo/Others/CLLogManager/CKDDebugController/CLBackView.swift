//
//  CLBackView.swift
//  CKD
//
//  Created by JmoVxia on 2020/6/12.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLBackView: UIControl {
    var title: String = "    "{
        didSet {
            textLabel.text = title
            textLabel.sizeToFit()
            super.setNeedsLayout()
            super.layoutIfNeeded()
        }
    }
    var themeColor: UIColor = .black {
        didSet {
            backimageView.image = UIImage(named: "navigationBack")?.tintedImage(color: themeColor)
            textLabel.textColor = themeColor;
        }
    }
    private lazy var textLabel: UILabel = {
       let view = UILabel()
        view.textColor = themeColor
        view.font = PingFangSCMedium(16)
        return view
    }()
    private lazy var backimageView: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(named: "navigationBack")
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backimageView)
        addSubview(textLabel)
        backimageView.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.width.equalTo(20);
            make.height.equalTo(20);
            make.bottom.equalTo(-5).priority(.low);
            make.top.equalTo(5).priority(.low);
        }
        textLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backimageView.snp.right).offset(7);
            make.centerY.equalTo(0);
            make.right.equalTo(0).priority(.high);
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
