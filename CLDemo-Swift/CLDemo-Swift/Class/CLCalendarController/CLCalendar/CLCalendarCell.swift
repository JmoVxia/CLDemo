//
//  CLCalendarCell.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2022/10/19.
//

import SnapKit
import UIKit

// MARK: - JmoVxia---类-属性

class CLCalendarCell: UICollectionViewCell {
    static let reuseIdentifier = "CLCalendarCell"

    private lazy var mainStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.insetsLayoutMarginsFromSafeArea = false
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .zero
        view.spacing = 10
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .mediumPingFangSC(13)
        return view
    }()

    private lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .mediumPingFangSC(10)
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

private extension CLCalendarCell {
    func configUI() {
        backgroundColor = .clear
        clipsToBounds = true
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(subtitleLabel)
    }

    func makeConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension CLCalendarCell {
    func refreshData(_ model: CLCalendarDayModel, config: CLCalendarConfig, startDate: Date?, endDate: Date?) {
        isUserInteractionEnabled = (config.touchType.contains(.past) && model.type == .future) || (config.touchType.contains(.future) && model.type == .past) || (config.touchType.contains(.today) && model.type == .today)
        backgroundColor = (model.type == .empty || isUserInteractionEnabled) ? .clear : config.color.failureBackground
        layer.cornerRadius = 0
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        titleLabel.textColor = !isUserInteractionEnabled ? config.color.failureTitleText : config.color.titleText
        subtitleLabel.textColor = model.type == .today ? config.color.todayText : (!isUserInteractionEnabled ? config.color.failureSubtitleText : config.color.subtitleText)
        guard model.type != .empty else { return }
        if model.date == startDate || model.date == endDate {
            titleLabel.textColor = config.color.selectTitleText
            subtitleLabel.textColor = model.type == .today ? config.color.selectTodayText : config.color.selectSubtitleText
            backgroundColor = model.date == startDate ? config.color.selectStartBackground : config.color.selectEndBackground
            layer.cornerRadius = 5
            let isAllCorners = config.selectType == .single || config.touchType == .today
            layer.maskedCorners = isAllCorners ? [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner] : (model.date == startDate ? [.layerMinXMinYCorner, .layerMinXMaxYCorner] : [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        } else if let date = model.date,
                  let start = startDate,
                  let end = endDate,
                  date > start,
                  date < end
        {
            titleLabel.textColor = isUserInteractionEnabled ? config.color.titleText : config.color.failureTitleText
            subtitleLabel.textColor = isUserInteractionEnabled ? (model.type == .today ? config.color.todayText : config.color.subtitleText) : config.color.failureSubtitleText
            backgroundColor = isUserInteractionEnabled ? config.color.selectBackground : config.color.failureBackground
        }
    }
}
