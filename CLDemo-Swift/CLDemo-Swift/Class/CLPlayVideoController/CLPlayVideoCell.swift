//
//  CLPlayVideoCell.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/4/28.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import SnapKit
import UIKit

class CLPlayVideoCell: UITableViewCell {
    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = .mediumPingFangSC(16)
        view.textColor = .black
        view.textAlignment = .left
        return view
    }()

    lazy var animageView: UIView = {
        let view = UIView()
        return view
    }()

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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CLPlayVideoCell: CLRowCellProtocol {
    func setItem(_ item: CLPlayVideoitem, indexPath: IndexPath) {
        nameLabel.text = item.path.lastPathComponent
        animageView.snp.updateConstraints { make in
            make.size.equalTo(item.size)
        }
        CLVideoPlayer.startPlay(item.path) { image, imagePath in
            self.animageView.layer.contents = image
        }
    }
}
