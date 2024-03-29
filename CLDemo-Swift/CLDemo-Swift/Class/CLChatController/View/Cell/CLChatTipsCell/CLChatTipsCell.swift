//
//  CLChatTipsCell.swift
//  Potato
//
//  Created by AUG on 2019/10/12.
//

import SnapKit
import UIKit

class CLChatTipsCell: CLChatCell {
    /// 背景
    lazy var textBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .init("#D9D9D9")
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()

    /// 文字label
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .mediumPingFangSC(14)
        view.numberOfLines = 0
        view.preferredMaxLayoutWidth = screenWidth - 80
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CLChatTipsCell {
    /// 创建UI
    override func initUI() {
        super.initUI()
        contentView.addSubview(textBackgroundView)
        textBackgroundView.addSubview(titleLabel)
    }

    /// 布局
    override func makeConstraints() {
        super.makeConstraints()
        textBackgroundView.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(30).priority(.high)
            make.right.lessThanOrEqualTo(-30).priority(.high)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.centerX.equalTo(contentView)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(textBackgroundView.snp.left).offset(12)
            make.right.equalTo(textBackgroundView.snp.right).offset(-12)
            make.top.equalTo(textBackgroundView.snp.top).offset(6.5)
            make.bottom.equalTo(textBackgroundView.snp.bottom).offset(-6.5)
        }
        bottomContentView.snp.makeConstraints { make in
            make.edges.equalTo(textBackgroundView)
        }
    }
}

extension CLChatTipsCell: CLRowProtocol {
    func setItem(_ item: CLChatTipsItem, indexPath: IndexPath) {
        titleLabel.text = item.text
    }
}
