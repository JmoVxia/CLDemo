//
//  CLIngredientLeftTitleHead.swift
//  CL
//
//  Created by Chen JmoVxia on 2021/11/12.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import SnapKit
import UIKit

// MARK: - JmoVxia---枚举

extension CLIngredientLeftTitleHead {}

// MARK: - JmoVxia---类-属性

class CLIngredientLeftTitleHead: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initUI()
        initData()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var backgroundShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .init("#F4F4F4")
        view.layer.maskedCorners = [.layerMaxXMinYCorner]
        return view
    }()

    private lazy var backgroundColorView: UIView = {
        let view = UIView()
        view.backgroundColor = .init("#F4F4F4")
        return view
    }()

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .mediumPingFangSC(16)
        view.textColor = .init("#666666")
        view.textAlignment = .left
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        return view
    }()

    var isTop: Bool = false {
        didSet {
            backgroundColorView.backgroundColor = isTop ? .white : .init("#F4F4F4")
        }
    }

    var isOpen: Bool = false {
        didSet {
            backgroundShadowView.backgroundColor = isOpen ? .init("#FFFFFF") : .init("#F4F4F4")
            titleLabel.font = isOpen ? .boldPingFangSC(16) : .mediumPingFangSC(16)
            titleLabel.textColor = isOpen ? .init("#333333") : .init("#666666")
            backgroundShadowView.layer.cornerRadius = isOpen ? 10 : 0
            backgroundShadowView.layer.applySketchShadow(color: isOpen ? .init("#000000", alpha: 0.05) : .init("#FFFFFF"), x: 0, y: -2, blur: 4)
            backgroundShadowView.snp.updateConstraints { make in
                make.top.equalTo(isOpen ? 4 : 0)
            }
        }
    }

    var clickCallback: (() -> Void)?
}

// MARK: - JmoVxia---布局

private extension CLIngredientLeftTitleHead {
    func initUI() {
        clipsToBounds = true
        contentView.addSubview(backgroundColorView)
        contentView.addSubview(backgroundShadowView)
        contentView.addSubview(titleLabel)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickAction)))
    }

    func makeConstraints() {
        backgroundColorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backgroundShadowView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(0)
        }
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(110)
        }
    }
}

// MARK: - JmoVxia---数据

private extension CLIngredientLeftTitleHead {
    func initData() {}
}

// MARK: - JmoVxia---override

extension CLIngredientLeftTitleHead {}

// MARK: - JmoVxia---objc

@objc private extension CLIngredientLeftTitleHead {
    func clickAction() {
        clickCallback?()
    }
}

// MARK: - JmoVxia---私有方法

private extension CLIngredientLeftTitleHead {}

// MARK: - JmoVxia---公共方法

extension CLIngredientLeftTitleHead {}
