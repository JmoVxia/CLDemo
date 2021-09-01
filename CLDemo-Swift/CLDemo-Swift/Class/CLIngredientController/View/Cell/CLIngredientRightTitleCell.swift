//
//  CLIngredientRightTitleCell.swift
//  CL
//
//  Created by Chen JmoVxia on 2021/11/9.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

// MARK: - JmoVxia---类-属性

class CLIngredientRightTitleCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.setContentHuggingPriority(.required, for: .vertical)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        return view
    }()
}

// MARK: - JmoVxia---布局

private extension CLIngredientRightTitleCell {
    func initUI() {
        selectionStyle = .none
        backgroundColor = .white
        contentView.addSubview(titleLabel)
    }

    func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(15)
            make.bottom.equalTo(-15)
        }
    }
}

// MARK: - JmoVxia---数据

private extension CLIngredientRightTitleCell {
    func initData() {}
}

// MARK: - JmoVxia---override

extension CLIngredientRightTitleCell {}

// MARK: - JmoVxia---objc

@objc private extension CLIngredientRightTitleCell {}

// MARK: - JmoVxia---私有方法

private extension CLIngredientRightTitleCell {}

// MARK: - JmoVxia---公共方法

extension CLIngredientRightTitleCell {}
