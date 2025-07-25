//
//  CLPopupCalendarController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2023/4/28.
//

import UIKit

// MARK: - JmoVxia---枚举

extension CLPopupCalendarController {}

// MARK: - JmoVxia---类-属性

class CLPopupCalendarController: CLPopoverController {
    var dismissCallback: ((_ start: Date, _ end: Date) -> Void)?

    private lazy var colorView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()

    private lazy var mainStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.insetsLayoutMarginsFromSafeArea = true
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .init(top: 0, left: 15, bottom: 10, right: 15)
        view.spacing = 0
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .white
        view.numberOfLines = 0
        view.font = .boldPingFangSC(18)
        view.textColor = "#353A55".uiColor
        view.text = "选择起止日期"
        view.textAlignment = .center
        return view
    }()

    private lazy var calendarView: CLCalendarView = {
        var config = CLCalendarConfig()
        config.insetsLayoutMarginsFromSafeArea = false
        config.headerHight = 40
        config.layoutMargins = .init(top: 0, left: 0, bottom: 10, right: 0)
        config.color.topToolTextWeekend = "#9EA3BA".uiColor
        config.color.topToolText = "#9EA3BA".uiColor
        config.color.topToolBackground = .white
        config.color.titleText = "#353A55".uiColor
        config.color.headerTextColor = "#353A55".uiColor
        config.color.sectionBackgroundText = "#CCCCCC".uiColor.withAlphaComponent(0.5)
        config.color.todayText = "#32cd32".uiColor
        config.color.selectTodayText = "#2e8b57".uiColor
        config.color.selectBackground = "#F1F4FF".uiColor.withAlphaComponent(0.7)
        config.color.selectStartBackground = "#1F70FF".uiColor.withAlphaComponent(0.5)
        config.color.selectEndBackground = "#1F70FF".uiColor.withAlphaComponent(0.5)
        let view = CLCalendarView(frame: .zero, config: config)
        view.delegate = self
        return view
    }()

    private lazy var bottomButton: UIButton = {
        let view = UIButton()
        view.isUserInteractionEnabled = false
        view.titleLabel?.numberOfLines = 0
        view.clipsToBounds = true
        view.backgroundColor = "#9EA3BA".uiColor
        view.layer.cornerRadius = 20
        view.titleLabel?.font = .boldPingFangSC(16)
        view.setTitle("确认", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        return view
    }()

    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        tap.delegate = self
        return tap
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    deinit {}
}

// MARK: - JmoVxia---生命周期

extension CLPopupCalendarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        makeConstraints()
        initData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - JmoVxia---布局

private extension CLPopupCalendarController {
    func configUI() {
        view.addGestureRecognizer(tapGestureRecognizer)
        view.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.00)
        view.addSubview(colorView)
        colorView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(calendarView)
        mainStackView.addArrangedSubview(bottomButton)
    }

    func makeConstraints() {
        bottomButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        colorView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.snp.bottom)
        }
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(self.view).multipliedBy(0.75)
        }
    }
}

// MARK: - JmoVxia---数据

private extension CLPopupCalendarController {
    func initData() {}
}

// MARK: - JmoVxia---override

extension CLPopupCalendarController {}

// MARK: - JmoVxia---objc

@objc private extension CLPopupCalendarController {
    func sureAction() {
        guard let start = calendarView.beginDate else { return }
        guard let end = calendarView.endDate else { return }

        dismissAnimation {
            self.dismissCallback?(start, end)
        }
    }

    func close() {
        dismissAnimation(completion: nil)
    }
}

// MARK: - JmoVxia---私有方法

extension CLPopupCalendarController: CLPopoverProtocol {
    func showAnimation(completion: (() -> Void)?) {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        colorView.snp.remakeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.40)
        }) { _ in
            completion?()
        }
    }

    func dismissAnimation(completion: (() -> Void)?) {
        colorView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom)
        }
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.00)
        }) { _ in
            CLPopoverManager.dismiss(self.key)
            completion?()
        }
    }
}

// MARK: - JmoVxia---公共方法

extension CLPopupCalendarController {}

extension CLPopupCalendarController: CLCalendarDelegate {
    func didSelectDate(date: Date, in view: CLCalendarView) {
        if let beginDate = view.beginDate,
           let endData = view.endDate
        {
            bottomButton.isUserInteractionEnabled = true
            bottomButton.backgroundColor = "#1F70FF".uiColor
            print("\nbeginDate:\(beginDate)\nendData:\(endData)")
        } else {
            bottomButton.isUserInteractionEnabled = false
            bottomButton.backgroundColor = "#9EA3BA".uiColor
        }
    }
}

extension CLPopupCalendarController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view, !(touchView is UIButton) else {
            return false
        }
        if mainStackView.bounds.contains(touch.location(in: mainStackView)) {
            return false
        }
        return true
    }
}
