//
//  CLPopupFoodPickerContentCell.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/14.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLPopupFoodPickerContentCell: UITableViewCell {
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = PingFangSCMedium(16)
        label.textColor = .hex("#666666")
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        isExclusiveTouch = true
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(11)
            make.bottom.equalTo(-11)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
