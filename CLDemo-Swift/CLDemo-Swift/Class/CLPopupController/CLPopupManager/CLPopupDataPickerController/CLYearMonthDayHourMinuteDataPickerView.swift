//
//  CLYearMonthDayHourMinuteDataPickerView.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/7.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLYearMonthDayHourMinuteDataPickerView: UIView {
    var year: Int {
        return yearArray[yearIndex]
    }
    var month: Int {
        return monthArray[monthIndex]
    }
    var day: Int {
        return dayArray[dayIndex]
    }
    var hour: Int {
        return hourArray[hourIndex]
    }
    var minute: Int {
        return minuteArray[minuteIndex]
    }
    private var nowDate: Date = Date(timeIntervalSinceNow: 0)
    private var yearIndex: Int = 0
    private var monthIndex: Int = 0
    private var dayIndex: Int = 0
    private var hourIndex: Int = 0
    private var minuteIndex: Int = 0
    private lazy var yearArray: [Int] = {
        var yearArray = [Int]()
        for item in (nowDate.year - 10)...(nowDate.year) {
            yearArray.append(item)
        }
        return yearArray
    }()
    private lazy var monthArray: [Int] = {
        var monthArray = [Int]()
        return monthArray
    }()
    private lazy var dayArray: [Int] = {
        let dayArray = [Int]()
        return dayArray
    }()
    private lazy var hourArray: [Int] = {
        let hourArray = Array(0...23)
        return hourArray
    }()
    private lazy var minuteArray: [Int] = {
        let minuteArray = Array(0...59)
        return minuteArray
    }()
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
    private lazy var hourLabel: CLDataPickerTitleView = {
        let hourLabel = CLDataPickerTitleView()
        hourLabel.text = "时"
        hourLabel.margin = 21
        return hourLabel
    }()
    private lazy var minuteLabel: CLDataPickerTitleView = {
        let minuteLabel = CLDataPickerTitleView()
        minuteLabel.text = "分"
        minuteLabel.margin = 21
        return minuteLabel
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
        
        select(year: nowDate.year, month: nowDate.month, day: nowDate.day, hour: nowDate.hour, minute: nowDate.minute)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLYearMonthDayHourMinuteDataPickerView {
    private func initUI() {
        backgroundColor = UIColor.white
        addSubview(yearLabel)
        addSubview(monthLabel)
        addSubview(dayLabel)
        addSubview(hourLabel)
        addSubview(minuteLabel)
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
            make.left.equalTo(monthLabel.snp.right)
            make.centerY.equalTo(pickerView)
            make.width.equalTo(monthLabel)
        }
        hourLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dayLabel.snp.right)
            make.centerY.equalTo(pickerView)
            make.width.equalTo(dayLabel)
        }
        minuteLabel.snp.makeConstraints { (make) in
            make.left.equalTo(hourLabel.snp.right)
            make.right.equalTo(pickerView)
            make.centerY.equalTo(pickerView)
            make.width.equalTo(hourLabel)
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
extension CLYearMonthDayHourMinuteDataPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let years = yearArray.count
        let months = monthFrom(year: yearArray[yearIndex])
        let days = daysFrom(year: yearArray[yearIndex], month: monthArray[monthIndex])
        let hours = hourFrom(year: yearArray[yearIndex], month: monthArray[monthIndex], day: dayArray[dayIndex])
        let minutes = minuteFrom(year: yearArray[yearIndex], month: monthArray[monthIndex], day: dayArray[dayIndex], hour: hourArray[hourIndex])
        let array = [years, months, days, hours, minutes]
        return array[component]
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}
extension CLYearMonthDayHourMinuteDataPickerView: UIPickerViewDelegate {
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
        }else if component == 3 {
            textColor  = hourIndex == row ? currentColor : textColor
            label.text =  String(format: "%02d", hourArray[row])
        }else if component == 4 {
            textColor  = minuteIndex == row ? currentColor : textColor
            label.text =  String(format: "%02d", minuteArray[row])
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
        }else if component == 3 {
            hourIndex = row
        }else if component == 4 {
            minuteIndex = row
        }
        if component < 4 {
            let months = monthFrom(year: yearArray[yearIndex])
            monthIndex = min(monthIndex, months - 1)
            let days = daysFrom(year: yearArray[yearIndex], month: monthArray[monthIndex])
            dayIndex = min(dayIndex, days - 1)
            let hours = hourFrom(year: yearArray[yearIndex], month: monthArray[monthIndex], day: dayArray[dayIndex])
            hourIndex = min(hourIndex, hours - 1)
        }
        pickerView.reloadAllComponents()
    }
}
extension CLYearMonthDayHourMinuteDataPickerView {
    @discardableResult private func monthFrom(year: Int) -> Int {
        let month = year == nowDate.year ? nowDate.month : 12
        monthArray = Array(1...month)
        return month
    }
    @discardableResult private func daysFrom(year: Int, month: Int) -> Int {
        let isRunNian = year % 4 == 0 ? (year % 100 == 0 ? (year % 400 == 0 ? true : false) : true) : false
        var days: Int = 0
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            dayArray = Array(1...31)
            days = 31
        case 4, 6, 9, 11:
            dayArray = Array(1...30)
            days = 30
        case 2:
            if isRunNian {
                dayArray = Array(1...29)
                days = 29
            } else {
                dayArray = Array(1...28)
                days = 28
            }
        default:
            break
        }
        if year == nowDate.year, month == nowDate.month {
            days = nowDate.day
        }
        return days
    }
    @discardableResult private func hourFrom(year: Int, month: Int, day: Int) -> Int {
        var hours: Int = 24
        if year == nowDate.year, month == nowDate.month, day == nowDate.day {
            hours = nowDate.hour + 1
        }
        return hours
    }
    @discardableResult private func minuteFrom(year: Int, month: Int, day: Int, hour: Int) -> Int {
        var minute: Int = 60
        if year == nowDate.year, month == nowDate.month, day == nowDate.day, hour == nowDate.hour {
            minute = nowDate.minute + 1
        }
        return minute
    }
}
extension CLYearMonthDayHourMinuteDataPickerView {
    private func select(year: Int, month: Int, day: Int, hour: Int, minute: Int) {
        yearIndex = yearArray.firstIndex(of: year) ?? 0
        monthFrom(year: year)
        monthIndex = monthArray.firstIndex(of: month) ?? 0
        daysFrom(year: year, month: month)
        dayIndex = dayArray.firstIndex(of: day) ?? 0
        hourIndex = hourArray.firstIndex(of: hour) ?? 0
        minuteIndex = minuteArray.firstIndex(of: minute) ?? 0
        
        pickerView.selectRow(yearIndex, inComponent: 0, animated: true)
        pickerView.selectRow(monthIndex, inComponent: 1, animated: true)
        pickerView.selectRow(dayIndex, inComponent: 2, animated: true)
        pickerView.selectRow(hourIndex, inComponent: 3, animated: true)
        pickerView.selectRow(minuteIndex, inComponent: 4, animated: true)
    }
}

