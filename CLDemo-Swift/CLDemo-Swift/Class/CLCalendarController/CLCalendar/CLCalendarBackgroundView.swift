//
//  CLCalendarBackgroundView.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2022/10/19.
//
import SnapKit
import UIKit

// MARK: - JmoVxia---类-属性

class CLCalendarBackgroundView: UICollectionReusableView {
    static let reuseIdentifier = "CLCollectionReusableView"

    private lazy var textLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.font = .boldPingFangSC(80)
        view.textAlignment = .center
        view.isUserInteractionEnabled = false
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

private extension CLCalendarBackgroundView {
    func configUI() {
        isUserInteractionEnabled = false
        addSubview(textLabel)
    }

    func makeConstraints() {
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - JmoVxia---override

extension CLCalendarBackgroundView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? CLCalendarLayoutAttributes else { return }
        textLabel.textColor = attributes.textColor
        textLabel.text = attributes.month
    }
}
