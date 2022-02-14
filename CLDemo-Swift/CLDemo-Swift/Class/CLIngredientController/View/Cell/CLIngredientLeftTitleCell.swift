//
//  CLIngredientLeftTitleCell.swift
//  CL
//
//  Created by Chen JmoVxia on 2021/11/12.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

// MARK: - JmoVxia---类-属性

class CLIngredientLeftTitleCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var backgroundColorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMaxXMaxYCorner]
        return view
    }()

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = PingFangSCMedium(14)
        view.textColor = .init("#666666")
        view.textAlignment = .left
        return view
    }()

    override var isSelected: Bool {
        didSet {
            backgroundColorView.backgroundColor = isSelected ? .init("#EDFBF3") : .white
            titleLabel.textColor = isSelected ? .init("#24C065") : .init("#666666")
        }
    }

    var isBottom: Bool = false {
        didSet {
            backgroundColorView.layer.cornerRadius = isBottom ? 10 : 0
            backgroundColorView.layer.applySketchShadow(color: isBottom ? .init("#000000", alpha: 0.05) : .init("#FFFFFF", alpha: 0.05), x: 0, y: 2, blur: 4)
            backgroundColorView.snp.updateConstraints { make in
                make.bottom.equalTo(isBottom ? -4 : 0).priority(100)
            }
        }
    }
}

// MARK: - JmoVxia---布局

private extension CLIngredientLeftTitleCell {
    func initUI() {
        backgroundColor = .init("#F4F4F4")
        selectionStyle = .none
        contentView.addSubview(backgroundColorView)
        contentView.addSubview(titleLabel)
    }

    func makeConstraints() {
        backgroundColorView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(0).priority(100)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.centerY.equalTo(backgroundColorView)
        }
    }
}

// MARK: - JmoVxia---数据

private extension CLIngredientLeftTitleCell {
    func initData() {}
}

// MARK: - JmoVxia---override

extension CLIngredientLeftTitleCell {}

// MARK: - JmoVxia---objc

@objc private extension CLIngredientLeftTitleCell {}

// MARK: - JmoVxia---私有方法

private extension CLIngredientLeftTitleCell {}

// MARK: - JmoVxia---公共方法

extension CLIngredientLeftTitleCell {}
