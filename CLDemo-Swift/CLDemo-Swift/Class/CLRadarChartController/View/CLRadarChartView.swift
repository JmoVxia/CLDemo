//
//  CLRadarChartView.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2023/4/10.
//

import UIKit

// MARK: - JmoVxia---类-属性

class CLRadarChartView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var dataSource: CLRadarChartDataSource?
}

// MARK: - JmoVxia---布局

private extension CLRadarChartView {
    func initSubViews() {
        backgroundColor = .white
    }

    func makeConstraints() {}
}

// MARK: - JmoVxia---override

extension CLRadarChartView {
    override func draw(_ rect: CGRect) {
        guard let dataSource = dataSource else { return }

        layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        let horizontalInset = dataSource.horizontalInset(in: self)
        let verticalInset = dataSource.verticalInset(in: self)
        let chartMaxRadius = dataSource.maximumRadius(in: self) - 2 * horizontalInset
        let chartPointCount = dataSource.numberOfPoints(in: self)
        let chartLayerCount = dataSource.numberOfWebLayers(in: self)

        let centerPoint = CGPoint(x: rect.midX, y: chartMaxRadius + verticalInset)
        let angle = .pi * 2 / CGFloat(chartPointCount)

        drawWebLayer()
        drawAxisLine()
        drawCharts()
        drawAttributedText()

        func drawWebLayer() {
            for index in (1 ... chartLayerCount).reversed() {
                let radius = chartMaxRadius * CGFloat(index) / CGFloat(chartLayerCount)
//                let path = UIBezierPath(center: centerPoint, radius: radius)
                let path = UIBezierPath()
                for pointIndex in 0 ..< chartPointCount {
                    let point = calculatePoint(radius: radius, pointIndex: pointIndex, angle: angle, centerPoint: centerPoint)
                    if pointIndex == .zero {
                        path.move(to: point)
                    } else {
                        path.addLine(to: point)
                    }
                }
                path.close()
                addShapeLayer(path: path,
                              fillColor: dataSource.radarChart(self, webLayerFillColorAt: index).cgColor,
                              strokeColor: dataSource.radarChart(self, webLayerBorderColorAt: index).cgColor,
                              lineWidth: 0.5)
            }
        }

        func drawAxisLine() {
            for index in 0 ..< chartPointCount {
                let point = calculatePoint(radius: chartMaxRadius, pointIndex: index, angle: angle, centerPoint: centerPoint)
                let path = UIBezierPath()
                path.move(to: centerPoint)
                path.addLine(to: point)
                addShapeLayer(path: path,
                              strokeColor: dataSource.radarChart(self, webLayerBorderColorAt: index).cgColor,
                              lineWidth: 0.5)
            }
        }

        func drawCharts() {
            let charts = dataSource.numberOfCharts(in: self)
            let chartMaxValue = dataSource.maximumValue(in: self)
            let pointRadius = 2.0
            for index in 0 ..< charts {
                let fillColor = dataSource.radarChart(self, chartFillColorAt: index)
                let borderColor = dataSource.radarChart(self, chartBorderColorAt: index)
                let values = dataSource.radarChart(self, valuesForChartAt: index)
                let path = UIBezierPath()
                for (valueIndex, value) in values.enumerated() {
                    let radius = (chartMaxRadius - pointRadius) * value / chartMaxValue
                    let point = calculatePoint(radius: radius, pointIndex: valueIndex, angle: angle, centerPoint: centerPoint)
                    if valueIndex == .zero {
                        path.move(to: point)
                    } else {
                        path.addLine(to: point)
                    }
                    do {
                        let path = UIBezierPath(arcCenter: point, radius: pointRadius, startAngle: 0, endAngle: 360, clockwise: true)
                        addShapeLayer(path: path,
                                      fillColor: borderColor.cgColor,
                                      strokeColor: UIColor.red.cgColor,
                                      lineWidth: .zero)
                    }
                }

                path.close()
                addShapeLayer(path: path,
                              fillColor: fillColor.cgColor,
                              strokeColor: borderColor.cgColor,
                              lineWidth: 1)
            }
        }

        func drawAttributedText() {
            for index in 0 ..< chartPointCount {
                let attributedText = dataSource.radarChart(self, attributedTextAt: index)
                let size = attributedText.size()
                let point = calculateTextPoint(size: size, index: index, chartMaxRadius: chartMaxRadius,
                                               angle: angle, centerPoint: centerPoint)
                attributedText.draw(at: point)
            }
        }

        func calculatePoint(radius: CGFloat, pointIndex: Int, angle: CGFloat, centerPoint: CGPoint) -> CGPoint {
            let x = radius * sin(angle * CGFloat(pointIndex))
            let y = radius * cos(angle * CGFloat(pointIndex))
            return CGPoint(x: centerPoint.x + x, y: centerPoint.y - y)
        }

        func calculateTextPoint(size: CGSize, index: Int, chartMaxRadius: CGFloat, angle: CGFloat, centerPoint: CGPoint) -> CGPoint {
            let x = (chartMaxRadius + size.width * 0.5 + 10) * sin(angle * CGFloat(index))
            let y = (chartMaxRadius + size.height * 0.5 + 10) * cos(angle * CGFloat(index))
            return CGPoint(x: centerPoint.x + x - size.width * 0.5, y: centerPoint.y - y - size.height * 0.5)
        }

        func addShapeLayer(path: UIBezierPath, fillColor: CGColor? = nil, strokeColor: CGColor, lineWidth: CGFloat) {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.lineWidth = lineWidth
            shapeLayer.fillColor = fillColor
            shapeLayer.strokeColor = strokeColor
            layer.addSublayer(shapeLayer)
        }
    }
}

// MARK: - JmoVxia---objc

@objc private extension CLRadarChartView {}

// MARK: - JmoVxia---私有方法

private extension CLRadarChartView {}

// MARK: - JmoVxia---公共方法

extension CLRadarChartView {
    static func calculateSize(radius: CGFloat, side: Int, verticalInset: CGFloat, horizontalInset: CGFloat) -> CGSize {
        let value = radius - horizontalInset * 2.0
        let maxHeight: CGFloat = {
            if side % 2 == .zero {
                return 2 * value + verticalInset * 2.0
            } else {
                let angle = (90 - (360 / CGFloat(side) * 0.5)) * .pi / 180
                let tangent = sin(angle) * value
                return tangent + value + verticalInset * 2.0
            }
        }()
        let height = value * 2.0 + verticalInset
        let padding = maxHeight - height
        return .init(width: radius * 2.0, height: height + max(0, padding))
    }

    func reload() {
        setNeedsDisplay()
    }
}
