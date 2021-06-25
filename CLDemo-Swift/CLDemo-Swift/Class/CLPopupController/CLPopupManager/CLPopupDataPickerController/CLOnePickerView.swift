//
//  CLOnePickerView.swift
//  CL
//
//  Created by JmoVxia on 2020/4/22.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLOnePickerView: UIView {
    var dataSource: [String] = [] {
        didSet {
            seletedString = dataSource.first ?? ""
        }
    }
    var unit: String? {
        didSet {
            unitLabel.text = unit
        }
    }
    var space: CGFloat = -10 {
        didSet {
            if oldValue != space {
                unitLabel.snp.updateConstraints { (make) in
                    make.centerX.equalToSuperview().offset(space)
                }
            }
        }
    }
    
    private (set) var seletedString: String = ""
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    private lazy var unitLabel: UILabel = {
        let view = UILabel()
        view.font = PingFangSCMedium(14)
        view.textColor = .themeColor
        return view
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
extension CLOnePickerView {
    private func initUI() {
        backgroundColor = UIColor.white
        addSubview(pickerView)
        pickerView.addSubview(unitLabel)
    }
    private func makeConstraints() {
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
        unitLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-10)
        }
    }
}
extension CLOnePickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}
extension CLOnePickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label: UILabel = (view as? UILabel) ?? UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .hex("#333333")
        label.text = dataSource[row]
        return label
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        seletedString = dataSource[row]
    }
}
