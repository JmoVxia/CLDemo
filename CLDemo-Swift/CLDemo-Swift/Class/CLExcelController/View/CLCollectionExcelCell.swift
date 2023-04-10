//
//  CLCollectionExcelCell.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2023/4/6.
//

import UIKit

class CLCollectionExcelCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .mediumPingFangSC(16)
        view.preferredMaxLayoutWidth = screenWidth * 0.35
        view.textAlignment = .center
        return view
    }()

    private(set) lazy var lineTop: UIView = {
        let view = UIView()
        view.backgroundColor = "#FFECCB".uiColor
        return view
    }()

    private(set) lazy var lineLeft: UIView = {
        let view = UIView()
        view.backgroundColor = "#FFECCB".uiColor
        return view
    }()

    private(set) lazy var lineBottom: UIView = {
        let view = UIView()
        view.backgroundColor = "#FFECCB".uiColor
        return view
    }()

    private(set) lazy var lineRight: UIView = {
        let view = UIView()
        view.backgroundColor = "#FFECCB".uiColor
        return view
    }()

    private var lineWidth = 1
}

// MARK: - JmoVxia---布局

private extension CLCollectionExcelCell {
    func initSubViews() {
        backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(lineTop)
        contentView.addSubview(lineLeft)
        contentView.addSubview(lineBottom)
        contentView.addSubview(lineRight)
    }

    func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        lineTop.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(lineWidth)
        }
        lineLeft.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(lineWidth)
        }
        lineBottom.snp.makeConstraints { make in
            make.right.left.bottom.equalToSuperview()
            make.height.equalTo(lineWidth)
        }
        lineRight.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(lineWidth)
        }
    }
}

// MARK: - JmoVxia---override

extension CLCollectionExcelCell {}

// MARK: - JmoVxia---objc

@objc private extension CLCollectionExcelCell {}

// MARK: - JmoVxia---私有方法

private extension CLCollectionExcelCell {}

// MARK: - JmoVxia---公共方法

extension CLCollectionExcelCell {}
