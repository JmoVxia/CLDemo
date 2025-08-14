//
//  CLRadarChartDataSource.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2023/4/10.
//

import Foundation

protocol CLRadarChartDataSource: AnyObject {
    var labelMargin: CGFloat { get }

    func numberOfPoints(in radarChart: CLRadarChartView) -> Int

    func maximumRadius(in radarChart: CLRadarChartView) -> CGFloat

    func maximumValue(in radarChart: CLRadarChartView) -> CGFloat

    func numberOfCharts(in radarChart: CLRadarChartView) -> Int

    func radarChart(_ radarChart: CLRadarChartView, chartFillColorAt index: Int) -> UIColor

    func radarChart(_ radarChart: CLRadarChartView, chartBorderColorAt index: Int) -> UIColor

    func radarChart(_ radarChart: CLRadarChartView, valuesForChartAt index: Int) -> [CGFloat]

    func numberOfWebLayers(in radarChart: CLRadarChartView) -> Int

    func radarChart(_ radarChart: CLRadarChartView, webLayerFillColorAt index: Int) -> UIColor

    func radarChart(_ radarChart: CLRadarChartView, webLayerBorderColorAt index: Int) -> UIColor

    func verticalInset(in radarChart: CLRadarChartView) -> CGFloat

    func horizontalInset(in radarChart: CLRadarChartView) -> CGFloat

    func radarChart(_ radarChart: CLRadarChartView, attributedTextAt index: Int) -> NSAttributedString
}

extension CLRadarChartDataSource {
    var labelMargin: CGFloat { 10 }
}
