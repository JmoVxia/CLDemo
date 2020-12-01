//
//  CLHistogramIndexView.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/12/9.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLHistogramIndexView: UIView {
    lazy var indexView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 1
        view.clipsToBounds = true
        return view
    }()
    lazy var indexLabel: UILabel = {
        let view = UILabel()
        view.font = PingFangSCMedium(10)
        view.textColor = UIColor.orange.withAlphaComponent(0.5)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(indexView)
        addSubview(indexLabel)
        indexView.snp.makeConstraints { (make) in
            make.centerY.left.equalToSuperview()
            make.size.equalTo(CGSize(width: 8, height: 3))
        }
        indexLabel.snp.makeConstraints { (make) in
            make.left.equalTo(indexView.snp.right).offset(5)
            make.centerY.right.top.bottom.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
