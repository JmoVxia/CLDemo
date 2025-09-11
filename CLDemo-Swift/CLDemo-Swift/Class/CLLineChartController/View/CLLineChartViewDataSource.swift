//
//  CLLineChartViewDataSource.swift
//  CLDemo-Swift
//
//  Created by JmoVxia on 2022/11/12.
//

import Foundation

protocol CLLineChartViewDataSource: AnyObject {
    func numberOfLines(in view: CLLineChartView) -> Int

    func chartView(_ chartView: CLLineChartView, numberOfPointsInLine line: Int) -> [CGPoint]

    func chartView(_ chartView: CLLineChartView, layerForLineAt line: Int) -> CAShapeLayer

    func chartView(_ chartView: CLLineChartView, gradientColorsForLineAt line: Int) -> [CGColor]

    func axisInX(in view: CLLineChartView) -> (min: CGFloat, max: CGFloat)

    func axisInY(in view: CLLineChartView) -> (min: CGFloat, max: CGFloat)

    func size(in view: CLLineChartView) -> CGSize

    func numberOfXTicks(in view: CLLineChartView) -> Int

    func numberOfYTicks(in view: CLLineChartView) -> Int
}
