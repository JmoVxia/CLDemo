//
//  CLRadarChartDataSource.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2023/4/10.
//

import Foundation

protocol CLRadarChartDataSource: AnyObject {
    
    func numberOfDataPoints(in radarChart: CLRadarChartView) -> Int
//    
    func numberOfRadarChartLayers(in radarChart: CLRadarChartView) -> Int
//    
    func maximumRadius(for radarChart: CLRadarChartView) -> CGFloat
//    
//    func maximumValue(for radarChart: CLRadarChartView) -> CGFloat
//    
    func fillColor(at index: Int, in radarChart: CLRadarChartView) -> UIColor
//    
//    func borderColor(at index: Int, in radarChart: CLRadarChartView) -> UIColor
//    
    func axisColor(at index: Int, in radarChart: CLRadarChartView) -> UIColor
//    
//    func labelStyle(in radarChart: CLRadarChartView) -> CLRadarChartView.labelStyle
//    
//    func attributedText(for radarChart: CLRadarChartView) -> NSAttributedString
//    
//    func valueForDataPoint(at index: Int, in radarChart: CLRadarChartView) -> CGFloat
}

