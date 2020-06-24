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
    var callback: (() -> ())?
}


class CLPopupController: CLBaseViewController {
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
        tableview.snp.makeConstraints { (make) in
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
        let model1 = CLPopupModel()
        model1.title = "翻牌弹窗"
        model1.callback = {[weak self] in
            self?.showFlop()
        }
        arrayDS.append(model1)
        
        let model2 = CLPopupModel()
        model2.title = "一个按钮"
        model2.callback = {[weak self] in
            self?.showOneAlert()
        }
        arrayDS.append(model2)
        
        let model3 = CLPopupModel()
        model3.title = "两个按钮"
        model3.callback = {[weak self] in
            self?.showTwoAlert()
        }
        arrayDS.append(model3)
        
        let model4 = CLPopupModel()
        model4.title = "成功弹窗"
        model4.callback = {[weak self] in
            self?.showSuccess()
        }
        arrayDS.append(model4)
        
        let model5 = CLPopupModel()
        model5.title = "错误弹窗"
        model5.callback = {[weak self] in
            self?.showError()
        }
        arrayDS.append(model5)
        
        let model6 = CLPopupModel()
        model6.title = "加载弹窗"
        model6.callback = {[weak self] in
            self?.showLoading()
        }
        arrayDS.append(model6)
        
        let model7 = CLPopupModel()
        model7.title = "提示弹窗"
        model7.callback = {[weak self] in
            self?.showTips()
        }
        arrayDS.append(model7)
        
        let model8 = CLPopupModel()
        model8.title = "年月日选择"
        model8.callback = {[weak self] in
            self?.showYearMonthDayDataPicker()
        }
        arrayDS.append(model8)
        
        let model9 = CLPopupModel()
        model9.title = "时分选择"
        model9.callback = {[weak self] in
            self?.showHourMinuteDataPicker()
        }
        arrayDS.append(model9)

        let model10 = CLPopupModel()
        model10.title = "年月日时分选择"
        model10.callback = {[weak self] in
            self?.showYearMonthDayHourMinuteDataPicker()
        }
        arrayDS.append(model10)
        
        let model11 = CLPopupModel()
        model11.title = "BMI计算"
        model11.callback = {[weak self] in
            self?.showBMIInput()
        }
        arrayDS.append(model11)
        
        let model12 = CLPopupModel()
        model12.title = "一个输入框"
        model12.callback = {[weak self] in
            self?.showOneInput()
        }
        arrayDS.append(model12)
        
        let model13 = CLPopupModel()
        model13.title = "两个输入框"
        model13.callback = {[weak self] in
            self?.showTwoInput()
        }
        arrayDS.append(model13)
        
        let model14 = CLPopupModel()
        model14.title = "食物选择"
        model14.callback = {[weak self] in
            self?.showFoodPicker()
        }
        arrayDS.append(model14)
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
        CLPopupManager.showFlop()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    CLPopupManager.showFlop { (configure) in
                        configure.isHiddenStatusBar = true
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
                    CLPopupManager.showFlop { (configure) in
                        configure.isHiddenStatusBar = false
                        configure.statusBarStyle = .default
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6) {
                    CLPopupManager.showFlop { (configure) in
                        configure.isHiddenStatusBar = true
                    }
                }
    }
    func showOneAlert() {
        CLPopupManager.showOneAlert(configureCallback: { (configure) in
            configure.isAutorotate = true
            configure.interfaceOrientationMask = .all
        }, title: "我是一个按钮", message: "我有一个按钮")
    }
    func showTwoAlert() {
        CLPopupManager.showTwoAlert(configureCallback: { (configure) in
            configure.isAutorotate = true
            configure.interfaceOrientationMask = .all
        }, title: "我是两个按钮", message: "我有两个按钮")
    }
    func showSuccess() {
        CLPopupManager.showSuccess(configureCallback: { (configure) in
            configure.isAutorotate = true
            configure.interfaceOrientationMask = .all
        }, text: "显示成功", dismissCallback: {
            print("success animation dismiss")
        })
    }
    func showError() {
        CLPopupManager.showError(text: "显示错误", dismissCallback: {
            print("error animation dismiss")
        })
    }
    func showLoading() {
        CLPopupManager.showLoading()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6) {
            CLPopupManager.dismissAll()
        }
    }
    func showTips() {
        CLPopupManager.showTips(text: "AAAAAAAAAAAAAAAAAAAA")
    }
    func showYearMonthDayDataPicker() {
        CLPopupManager.showYearMonthDayDataPicker { (year, month, day) in
            print("选中-----\(year)年\(month)月\(day)日")
        }
    }
    func showHourMinuteDataPicker() {
        CLPopupManager.showHourMinuteDataPicker { (hour, minute) in
            print("选中-----\(hour)时\(minute)分")
        }
    }
    func showYearMonthDayHourMinuteDataPicker()  {
        CLPopupManager.showYearMonthDayHourMinuteDataPicker { (year, month, day, hour, minute) in
            print("选中-----\(year)年\(month)月\(day)日\(hour)时\(minute)分")
        }
    }
    func showBMIInput() {
        CLPopupManager.showBMIInput { (bmi) in
            print("BMI-----\(bmi)")
        }
    }
    func showOneInput() {
        CLPopupManager.showOneInput(type: .UrineVolume) { (value) in
            print("-----\(String(describing: value))")
        }
    }
    func showTwoInput() {
        CLPopupManager.showTwoInput(type: .bloodPressure) { (value1, value2) in
            print("-----\(String(describing: value1))----------\(String(describing: value2))")
        }
    }
    func showFoodPicker() {
        CLPopupManager.showFoodPicker { (value1, value2, value3, value4) in
            print("-----\(value1)----------\(value2)-------\(value3)-------\(value4)")
        }
    }
}
