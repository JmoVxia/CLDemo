//
//  CLPopupDataRangPickerView.swift
//  CLDemo-Swift
//
//  Created by 菜鸽途讯 on 2025/10/15.
//

import UIKit

// MARK: - JmoVxia---枚举

extension CLPopupDataRangPickerView {}

// MARK: - JmoVxia---类-属性

class CLPopupDataRangPickerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 标题
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "选择预警时间"
        view.font = .systemFont(ofSize: 18, weight: .medium)
        view.textColor = .black
        view.textAlignment = .center
        return view
    }()

    /// 关闭按钮
    private lazy var closeButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(UIImage(named: "btn_x"), for: .normal)
        view.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return view
    }()

    /// 左边的UIPickerView
    private lazy var leftPickerView: UIPickerView = {
        let view = UIPickerView()
        view.dataSource = self
        view.delegate = self
        return view
    }()

    /// 右边的UIPickerView
    private lazy var rightPickerView: UIPickerView = {
        let view = UIPickerView()
        view.dataSource = self
        view.delegate = self
        return view
    }()

    /// “至”
    private lazy var toLabel: UILabel = {
        let view = UILabel()
        view.text = "至"
        view.font = .systemFont(ofSize: 16)
        view.textColor = .black
        view.textAlignment = .center
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .vertical)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        return view
    }()

    /// 取消按钮
    private lazy var cancelButton: UIButton = {
        let view = UIButton()
        view.setTitle("取消", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 16)
        view.setTitleColor(.darkGray, for: .normal)
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return view
    }()

    /// 确定按钮
    private lazy var confirmButton: UIButton = {
        let view = UIButton()
        view.setTitle("确认", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 16)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .darkText
        view.layer.cornerRadius = 8
        view.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        return view
    }()

    private lazy var middleView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = "#F7F7F7".uiColor
        view.layer.cornerRadius = 4
        return view
    }()

    // MARK: - 数据源

    private let hours = (0 ... 24).map { String(format: "%02d时", $0) }

    private let minutes = (0 ... 59).map { String(format: "%02d分", $0) }

    var confirmCallback: ((_ startHour: String, _ startMinute: String, _ endHour: String, _ endMinute: String) -> Void)?

    var cancelCallback: (() -> Void)?

    var closeCallback: (() -> Void)?
}

// MARK: - JmoVxia---布局

private extension CLPopupDataRangPickerView {
    func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.masksToBounds = true
        addSubview(middleView)
        addSubview(titleLabel)
        addSubview(closeButton)
        addSubview(leftPickerView)
        addSubview(toLabel)
        addSubview(rightPickerView)
        addSubview(cancelButton)
        addSubview(confirmButton)
    }

    func makeConstraints() {
        middleView.snp.makeConstraints { make in
            make.left.equalTo(leftPickerView)
            make.right.equalTo(rightPickerView)
            make.height.equalTo(34)
            make.centerY.equalTo(toLabel)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.width.height.equalTo(30)
        }

        toLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(leftPickerView)
        }

        leftPickerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(toLabel.snp.left).offset(-10)
            make.bottom.equalTo(cancelButton.snp.top).offset(-20)
            make.height.equalTo(234)
        }

        rightPickerView.snp.makeConstraints { make in
            make.top.width.height.bottom.equalTo(leftPickerView)
            make.left.equalTo(toLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
        }

        cancelButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.height.equalTo(44)
            make.width.equalTo(confirmButton.snp.width)
        }

        confirmButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.bottom.height.equalTo(cancelButton)
            make.left.equalTo(cancelButton.snp.right).offset(15)
        }
    }
}

// MARK: - JmoVxia---override

extension CLPopupDataRangPickerView {}

// MARK: - JmoVxia---objc

@objc private extension CLPopupDataRangPickerView {
    func closeAction() {
        closeCallback?()
    }

    func cancelAction() {
        cancelCallback?()
    }

    func confirmAction() {
        let startHourIndex = leftPickerView.selectedRow(inComponent: 0)
        let startMinuteIndex = leftPickerView.selectedRow(inComponent: 1)
        let endHourIndex = rightPickerView.selectedRow(inComponent: 0)
        let endMinuteIndex = rightPickerView.selectedRow(inComponent: 1)

        confirmCallback?(hours[startHourIndex], minutes[startMinuteIndex], hours[endHourIndex], minutes[endMinuteIndex])
    }
}

// MARK: - JmoVxia---私有方法

private extension CLPopupDataRangPickerView {}

// MARK: - JmoVxia---公共方法

extension CLPopupDataRangPickerView {}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension CLPopupDataRangPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in _: UIPickerView) -> Int {
        2
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        component == 0 ? hours.count : minutes.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as? UILabel
        if label == nil {
            label = UILabel()
            label?.textColor = .black
            label?.textAlignment = .center
        }
        label?.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            guard let seletedLabel = pickerView.view(forRow: row, forComponent: component) as? UILabel else { return }
            seletedLabel.textColor = .red
        }
        return label!
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if #available(iOS 14.0, *) {
            pickerView.subviews[safe: 1]?.backgroundColor = .clear
        }
        return component == 0 ? hours[row] : minutes[row]
    }
}
