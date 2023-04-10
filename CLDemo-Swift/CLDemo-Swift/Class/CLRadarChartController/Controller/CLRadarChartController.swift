//
//  CLRadarChartController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2023/4/10.
//

import UIKit


//MARK: - JmoVxia---类-属性
class CLRadarChartController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
    
}
//MARK: - JmoVxia---生命周期
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
//MARK: - JmoVxia---布局
private extension CLRadarChartController {
    func initSubViews() {
        let chartView = CLRadarChartView(frame: .init(x: 0, y: 200, width: view.frame.width, height: view.frame.width))
        chartView.backgroundColor = .random
        chartView.dataSource = self
        view.addSubview(chartView)
    }
    func makeConstraints() {
        
        
    }
}
//MARK: - JmoVxia---数据
private extension CLRadarChartController {
    func initData() {
    }
}
//MARK: - JmoVxia---override
extension CLRadarChartController {
}
//MARK: - JmoVxia---objc
@objc private extension CLRadarChartController {
}
//MARK: - JmoVxia---私有方法
private extension CLRadarChartController {
}
//MARK: - JmoVxia---公共方法
extension CLRadarChartController {
}
extension CLRadarChartController: CLRadarChartDataSource {
    func numberOfDataPoints(in radarChart: CLRadarChartView) -> Int {
        5
    }
    
    func numberOfRadarChartLayers(in radarChart: CLRadarChartView) -> Int {
        5
    }
    
    func maximumRadius(for radarChart: CLRadarChartView) -> CGFloat {
        view.bounds.width * 0.5 - 60
    }
    
    func fillColor(at index: Int, in radarChart: CLRadarChartView) -> UIColor {
        UIColor.orange.withAlphaComponent(0.3)
    }
    
    func axisColor(at index: Int, in radarChart: CLRadarChartView) -> UIColor {
        UIColor.green
    }
    
    
}
