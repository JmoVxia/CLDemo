//
//  CLLineChartView.swift
//  CLDemo-Swift
//
//  Created by JmoVxia on 2022/11/12.
//

import UIKit

struct CLLineChartPoint {
    let x: CGFloat
    let y: CGFloat
}


class CLLineChartView: UIView {
    weak var dataSource: CLLineChartViewDataSource?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLLineChartView {
    func reload() {
        guard let dataSource = dataSource else { return }
        layer.removeAllAnimations()
        layer.sublayers?.removeAll()
        
        let size = dataSource.size(in: self)
        let axisInX = dataSource.axisInX(in: self)
        let axisInY = dataSource.axisInY(in: self)

        let xSpace = axisInX.max - axisInX.min
        let ySpace = axisInY.max - axisInY.min
        
        let lines = dataSource.numberOfLines(in: self)

        for line in 0..<lines {
            let points = dataSource.chartView(self, numberOfPointsInLine: line)
            let lineLayer = dataSource.chartView(self, layerForLineAt: line)
            
            let linePath: UIBezierPath = {
                let path = UIBezierPath()
                for (index, point) in points.enumerated() {
                    let x = (point.x - axisInX.min) * size.width / xSpace
                    let y = size.height - (point.y - axisInY.min) * size.height / ySpace
                    if index == 0 {
                        path.move(to: .init(x: x, y: y))
                    }else {
                        path.addLine(to: .init(x: x, y: y))
                    }
                }
                return path
            }()
            lineLayer.path = linePath.cgPath
            lineLayer.frame = .init(origin: .zero, size: size)
            layer.addSublayer(lineLayer)
            do {
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.duration = 2.5
                animation.fromValue = 0
                animation.toValue = 1
                animation.isRemovedOnCompletion = false
                animation.fillMode = .forwards
                animation.timingFunction = CAMediaTimingFunction(name: .linear)
                lineLayer.add(animation, forKey: "strokeEnd")
            }
        }
    }
}
