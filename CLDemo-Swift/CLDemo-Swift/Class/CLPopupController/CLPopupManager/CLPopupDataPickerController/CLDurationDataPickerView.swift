//
//  CLDurationDataPickerView.swift
//  CL
//
//  Created by JmoVxia on 2020/5/14.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLDurationDataPickerView: UIView {
    var duration: Int {
        return durationArray[durationIndex]
    }
    var unit: String {
        return unitArray[unitIndex]
    }
    private var durationIndex: Int = 0
    private var unitIndex: Int = 0
    private lazy var durationArray: [Int] = {
        let hourArray = Array(1...60)
        return hourArray
    }()
    private lazy var unitArray: [String] = {
        return ["分钟","小时"]
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
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLDurationDataPickerView {
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
extension CLDurationDataPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let array = [durationArray.count, unitArray.count]
        return array[component]
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}
extension CLDurationDataPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label: UILabel = (view as? UILabel) ?? UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        var textColor = UIColor.hex("#333333")
        let currentColor = UIColor.themeColor
        if component == 0 {
            textColor  = durationIndex == row ? currentColor : textColor
            label.text =  String(format: "%02d", durationArray[row])
        }else if component == 1 {
            textColor  = unitIndex == row ? currentColor : textColor
            label.text =  unitArray[row]
        }
        label.textColor = textColor
        return label
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            durationIndex = row
        }else if component == 1 {
            unitIndex = row
        }
        pickerView.reloadAllComponents()
    }
}
