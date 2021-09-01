//
//  CLIngredientSearchCell.swift
//  CL
//
//  Created by Chen JmoVxia on 2021/11/15.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

// MARK: - JmoVxia---类-属性

class CLIngredientSearchCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()

    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .hex("#F0F0F0")
        return view
    }()
}

// MARK: - JmoVxia---布局

private extension CLIngredientSearchCell {
    func initUI() {
        backgroundColor = .white
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        contentView.addSubview(lineView)
    }

    func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(15)
            make.bottom.equalTo(-15)
        }
        lineView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - JmoVxia---数据

private extension CLIngredientSearchCell {
    func initData() {}
}

// MARK: - JmoVxia---override

extension CLIngredientSearchCell {}

// MARK: - JmoVxia---objc

@objc private extension CLIngredientSearchCell {}

// MARK: - JmoVxia---私有方法

private extension CLIngredientSearchCell {}

// MARK: - JmoVxia---公共方法

extension CLIngredientSearchCell {}
