//
//  CLHourMinuteDataPickerView.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/3/31.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
//import DateToolsSwift

class CLHourMinuteDataPickerView: UIView {
    var hour: Int {
        return hourArray[hourIndex]
    }
    var minute: Int {
        return minuteArray[minuteIndex]
    }
    private var nowDate: Date = Date(timeIntervalSinceNow: 0)
    private var hourIndex: Int = 0
    private var minuteIndex: Int = 0
    private lazy var hourArray: [Int] = {
        let hourArray = Array(0...23)
        return hourArray
    }()
    private lazy var minuteArray: [Int] = {
        let minuteArray = Array(0...59)
        return minuteArray
    }()
    private lazy var lineView: UILabel = {
        let lineView = UILabel()
        lineView.text = ":"
        lineView.textColor = .themeColor
        return lineView
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
        select(hour: nowDate.hour, minute: nowDate.minute)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLHourMinuteDataPickerView {
    private func initUI() {
        backgroundColor = UIColor.white
        addSubview(pickerView)
        pickerView.addSubview(lineView)
    }
    private func makeConstraints() {
        lineView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
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
extension CLHourMinuteDataPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let array = [hourArray.count, minuteArray.count]
        return array[component]
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}
extension CLHourMinuteDataPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label: UILabel = (view as? UILabel) ?? UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        var textColor = UIColor.hex("#333333")
        let currentColor = UIColor.themeColor
        if component == 0 {
            textColor  = hourIndex == row ? currentColor : textColor
            label.text =  String(format: "%02d", hourArray[row])
        }else if component == 1 {
            textColor  = minuteIndex == row ? currentColor : textColor
            label.text =  String(format: "%02d", minuteArray[row])
        }
        label.textColor = textColor
        return label
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            hourIndex = row
        }else if component == 1 {
            minuteIndex = row
        }
        pickerView.reloadAllComponents()
    }
}
extension CLHourMinuteDataPickerView {
    private func select(hour: Int, minute: Int) {
        hourIndex = hourArray.firstIndex(of: hour) ?? 0
        minuteIndex = minuteArray.firstIndex(of: minute) ?? 0
        
        pickerView.selectRow(hourIndex, inComponent: 0, animated: true)
        pickerView.selectRow(minuteIndex, inComponent: 1, animated: true)
    }
}

