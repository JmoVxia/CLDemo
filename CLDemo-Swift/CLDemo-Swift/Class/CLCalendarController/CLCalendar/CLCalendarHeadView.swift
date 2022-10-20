//
//  CLCalendarHeadView.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2022/10/19.
//

import SnapKit
import UIKit

// MARK: - JmoVxia---类-属性

class CLCalendarHeadView: UICollectionReusableView {
    static let reuseIdentifier = "CLCalendarHeadView"

    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.backgroundColor = .clear
        view.textColor = "#333333".uiColor
        view.font = .boldPingFangSC(14)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - JmoVxia---布局

private extension CLCalendarHeadView {
    func configUI() {
        addSubview(titleLabel)
    }

    func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
