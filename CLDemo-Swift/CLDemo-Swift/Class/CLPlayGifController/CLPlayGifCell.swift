//
//  CLPlayGifCell.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/5/31.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import SDWebImage
import UIKit

// MARK: - JmoVxia---类-属性

class CLPlayGifCell: UITableViewCell {
    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = .mediumPingFangSC(16)
        view.textColor = .black
        view.textAlignment = .left
        return view
    }()

    private lazy var animageView: SDAnimatedImageView = {
        let view = SDAnimatedImageView()
        return view
    }()

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(nameLabel)
        contentView.addSubview(animageView)
        nameLabel.snp.makeConstraints { make in
            make.left.top.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(20)
        }
        animageView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.size.equalTo(0)
        }
    }

    var item: CLPlayGifItem?
}

extension CLPlayGifCell: CLRowCellProtocol {
    func setItem(_ item: CLPlayGifItem, indexPath: IndexPath) {
        nameLabel.text = item.path.lastPathComponent
        animageView.snp.updateConstraints { make in
            make.size.equalTo(item.size)
        }
        animageView.sd_setImage(with: URL(fileURLWithPath: item.path))
    }
}
