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
        let size = CLRadarChartView.calculateSize(radius: view.bounds.width * 0.5, side: 5, verticalInset: 26, horizontalInset: 40)
        let chartView = CLRadarChartView(frame: .init(x: 0, y: 200, width: size.width, height: size.height))
        chartView.dataSource = self
        chartView.backgroundColor = .orange.withAlphaComponent(0.1)
        view.addSubview(chartView)
    }

    func makeConstraints() {}
}

// MARK: - JmoVxia---数据

private extension CLRadarChartController {
    func initData() {}
}

// MARK: - JmoVxia---override

extension CLRadarChartController {}

// MARK: - JmoVxia---objc

@objc private extension CLRadarChartController {}

// MARK: - JmoVxia---私有方法

private extension CLRadarChartController {}

// MARK: - JmoVxia---公共方法

extension CLRadarChartController {}

extension CLRadarChartController: CLRadarChartDataSource {
    func radarChart(_ radarChart: CLRadarChartView, chartFillColorAt index: Int) -> UIColor {
        return index == .zero ? "#546BFE".uiColor.withAlphaComponent(0.1) : "#02AA5D".uiColor.withAlphaComponent(0.1)
    }

    func radarChart(_ radarChart: CLRadarChartView, chartBorderColorAt index: Int) -> UIColor {
        return index == .zero ? "#546BFE".uiColor : "#02AA5D".uiColor
    }

    func radarChart(_ radarChart: CLRadarChartView, valuesForChartAt index: Int) -> [CGFloat] {
        return index == .zero ? [80, 70, 50, 70, 50] : [10, 20, 30, 80, 30]
    }

    func radarChart(_ radarChart: CLRadarChartView, webLayerFillColorAt index: Int) -> UIColor {
        return index != 2 ? .white : "f9f9f9".uiColor
    }

    func radarChart(_ radarChart: CLRadarChartView, webLayerBorderColorAt index: Int) -> UIColor {
        "#EEEEEE".uiColor
    }

    func radarChart(_ radarChart: CLRadarChartView, attributedTextAt index: Int) -> NSAttributedString {
        .init(["血糖水平", "血糖波动", "血糖范围", "低血糖事件", "高血糖事件"][index], attributes: { $0
                .font(.mediumPingFangSC(14))
                .foregroundColor("#6B6F6A".uiColor)
        })
    }

    func verticalInset(in radarChart: CLRadarChartView) -> CGFloat {
        26
    }

    func horizontalInset(in radarChart: CLRadarChartView) -> CGFloat {
        40
    }

    func maximumValue(in radarChart: CLRadarChartView) -> CGFloat {
        80
    }

    func numberOfCharts(in radarChart: CLRadarChartView) -> Int {
        2
    }

    func numberOfPoints(in radarChart: CLRadarChartView) -> Int {
        5
    }

    func numberOfWebLayers(in radarChart: CLRadarChartView) -> Int {
        3
    }

    func maximumRadius(in radarChart: CLRadarChartView) -> CGFloat {
        view.bounds.width * 0.5
    }
}
