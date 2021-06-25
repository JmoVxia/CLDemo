//
//  CLDataPickerView.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/3/30.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import DateToolsSwift

class CLYearMonthDayDataPickerView: UIView {
    var year: Int {
        return yearArray[yearIndex]
    }
    var month: Int {
        return monthArray[monthIndex]
    }
    var day: Int {
        return dayArray[dayIndex]
    }
    private var minDate: Date = Date()
    private var maxDate: Date = Date()
    private var yearIndex: Int = 0
    private var monthIndex: Int = 0
    private var dayIndex: Int = 0
    private lazy var yearArray: [Int] = [Int]()
    private lazy var monthArray: [Int] = [Int]()
    private lazy var dayArray: [Int] = [Int]()
    private lazy var yearLabel: CLDataPickerTitleView = {
        let yearLabel = CLDataPickerTitleView()
        yearLabel.text = "年"
        yearLabel.margin = 30
        return yearLabel
    }()
    private lazy var monthLabel: CLDataPickerTitleView = {
        let monthLabel = CLDataPickerTitleView()
        monthLabel.text = "月"
        monthLabel.margin = 21
        return monthLabel
    }()
    private lazy var dayLabel: CLDataPickerTitleView = {
        let dayLabel = CLDataPickerTitleView()
        dayLabel.text = "日"
        dayLabel.margin = 21
        return dayLabel
    }()
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLYearMonthDayDataPickerView {
    private func initUI() {
        backgroundColor = UIColor.white
        addSubview(yearLabel)
        addSubview(monthLabel)
        addSubview(dayLabel)
        addSubview(pickerView)
    }
    private func makeConstraints() {
        yearLabel.snp.makeConstraints { (make) in
            make.left.equalTo(pickerView)
            make.centerY.equalTo(pickerView)
        }
        monthLabel.snp.makeConstraints { (make) in
            make.left.equalTo(yearLabel.snp.right)
            make.centerY.equalTo(pickerView)
            make.width.equalTo(yearLabel)
        }
        dayLabel.snp.makeConstraints { (make) in
            make.right.equalTo(pickerView)
            make.left.equalTo(monthLabel.snp.right)
            make.centerY.equalTo(pickerView)
            make.width.equalTo(monthLabel)
        }
        pickerView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.left.equalTo(self.safeAreaLayoutGuide).offset(15)
                make.right.equalTo(self.safeAreaLayoutGuide).offset(-15)
                make.bottom.equalTo(self.safeAreaLayoutGuide)
            } else {
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview()
            }
            make.top.equalToSuperview()
        }
    }
}
extension CLYearMonthDayDataPickerView {
    func set(minDate: Date, maxDate: Date) {
        self.minDate = min(minDate, maxDate)
        self.maxDate = max(minDate, maxDate)
        yearArray = Array(minDate.year...maxDate.year)
        let nowDate = Date()
        let date = min(max(minDate, nowDate), maxDate)
        select(year: date.year, month: date.month, day: date.day)
    }
}
extension CLYearMonthDayDataPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return [yearArray.count, monthArray.count, dayArray.count][component]
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}
extension CLYearMonthDayDataPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label: UILabel = (view as? UILabel) ?? UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        var textColor = UIColor.hex("#333333")
        let currentColor = UIColor.hex("#333333")
        if component == 0 {
            textColor  = yearIndex == row ? currentColor : textColor
            label.text =  String(format: "%02d", yearArray[row])
        }else if component == 1 {
            textColor  = monthIndex == row ? currentColor : textColor
            label.text =  String(format: "%02d", monthArray[row])
        }else if component == 2 {
            textColor  = dayIndex == row ? currentColor : textColor
            label.text =  String(format: "%02d", dayArray[row])
        }
        label.textColor = textColor
        return label
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            yearIndex = row
        }else if component == 1 {
            monthIndex = row
        }else if component == 2 {
            dayIndex = row
        }
        let seletedDate = Date(year: year, month: month, day: day)
        let date = min(max(minDate, seletedDate), maxDate)
        if component < 2 {
            select(year: date.year, month: date.month, day: date.day)
        }
    }
}
extension CLYearMonthDayDataPickerView {
    @discardableResult private func monthFrom(year: Int) -> Int {
        if year == minDate.year, year == maxDate.year {
            monthArray = Array(minDate.month...maxDate.month)
        }else if year == minDate.year {
            monthArray = Array(minDate.month...12)
        }else if year == maxDate.year {
            monthArray = Array(1...maxDate.month)
        }else {
            monthArray = Array(1...12)
        }
        return monthArray.count
    }
    @discardableResult private func daysFrom(year: Int, month: Int) -> Int {
        let isRunNian = year % 4 == 0 ? (year % 100 == 0 ? (year % 400 == 0 ? true : false) : true) : false
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            dayArray = Array(1...31)
        case 4, 6, 9, 11:
            dayArray = Array(1...30)
        case 2:
            if isRunNian {
                dayArray = Array(1...29)
            } else {
                dayArray = Array(1...28)
            }
        default:
            break
        }
        if year == minDate.year, year == maxDate.year {
            if month == minDate.month, month == maxDate.month {
                dayArray = Array(minDate.day...maxDate.day)
            }else if month == minDate.month {
                dayArray = Array(minDate.day...dayArray.count)
            }else if month == maxDate.month {
                dayArray = Array(1...maxDate.day)
            }
        }else if year == minDate.year, month == minDate.month {
            dayArray = Array(minDate.day...dayArray.count)
        }else if year == maxDate.year, month == maxDate.month {
            dayArray = Array(1...maxDate.day)
        }
        return dayArray.count
    }
}
extension CLYearMonthDayDataPickerView {
    private func select(year: Int, month: Int, day: Int) {
        monthFrom(year: year)
        daysFrom(year: year, month: month)
        pickerView.reloadAllComponents()
        yearIndex = yearArray.firstIndex(of: year) ?? 0
        monthIndex = monthArray.firstIndex(of: month) ?? 0
        dayIndex = dayArray.firstIndex(of: day) ?? 0
        pickerView.selectRow(yearIndex, inComponent: 0, animated: false)
        pickerView.selectRow(monthIndex, inComponent: 1, animated: false)
        pickerView.selectRow(dayIndex, inComponent: 2, animated: false)
    }
}

