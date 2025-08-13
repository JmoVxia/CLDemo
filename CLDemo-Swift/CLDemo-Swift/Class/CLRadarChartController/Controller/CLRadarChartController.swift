//
//  CLRadarChartController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2023/4/10.
//

import UIKit

// MARK: - JmoVxia---类-属性

class CLRadarChartController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {}

    let allLabels = [
        "血糖水平", "血压", "体重", "心率", "血氧", "胆固醇", "低血糖事件\nmid/d",
        "睡眠质量", "运动量", "饮食情况", "情绪指数", "体温", "尿检指标", "肝功能", "肾功能", "血脂",
    ]
    var data: [String] = []

    lazy var chartView: CLRadarChartView = {
        //        let chartView = CLRadarChartView(frame: .init(x: 0, y: 200, width: 0, height: 0))
        //        chartView.dataSource = self
        //        chartView.backgroundColor = .orange.withAlphaComponent(0.1)
        //        view.addSubview(chartView)
        //        chartView.reload()
        let view = CLRadarChartView()
        view.dataSource = self
        view.backgroundColor = .orange.withAlphaComponent(0.1)
        return view
    }()
}

// MARK: - JmoVxia---生命周期

extension CLRadarChartController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
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

private extension CLRadarChartController {
    func initSubViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(refreshData))
        view.addGestureRecognizer(tap)
        view.addSubview(chartView)
        chartView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        refreshData()
    }

    func makeConstraints() {}
}

// MARK: - JmoVxia---数据

private extension CLRadarChartController {
    func initData() {}

    func generateRandomData() {
        let count = Int.random(in: 3 ... 16)
        data = Array(allLabels.shuffled().prefix(count))
    }
}

// MARK: - JmoVxia---override

extension CLRadarChartController {}

// MARK: - JmoVxia---objc

@objc private extension CLRadarChartController {
    func refreshData() {
        generateRandomData()
        chartView.reload()
    }
}

// MARK: - JmoVxia---私有方法

private extension CLRadarChartController {}

// MARK: - JmoVxia---公共方法

extension CLRadarChartController {}

extension CLRadarChartController: CLRadarChartDataSource {
    func radarChart(_ radarChart: CLRadarChartView, chartFillColorAt index: Int) -> UIColor {
        .random.withAlphaComponent(0.1)
    }

    func radarChart(_ radarChart: CLRadarChartView, chartBorderColorAt index: Int) -> UIColor {
        .random.withAlphaComponent(0.4)
    }

    func radarChart(_ radarChart: CLRadarChartView, valuesForChartAt index: Int) -> [CGFloat] {
        data.map { _ in CGFloat.random(in: 10 ... 80) }
    }

    func radarChart(_ radarChart: CLRadarChartView, webLayerFillColorAt index: Int) -> UIColor {
        .random.withAlphaComponent(0.1)
    }

    func radarChart(_ radarChart: CLRadarChartView, webLayerBorderColorAt index: Int) -> UIColor {
        .random
    }

    func radarChart(_ radarChart: CLRadarChartView, attributedTextAt index: Int) -> NSAttributedString {
        .init(data[index], attributes: { $0
                .font(.mediumPingFangSC(14))
                .foregroundColor("#6B6F6A".uiColor)
        })
    }

    func verticalInset(in radarChart: CLRadarChartView) -> CGFloat {
        40
    }

    func horizontalInset(in radarChart: CLRadarChartView) -> CGFloat {
        70
    }

    func maximumValue(in radarChart: CLRadarChartView) -> CGFloat {
        80
    }

    func numberOfCharts(in radarChart: CLRadarChartView) -> Int {
        Int.random(in: 1 ... 5)
    }

    func numberOfPoints(in radarChart: CLRadarChartView) -> Int {
        data.count
    }

    func numberOfWebLayers(in radarChart: CLRadarChartView) -> Int {
        Int.random(in: 3 ... 8)
    }

    func maximumRadius(in radarChart: CLRadarChartView) -> CGFloat {
        view.bounds.width * 0.45
    }
}
