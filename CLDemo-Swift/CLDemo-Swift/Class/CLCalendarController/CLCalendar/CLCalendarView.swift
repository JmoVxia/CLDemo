//
//  CLCalendarView.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2022/10/19.
//

import DateToolsSwift
import SnapKit
import UIKit

class CLCalendarView: UIView {
    private lazy var collectionView: UICollectionView = {
        let layout = CLCalendarFlowLayout()
        layout.headerReferenceSize = CGSize(width: 0, height: config.headerHight)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.register(CLCalendarCell.self, forCellWithReuseIdentifier: CLCalendarCell.reuseIdentifier)
        view.register(CLCalendarHeadView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CLCalendarHeadView.reuseIdentifier)
        return view
    }()

    private lazy var mainStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .zero
        view.spacing = 0
        return view
    }()

    private lazy var topStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.insetsLayoutMarginsFromSafeArea = false
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .zero
        view.spacing = 0
        return view
    }()

    weak var delegate: CLCalendarDelegate?

    private let chineseMonthArray = [
        "正月", "二月", "三月", "四月",
        "五月", "六月", "七月", "八月",
        "九月", "十月", "冬月", "腊月",
    ]

    private let chineseDayArray = [
        "初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
        "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
        "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十",
    ]

    private let chinese = Calendar(identifier: .chinese)

    private let todayDate = Date()

    private let weekArray = ["日", "一", "二", "三", "四", "五", "六"]

    private var config = CLCalendarConfig()

    private var startIndexPath: IndexPath?

    private var monthsArray = [CLCalendarMonthModel]()

    private var beginDate: Date?

    private var endDate: Date?

    private var itemSize = CGSize.zero

    init(frame: CGRect = .zero, config: CLCalendarConfig = CLCalendarConfig()) {
        super.init(frame: frame)
        configUI()
        makeConstraints()
        initDataSource()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CLCalendarView {
    func configUI() {
        backgroundColor = config.color.background
        mainStackView.insetsLayoutMarginsFromSafeArea = config.insetsLayoutMarginsFromSafeArea
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(topStackView)
        mainStackView.addArrangedSubview(collectionView)
        for i in 0 ..< weekArray.count {
            let label = UILabel()
            label.backgroundColor = config.color.topToolBackground
            label.text = weekArray[i]
            label.font = PingFangSCMedium(14)
            label.textAlignment = .center
            label.textColor = i == 0 || i == 6 ? config.color.topToolTextWeekend : config.color.topToolText
            topStackView.addArrangedSubview(label)
        }
    }

    func makeConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        topStackView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
}

extension CLCalendarView {
    func initDataSource() {
        func scrollToStartIndexPath() {
            guard !monthsArray.isEmpty else { return }
            collectionView.reloadData()
            collectionView.setNeedsLayout()
            collectionView.layoutIfNeeded()

            let indexPath: IndexPath = {
                if config.type == .past {
                    return IndexPath(row: 0, section: monthsArray.count - 1)
                } else if config.type == .today {
                    return IndexPath(row: 0, section: monthsArray.count / 2)
                } else {
                    return IndexPath(row: 0, section: 0)
                }
            }()

            collectionView.scrollToItem(at: startIndexPath ?? indexPath, at: .top, animated: false)
            collectionView.contentOffset = CGPoint(x: 0, y: collectionView.contentOffset.y - config.headerHight)
        }

        func month() -> [CLCalendarMonthModel] {
            func day(with date: Date, section: Int) -> [CLCalendarDayModel] {
                var newDate = date
                let tatalDay = newDate.daysInMonth
                let firstDay = max(0, newDate.weekday - 1)
                let columns = Int(ceil(CGFloat(tatalDay + firstDay) / CGFloat(weekArray.count)))
                var resultArray = [CLCalendarDayModel]()
                for column in 0 ..< columns {
                    for weekDay in 0 ..< weekArray.count {
                        if column == 0,
                           weekDay <= firstDay - 1
                        {
                            resultArray.append(CLCalendarDayModel())
                        } else {
                            let subtitle: String? = {
                                guard !newDate.isToday else { return "今天" }
                                guard config.isShowLunarCalendar else { return nil }
                                guard let index = chinese.dateComponents([.day], from: newDate).day else { return nil }
                                return chineseDayArray[index - 1]
                            }()
                            let type: CLCalendarDayModel.CLCalendarDayType = {
                                guard !newDate.isToday else { return .today }
                                guard newDate.compare(todayDate) == .orderedDescending else { return .future }
                                return .past
                            }()

                            let dayModel = CLCalendarDayModel(title: "\(newDate.day)", date: newDate, subtitle: subtitle, type: type)
                            resultArray.append(dayModel)
                            newDate = newDate + 1.days
                            if beginDate?.year == dayModel.date?.year,
                               beginDate?.month == dayModel.date?.month,
                               beginDate?.day == dayModel.date?.day
                            {
                                startIndexPath = .init(row: 0, section: section)
                            }
                            guard newDate.day != tatalDay else { break }
                        }
                    }
                }
                return resultArray
            }

            var resultArray = [CLCalendarMonthModel]()
            let month: Int = {
                var value = 0
                if config.type == .past {
                    value = config.limitMonth - 1
                } else if config.type == .today {
                    value = config.limitMonth / 2
                }
                return value
            }()

            let start = todayDate - month.months
            for i in 0 ..< config.limitMonth {
                let date = start + i.months
                let headerModel = CLCalendarMonthModel(headerText: date.format(with: "yyyy年MM月"),
                                                       month: date.format(with: "MM"),
                                                       daysArray: day(with: Date(year: date.year, month: date.month, day: 1), section: i))
                resultArray.append(headerModel)
            }
            return resultArray
        }

        DispatchQueue.global().async {
            self.beginDate = self.config.selectBegin
            self.endDate = self.config.selectEnd
            let tempDataArray = month()
            DispatchQueue.main.async {
                let width = self.collectionView.bounds.width
                let minimumDifference: Int = {
                    let value = Int(width) % self.weekArray.count
                    guard (value + Int(width)) % self.weekArray.count != 0 else { return value }
                    return self.weekArray.count - value
                }()
                let maxWidth = width - CGFloat(minimumDifference)
                let cellWidth = maxWidth / CGFloat(self.weekArray.count)
                self.itemSize = CGSize(width: cellWidth, height: cellWidth)
                self.mainStackView.layoutMargins = .init(top: 0, left: CGFloat(minimumDifference) * 0.5, bottom: 0, right: CGFloat(minimumDifference) * 0.5)
                self.monthsArray = tempDataArray
                scrollToStartIndexPath()
            }
        }
    }
}

extension CLCalendarView: CLCalendarDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataCell = collectionView.dequeueReusableCell(withReuseIdentifier: CLCalendarCell.reuseIdentifier, for: indexPath) as? CLCalendarCell else { return UICollectionViewCell(frame: .zero) }
        let model = monthsArray[indexPath.section].daysArray[indexPath.row]
        dataCell.refreshData(model, config: config, startDate: beginDate, endDate: endDate)
        return dataCell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CLCalendarHeadView.reuseIdentifier, for: indexPath) as! CLCalendarHeadView
            headerView.titleLabel.text = monthsArray[indexPath.section].headerText
            return headerView
        }
        return UICollectionReusableView(frame: .zero)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let headerItem = monthsArray[indexPath.section]
        let calendarItem = headerItem.daysArray[indexPath.row]
        guard let date = calendarItem.date else { return }
        func reloadDate() {
            if config.selectType == .single || config.touchType == .today {
                beginDate = date
                delegate?.didSelectSingle(date: date, in: self)
            } else {
                guard let start = beginDate else { return beginDate = date }
                guard endDate != nil || date < start else {
                    endDate = date
                    delegate?.didSelectArea(begin: start, end: date, in: self)
                    return
                }
                beginDate = date
                endDate = nil
            }
        }
        reloadDate()
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, textForSectionAt section: Int) -> String {
        return monthsArray[section].month
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, textColorForSectionAt section: Int) -> UIColor {
        return config.color.sectionBackgroundText
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
}

extension CLCalendarView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return monthsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthsArray[section].daysArray.count
    }
}
