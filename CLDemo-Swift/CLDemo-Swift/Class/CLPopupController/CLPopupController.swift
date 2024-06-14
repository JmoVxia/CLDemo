//
//  CLPopupController.swift
//  CLDemo
//
//  Created by JmoVxia on 2019/12/28.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit

class CLPopupModel: NSObject {
    var title: String?
    var callback: (() -> Void)?
}

class CLPopupController: CLController {
    lazy var arrayDS: [CLPopupModel] = {
        let arrayDS = [CLPopupModel]()
        return arrayDS
    }()

    lazy var tableview: UITableView = {
        let tableview = UITableView()
        tableview.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        tableview.dataSource = self
        tableview.delegate = self
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        view.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalToSuperview()
            }
        }
    }
}

extension CLPopupController {
    func initData() {
        do {
            let model = CLPopupModel()
            model.title = "翻牌弹窗"
            model.callback = { [weak self] in
                self?.showFlop()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "日历弹窗"
            model.callback = { [weak self] in
                self?.showCalendar()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "可拖拽弹窗"
            model.callback = { [weak self] in
                self?.showDragView()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "一个按钮"
            model.callback = { [weak self] in
                self?.showOneAlert()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "两个按钮"
            model.callback = { [weak self] in
                self?.showTwoAlert()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "成功弹窗"
            model.callback = { [weak self] in
                self?.showSuccess()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "错误弹窗"
            model.callback = { [weak self] in
                self?.showError()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "加载弹窗"
            model.callback = { [weak self] in
                self?.showLoading()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "提示弹窗"
            model.callback = { [weak self] in
                self?.showTips()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "年月日选择"
            model.callback = { [weak self] in
                self?.showYearMonthDayDataPicker()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "时分选择"
            model.callback = { [weak self] in
                self?.showHourMinuteDataPicker()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "年月日时分选择"
            model.callback = { [weak self] in
                self?.showYearMonthDayHourMinuteDataPicker()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "BMI计算"
            model.callback = { [weak self] in
                self?.showBMIInput()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "一个输入框"
            model.callback = { [weak self] in
                self?.showOneInput()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "两个输入框"
            model.callback = { [weak self] in
                self?.showTwoInput()
            }
            arrayDS.append(model)
        }
    }
}

extension CLPopupController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayDS.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = arrayDS[indexPath.row].title
        return cell
    }
}

extension CLPopupController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = arrayDS[indexPath.row]
        model.callback?()
    }
}

extension CLPopupController {
    func showFlop() {
        CLPopoverManager.showFlop()
    }

    func showCalendar() {
        CLPopoverManager.showCalendar()
    }

    func showDragView() {
        CLPopoverManager.showDrag { configure in
            configure.shouldAutorotate = true
            configure.supportedInterfaceOrientations = .all
        }
    }

    func showOneAlert() {
        CLPopoverManager.showOneAlert(configCallback: { configure in
            configure.shouldAutorotate = true
            configure.supportedInterfaceOrientations = .all
            configure.allowsEventPenetration = true
            configure.autoHideWhenPenetrated = true
            configure.userInterfaceStyleOverride = .unspecified
        }, title: "我是一个按钮", message: "我有一个按钮")
    }

    func showTwoAlert() {
        CLPopoverManager.showTwoAlert(configCallback: { configure in
            configure.shouldAutorotate = true
            configure.supportedInterfaceOrientations = .all
        }, title: "我是两个按钮", message: "我有两个按钮")
    }

    func showSuccess() {
        CLPopoverManager.showSuccess(configCallback: { configure in
            configure.shouldAutorotate = true
            configure.supportedInterfaceOrientations = .all
        }, text: "显示成功", dismissCallback: {
            print("success animation dismiss")
        })
    }

    func showError() {
        CLPopoverManager.showError(text: "显示错误", dismissCallback: {
            print("error animation dismiss")
        })
    }

    func showLoading() {
        CLPopoverManager.showLoading()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6) {
            CLPopoverManager.dismissAll()
        }
    }

    func showTips() {
        CLPopoverManager.showTips(text: "AAAAAAAAAAAAAAAAAAAA")
    }

    func showYearMonthDayDataPicker() {
        CLPopoverManager.showYearMonthDayDataPicker(yearMonthDayCallback: { year, month, day in
            print("选中-----\(year)年\(month)月\(day)日")
        })
    }

    func showHourMinuteDataPicker() {
        CLPopoverManager.showHourMinuteDataPicker(hourMinuteCallback: { hour, minute in
            print("选中-----\(hour)时\(minute)分")
        })
    }

    func showYearMonthDayHourMinuteDataPicker() {
        CLPopoverManager.showYearMonthDayHourMinuteDataPicker(yearMonthDayHourMinuteCallback: { year, month, day, hour, minute in
            print("选中-----\(year)年\(month)月\(day)日\(hour)时\(minute)分")
        })
    }

    func showBMIInput() {
        CLPopoverManager.showBMIInput(bmiCallback: { bmi in
            print("BMI-----\(bmi)")
        })
    }

    func showOneInput() {
        CLPopoverManager.showOneInput(type: .UrineVolume) { value in
            print("-----\(String(describing: value))")
        }
    }

    func showTwoInput() {
        CLPopoverManager.showTwoInput(type: .bloodPressure) { value1, value2 in
            print("-----\(String(describing: value1))----------\(String(describing: value2))")
        }
    }
}
