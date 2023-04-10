//
//  CLRadarChartView.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2023/4/10.
//

import UIKit


extension CLRadarChartView{
    enum labelStyle {
        case horizontal
        case circle
        case hidden
    }
}

//MARK: - JmoVxia---类-属性
class CLRadarChartView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var centerPoint = CGPoint.zero
    
    private var angle = CGFloat.zero
    
    
    weak var dataSource: CLRadarChartDataSource?
}
//MARK: - JmoVxia---布局
private extension CLRadarChartView {
    func initSubViews() {
    }
    func makeConstraints() {
    }
}
//MARK: - JmoVxia---override
extension CLRadarChartView {
    override func draw(_ rect: CGRect) {
        guard let dataSource = dataSource else { return }
        centerPoint = .init(x: rect.midX, y: rect.midY)
        angle = .pi * 2 / CGFloat(dataSource.numberOfDataPoints(in: self))
        drawGridLine()
        drawAxisLine()
    }
}
//MARK: - JmoVxia---objc
@objc private extension CLRadarChartView {
}
//MARK: - JmoVxia---私有方法
private extension CLRadarChartView {
    func drawGridLine() {
        guard let dataSource = dataSource else { return }
        
        let chartLayerCount = dataSource.numberOfRadarChartLayers(in: self)
        let chartMaxRadius = dataSource.maximumRadius(for: self)
        let chartPointCount = dataSource.numberOfDataPoints(in: self)
        
        for index in 0...chartLayerCount {
            let radius = chartMaxRadius * CGFloat(index) / CGFloat(chartLayerCount)
            let shapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = 1 / UIScreen.main.scale
            shapeLayer.fillColor = dataSource.fillColor(at: index, in: self).cgColor
            shapeLayer.strokeColor = dataSource.axisColor(at: index, in: self).cgColor
            let path = UIBezierPath()
            for pointIndex in 0..<chartPointCount {
                let x = radius * sin(angle * CGFloat(pointIndex))
                let y = radius * cos(angle * CGFloat(pointIndex))
                let point = CGPoint(x: centerPoint.x + x, y: centerPoint.y - y)
                if pointIndex == .zero {
                    path.move(to: point)
                }else {
                    path.addLine(to: point)
                }
            }
            path.close()
            shapeLayer.path = path.cgPath
            layer.addSublayer(shapeLayer)
        }
    }
    func drawAxisLine() {
        guard let dataSource = dataSource else { return }

        let chartPointCount = dataSource.numberOfDataPoints(in: self)
        let chartMaxRadius = dataSource.maximumRadius(for: self)
        
        for index in 0..<chartPointCount {
            let x = chartMaxRadius * sin(angle * CGFloat(index))
            let y = chartMaxRadius * cos(angle * CGFloat(index))
            let point = CGPoint(x: centerPoint.x + x, y: centerPoint.y - y)
            
            
            let path = UIBezierPath()
            path.move(to: centerPoint)
            path.addLine(to: point)
            path.close()

            let shapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = 1.0 / UIScreen.main.scale
            shapeLayer.strokeColor = dataSource.axisColor(at: index, in: self).cgColor
            shapeLayer.path = path.cgPath
            layer.addSublayer(shapeLayer)
        }
    }
}
//MARK: - JmoVxia---公共方法
extension CLRadarChartView {
    func reload() {
        setNeedsDisplay()
    }
}

