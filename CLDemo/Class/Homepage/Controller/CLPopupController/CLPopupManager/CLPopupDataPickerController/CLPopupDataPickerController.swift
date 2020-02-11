//
//  CLPopupDataPickerController.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/3/30.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

enum CLDataPickerType {
    case yearMonthDay
    case hourMinute
    case yearMonthDayHourMinute
}
class CLPopupDataPickerController: CLPopupManagerBaseController {
    var yearMonthDayCallback: ((Int, Int, Int) -> ())?
    var hourMinuteCallback: ((Int, Int) -> ())?
    var yearMonthDayHourMinuteCallback: ((Int, Int, Int, Int, Int) -> ())?
    var type: CLDataPickerType = .yearMonthDay
    lazy var topToolBar: UIButton = {
        let topToolBar = UIButton()
        topToolBar.backgroundColor = hexColor("#F8F6F9")
        return topToolBar
    }()
    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitle("取消", for: .selected)
        cancelButton.setTitle("取消", for: .highlighted)
        cancelButton.setTitleColor(hexColor("#666666"), for: .normal)
        cancelButton.setTitleColor(hexColor("#666666"), for: .selected)
        cancelButton.setTitleColor(hexColor("#666666"), for: .highlighted)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return cancelButton
    }()
    lazy var sureButton: UIButton = {
        let sureButton = UIButton()
        sureButton.setTitle("确定", for: .normal)
        sureButton.setTitle("确定", for: .selected)
        sureButton.setTitle("确定", for: .highlighted)
        sureButton.setTitleColor(hexColor("#40B5AA"), for: .normal)
        sureButton.setTitleColor(hexColor("#40B5AA"), for: .selected)
        sureButton.setTitleColor(hexColor("#40B5AA"), for: .highlighted)
        sureButton.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        return sureButton
    }()
    lazy var dataPicker: UIView = {
        let dataPick: UIView
        switch type {
        case .yearMonthDay:
            dataPick = CLYearMonthDayDataPickerView()
        case .hourMinute:
            dataPick = CLHourMinuteDataPickerView()
        case .yearMonthDayHourMinute:
            dataPick = CLYearMonthDayHourMinuteDataPickerView()
        }
        return dataPick
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        showAnimation()
    }
    deinit {
        print("============CLPopupDataPickerController deinit============")
    }
}
extension CLPopupDataPickerController {
    func initUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        view.addSubview(topToolBar)
        topToolBar.addSubview(cancelButton)
        topToolBar.addSubview(sureButton)
        view.addSubview(dataPicker)
    }
}
extension CLPopupDataPickerController {
    func showAnimation() {
        topToolBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(view.snp.bottom)
        }
        cancelButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.left.equalTo(view.safeAreaLayoutGuide).offset(15)
            } else {
                make.left.equalTo(15)
            }
        }
        sureButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.right.equalTo(view.safeAreaLayoutGuide).offset(-15)
            } else {
                make.right.equalTo(-15)
            }
        }
        dataPicker.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topToolBar.snp.bottom)
            make.height.equalTo(302.5)
        }
        view.setNeedsLayout()
        view.layoutIfNeeded()
        topToolBar.snp.updateConstraints { (make) in
            make.top.equalTo(view.snp.bottom).offset(-50 - 302.5)
        }
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    func dismissAnimation() {
        topToolBar.snp.updateConstraints { (make) in
            make.top.equalTo(view.snp.bottom)
        }
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }) { (_) in
            CLPopupManager.dismissAll(false)
        }
    }
}
extension CLPopupDataPickerController {
    @objc func cancelAction() {
        dismissAnimation()
    }
    @objc func sureAction() {
        if let picker = dataPicker as? CLYearMonthDayDataPickerView {
            yearMonthDayCallback?(picker.year, picker.month, picker.day)
        }else if let picker = dataPicker as? CLHourMinuteDataPickerView {
            hourMinuteCallback?(picker.hour, picker.minute)
        }else if let picker = dataPicker as? CLYearMonthDayHourMinuteDataPickerView {
            yearMonthDayHourMinuteCallback?(picker.year, picker.month, picker.day, picker.hour, picker.minute)
        }
        dismissAnimation()
    }
}
extension CLPopupDataPickerController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismissAnimation()
    }
}
