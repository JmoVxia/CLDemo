//
//  CLIngredientRightTitleHead.swift
//  CL
//
//  Created by Chen JmoVxia on 2021/11/9.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import SnapKit
import UIKit

// MARK: - JmoVxia---枚举

extension CLIngredientRightTitleHead {}

// MARK: - JmoVxia---类-属性

class CLIngredientRightTitleHead: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initUI()
        makeConstraints()
        initData()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var backgroundColorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = PingFangSCBold(16)
        view.textColor = .init("#333333")
        view.textAlignment = .left
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        return view
    }()

    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .init("#F0F0F0")
        return view
    }()
}

// MARK: - JmoVxia---布局

private extension CLIngredientRightTitleHead {
    func initUI() {
        contentView.addSubview(backgroundColorView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(lineView)
    }

    func makeConstraints() {
        backgroundColorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
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

private extension CLIngredientRightTitleHead {
    func initData() {}
}

// MARK: - JmoVxia---override

extension CLIngredientRightTitleHead {}

// MARK: - JmoVxia---objc

@objc private extension CLIngredientRightTitleHead {}

// MARK: - JmoVxia---私有方法

private extension CLIngredientRightTitleHead {}

// MARK: - JmoVxia---公共方法

extension CLIngredientRightTitleHead {}
