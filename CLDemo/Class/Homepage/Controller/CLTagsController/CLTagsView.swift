//
//  CLTagsLabel.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/6.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLTagsView: UIView {
    var tagsMinPadding: CGFloat = 0.0 {
        didSet {
            label.snp.updateConstraints { (make) in
                make.left.equalTo(tagsMinPadding)
                make.right.equalTo(-tagsMinPadding)
            }
        }
    }
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.randomColor
        label.backgroundColor = UIColor.white
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 4
        layer.masksToBounds = true
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.left.equalTo(5)
            make.right.equalTo(-5)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
