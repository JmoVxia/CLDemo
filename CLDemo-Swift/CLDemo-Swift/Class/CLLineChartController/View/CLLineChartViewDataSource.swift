//
//  CLLineChartViewDataSource.swift
//  CLDemo-Swift
//
//  Created by JmoVxia on 2022/11/12.
//

import Foundation


protocol CLLineChartViewDataSource: AnyObject {
    func numberOfLines(in view: CLLineChartView) -> Int
    
    func chartView(_ chartView: CLLineChartView, numberOfPointsInLine line: Int) -> [CLLineChartPoint]
    
    func chartView(_ chartView: CLLineChartView, layerForLineAt line: Int) -> CAShapeLayer
    
    func axisInX(in view: CLLineChartView) -> (min: CGFloat, max: CGFloat)
    
    func axisInY(in view: CLLineChartView) -> (min: CGFloat, max: CGFloat)
    
    func size(in view: CLLineChartView) -> CGSize
}
