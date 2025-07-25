//
//  CLRecordVernierCaliperCell.swift
//  CL
//
//  Created by JmoVxia on 2020/5/9.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLRecordVernierCaliperCell: UITableViewCell {
    var item: CLRecordVernierCaliperItem?

    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = .mediumPingFangSC(16)
        view.textColor = UIColor("#333333")
        return view
    }()

    private lazy var unitLabel: UILabel = {
        let view = UILabel()
        view.font = .mediumPingFangSC(16)
        view.textColor = UIColor("#999999")
        return view
    }()

    private lazy var valueBackgroundView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()

    private lazy var valueLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        return view
    }()

    private lazy var vernierCaliperView: CLVernierCaliperView = {
        let view = CLVernierCaliperView()
        view.indexValueCallback = { [weak self] value in
            guard let self, let item else { return }
            self.item?.value = value.cgFloat
            self.item?.valueChangeCallback?(value)
            valueLabel.attributedText = attributedString(value, type: item.type)
        }
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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CLRecordVernierCaliperCell {
    private func initUI() {
        isExclusiveTouch = true
        selectionStyle = .none
        contentView.addSubview(nameLabel)
        contentView.addSubview(unitLabel)
        contentView.addSubview(valueBackgroundView)
        valueBackgroundView.addSubview(valueLabel)
        contentView.addSubview(vernierCaliperView)
    }

    private func makeConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(20)
        }
        unitLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.right)
            make.centerY.equalTo(nameLabel)
            make.right.equalTo(-15).priority(200)
        }
        valueBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 110, height: 40))
        }
        valueLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        vernierCaliperView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(valueBackgroundView.snp.bottom).offset(5)
            make.height.equalTo(66)
            make.bottom.equalToSuperview().priority(200)
        }
    }
}

extension CLRecordVernierCaliperCell: CLRowProtocol {
    func setItem(_ item: CLRecordVernierCaliperItem, indexPath: IndexPath) {
        nameLabel.text = item.title
        unitLabel.text = "(\(item.unit))"
        valueBackgroundView.snp.updateConstraints { make in
            make.size.equalTo(item.valueBackgroundViewSize)
        }
        let value = NSDecimalNumber(value: Double(item.value))
        valueLabel.attributedText = attributedString(value.stringFormatter(withExample: NSDecimalNumber(floatLiteral: Double(item.minimumUnit))), type: item.type)
        vernierCaliperView.updateConfigure { configure in
            configure.minValue = item.minValue
            configure.maxValue = item.maxValue
            configure.gap = item.gap
            configure.minimumUnit = item.minimumUnit
            configure.unitInterval = item.unitInterval
        }
        vernierCaliperView.setValue(value: item.value, animated: false)
    }
}

extension CLRecordVernierCaliperCell {
    /// 获取指标和颜色
    private func getPhysical(type: CLRecordVernierCaliperItem.physicalType, value: CGFloat) -> (target: String, color: UIColor) {
        switch type {
        case .sbp:
            if value > 160 || value < 75 {
                ("危险", .init("#FF5757"))
            } else if value > 140 || value < 90 {
                ("超标", .init("#FFD118"))
            } else {
                ("正常", .theme)
            }
        case .dbp:
            if value > 110 || value < 50 {
                ("危险", .init("#FF5757"))
            } else if value > 90 || value < 60 {
                ("超标", .init("FFD118"))
            } else {
                ("正常", .theme)
            }
        case .glucose:
            if value > 11.1 {
                ("偏高", .init("#FF7474"))
            } else if value >= 8 {
                ("一般", .init("#65AAFF"))
            } else if value >= 6.1 {
                ("理想", .init("#33D27C"))
            } else if value >= 3.9 {
                ("良好", .init("#45DEC0"))
            } else {
                ("偏低", .init("#FFB81E"))
            }
        case .height:
            ("cm", .theme)
        case .weight:
            ("kg", .theme)
        case .pulse, .heartRate:
            if value > 100 {
                ("偏高", .init("#FF6060"))
            } else if value >= 60 {
                ("正常", .theme)
            } else {
                ("偏低", .init("#FFB618"))
            }
        case .temperature:
            if value > 37.2 {
                ("偏高", .init("#FF6060"))
            } else if value >= 36 {
                ("正常", .theme)
            } else {
                ("偏低", .init("#FFB618"))
            }
        case .urine:
            if value > 2000 {
                ("偏高", .init("#FF6060"))
            } else if value >= 800 {
                ("正常", .theme)
            } else {
                ("偏低", .init("#FFB618"))
            }
        case .respirationRate:
            if value > 85 {
                ("偏高", .init("#FF6060"))
            } else if value >= 67 {
                ("正常", .theme)
            } else {
                ("偏低", .init("#FFB618"))
            }
        case .unKnown:
            ("正常", .theme)
        }
    }
}

extension CLRecordVernierCaliperCell {
    private func attributedString(_ value: String, type: CLRecordVernierCaliperItem.physicalType) -> NSAttributedString {
        let valueAttrString = NSMutableAttributedString(string: value + " ")

        let startRang = NSRange(location: 0, length: valueAttrString.length)
        valueAttrString.addAttributes([.font: UIFont.monospacedDigitSystemFont(ofSize: 21, weight: .bold)], range: startRang)
        valueAttrString.addAttributes([.foregroundColor: UIColor.white], range: startRang)

        let physical = getPhysical(type: type, value: value.cgFloat)
        valueBackgroundView.backgroundColor = physical.color
        vernierCaliperView.updateIndexColor(physical.color)

        let unitAttrString = NSMutableAttributedString(string: physical.target)
        let nowRang = NSRange(location: 0, length: unitAttrString.length)
        let font = (item?.isSmallUnit ?? true) ? UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .medium) : UIFont.monospacedDigitSystemFont(ofSize: 21, weight: .bold)
        unitAttrString.addAttributes([.font: font], range: nowRang)
        unitAttrString.addAttributes([.foregroundColor: UIColor.white], range: nowRang)
        valueAttrString.append(unitAttrString)
        return valueAttrString
    }
}
