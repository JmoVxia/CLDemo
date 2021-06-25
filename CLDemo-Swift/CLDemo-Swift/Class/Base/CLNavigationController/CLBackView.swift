//
//  CLBackView.swift
//  CL
//
//  Created by Chen JmoVxia on 2020/10/16.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit


//MARK: - JmoVxia---类-属性
class CLBackView: UIControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var title: String = "    " {
        didSet {
            textLabel.text = title
            textLabel.sizeToFit()
            super.setNeedsLayout()
            super.layoutIfNeeded()
        }
    }
    var themeColor: UIColor = .black {
        didSet {
            backimageView.image = UIImage(named: "navigationBack")
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
        view.image = UIImage(named: "navigationBack")?.tintImage(themeColor)
        return view
    }()
}
//MARK: - JmoVxia---布局
private extension CLBackView {
    func initUI() {
        addSubview(backimageView)
        addSubview(textLabel)
    }
    func makeConstraints() {
        backimageView.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.width.equalTo(20);
            make.height.equalTo(20);
            make.bottom.equalTo(-5).priority(.low);
            make.top.equalTo(5).priority(.low);
        }
        textLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backimageView.snp.right).offset(7);
            make.centerY.equalToSuperview();
            make.right.equalTo(0).priority(.high);
        }
    }
}
