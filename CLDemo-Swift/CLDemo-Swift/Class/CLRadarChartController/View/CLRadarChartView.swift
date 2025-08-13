//
//  CLRadarChartView.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2023/4/10.
//

import UIKit

// MARK: - JmoVxia---私有几何工具

private extension CLRadarChartView {
    enum CLGeometry {
        static func isPointInPolygon(_ point: CGPoint, polygon: [CGPoint]) -> Bool {
            guard polygon.count >= 3 else { return false }
            var isInside = false
            var j = polygon.count - 1
            for i in 0 ..< polygon.count {
                let startVertex = polygon[i]
                let endVertex = polygon[j]
                let isYBetween = (startVertex.y > point.y) != (endVertex.y > point.y)
                if isYBetween {
                    let intersectionX = (endVertex.x - startVertex.x) * (point.y - startVertex.y) / (endVertex.y - startVertex.y) + startVertex.x
                    if point.x < intersectionX { isInside.toggle() }
                }
                j = i
            }
            return isInside
        }

        static func doesRectIntersectPolygon(_ rect: CGRect, polygon: [CGPoint]) -> Bool {
            let corners = [
                rect.origin,
                CGPoint(x: rect.maxX, y: rect.minY),
                CGPoint(x: rect.maxX, y: rect.maxY),
                CGPoint(x: rect.minX, y: rect.maxY),
            ]
            return polygon.contains(where: rect.contains)
                || corners.contains(where: { isPointInPolygon($0, polygon: polygon) })
        }
    }
}

private extension CGPoint {
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGVector {
        CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
    }

    static func + (lhs: CGPoint, rhs: CGVector) -> CGPoint {
        CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }
}

private extension CGVector {
    var length: CGFloat {
        sqrt(dx * dx + dy * dy)
    }

    var normalized: CGVector {
        let len = length
        return len > 0 ? CGVector(dx: dx / len, dy: dy / len) : .zero
    }

    static func * (lhs: CGVector, rhs: CGFloat) -> CGVector {
        CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }
}

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
        guard let dataSource else { return }

        subviews.forEach { $0.removeFromSuperview() }
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        let horizontalInset = dataSource.horizontalInset(in: self)
        let verticalInset = dataSource.verticalInset(in: self)
        let chartMaxRadius = dataSource.maximumRadius(in: self) - horizontalInset
        let chartPointCount = dataSource.numberOfPoints(in: self)
        let chartLayerCount = dataSource.numberOfWebLayers(in: self)
        let chartMaxValue = dataSource.maximumValue(in: self)
        let margin = dataSource.labelMargin

        let centerPoint = CGPoint(x: rect.midX, y: chartMaxRadius + verticalInset)
        let angle = .pi * 2 / CGFloat(chartPointCount)

        drawWebLayer(in: rect, maxRadius: chartMaxRadius, layers: chartLayerCount, points: chartPointCount, angle: angle, center: centerPoint)
        drawAxisLine(maxRadius: chartMaxRadius, points: chartPointCount, angle: angle, center: centerPoint)
        drawCharts(maxRadius: chartMaxRadius, maxValue: chartMaxValue, points: chartPointCount, angle: angle, center: centerPoint)
        drawAttributedText(maxRadius: chartMaxRadius, points: chartPointCount, angle: angle, center: centerPoint, margin: margin)
    }
}

// MARK: - JmoVxia---objc

@objc private extension CLRadarChartView {}

// MARK: - JmoVxia---私有方法

private extension CLRadarChartView {
    func drawWebLayer(in rect: CGRect, maxRadius: CGFloat, layers: Int, points: Int, angle: CGFloat, center: CGPoint) {
        for index in (1 ... layers).reversed() {
            let radius = maxRadius * CGFloat(index) / CGFloat(layers)
            let path = UIBezierPath()
            for pointIndex in 0 ..< points {
                let point = calculatePoint(radius: radius, pointIndex: pointIndex, angle: angle, centerPoint: center)
                if pointIndex == .zero {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            path.close()
            addShapeLayer(path: path,
                          fillColor: dataSource?.radarChart(self, webLayerFillColorAt: index).cgColor,
                          strokeColor: dataSource?.radarChart(self, webLayerBorderColorAt: index).cgColor,
                          lineWidth: 0.5)
        }
    }

    func drawAxisLine(maxRadius: CGFloat, points: Int, angle: CGFloat, center: CGPoint) {
        for index in 0 ..< points {
            let point = calculatePoint(radius: maxRadius, pointIndex: index, angle: angle, centerPoint: center)
            let path = UIBezierPath()
            path.move(to: center)
            path.addLine(to: point)
            addShapeLayer(path: path,
                          strokeColor: dataSource?.radarChart(self, webLayerBorderColorAt: index).cgColor,
                          lineWidth: 0.5)
        }
    }

    func drawCharts(maxRadius: CGFloat, maxValue: CGFloat, points: Int, angle: CGFloat, center: CGPoint) {
        guard let dataSource else { return }
        let charts = dataSource.numberOfCharts(in: self)
        let pointRadius = 2.0

        for index in 0 ..< charts {
            let fillColor = dataSource.radarChart(self, chartFillColorAt: index)
            let borderColor = dataSource.radarChart(self, chartBorderColorAt: index)
            let values = dataSource.radarChart(self, valuesForChartAt: index)
            let path = UIBezierPath()

            for (valueIndex, value) in values.enumerated() {
                let radius = (maxRadius - pointRadius) * value / maxValue
                let point = calculatePoint(radius: radius, pointIndex: valueIndex, angle: angle, centerPoint: center)
                if valueIndex == .zero {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }

                let circlePath = UIBezierPath(arcCenter: point, radius: pointRadius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
                addShapeLayer(path: circlePath, fillColor: borderColor.cgColor)
            }
            path.close()
            addShapeLayer(path: path,
                          fillColor: fillColor.cgColor,
                          strokeColor: borderColor.cgColor,
                          lineWidth: 1)
        }
    }

    func drawAttributedText(maxRadius: CGFloat, points: Int, angle: CGFloat, center: CGPoint, margin: CGFloat) {
        guard let dataSource else { return }
        let polygonPoints = (0 ..< points).map { i in
            calculatePoint(radius: maxRadius, pointIndex: i, angle: angle, centerPoint: center)
        }

        for index in 0 ..< points {
            let attributedText = dataSource.radarChart(self, attributedTextAt: index)
            let size = attributedText.size()

            let origin = calculateLabelOrigin(
                for: index,
                with: size,
                polygonPoints: polygonPoints,
                centerPoint: center,
                maxRadius: maxRadius,
                margin: margin
            )
//            attributedText.draw(at: origin)
            let label = UILabel(frame: .init(origin: origin, size: size))
            label.numberOfLines = 0
            label.attributedText = attributedText
            label.backgroundColor = .random
            addSubview(label)
        }
    }

    func addShapeLayer(path: UIBezierPath, fillColor: CGColor? = nil, strokeColor: CGColor? = nil, lineWidth: CGFloat = 0) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = fillColor
        shapeLayer.strokeColor = strokeColor
        layer.addSublayer(shapeLayer)
    }

    func calculatePoint(radius: CGFloat, pointIndex: Int, angle: CGFloat, centerPoint: CGPoint) -> CGPoint {
        let x = radius * sin(angle * CGFloat(pointIndex))
        let y = radius * cos(angle * CGFloat(pointIndex))
        return centerPoint + CGVector(dx: x, dy: -y)
    }

    func calculateLabelOrigin(for index: Int, with size: CGSize, polygonPoints: [CGPoint], centerPoint: CGPoint, maxRadius: CGFloat, margin: CGFloat) -> CGPoint {
        let vertex = polygonPoints[index]
        let direction = (vertex - centerPoint).normalized
        guard direction != .zero else {
            return CGPoint(x: centerPoint.x - size.width / 2, y: centerPoint.y - maxRadius - size.height - 6.0)
        }
        let spacing = (margin > 0 ? margin : 6.0)
        let anchor = vertex + direction * spacing

        let initialOrigin = calculateInitialOrigin(from: anchor, for: size, basedOn: direction)

        var finalOrigin = initialOrigin
        var labelRect = CGRect(origin: finalOrigin, size: size)

        if CLGeometry.doesRectIntersectPolygon(labelRect, polygon: polygonPoints) {
            let step: CGFloat = 1.0
            let maxIterations = Int(maxRadius * 0.5)

            for _ in 0 ..< maxIterations {
                finalOrigin = finalOrigin + direction * step
                labelRect.origin = finalOrigin
                if !CLGeometry.doesRectIntersectPolygon(labelRect, polygon: polygonPoints) {
                    break
                }
            }
        }
        return finalOrigin
    }

    private func calculateInitialOrigin(from anchor: CGPoint, for size: CGSize, basedOn vector: CGVector) -> CGPoint {
        var origin: CGPoint
        let (w, h) = (size.width, size.height)

        let axisThreshold = 1.0 / sqrt(2.0)

        if abs(vector.dx) > axisThreshold {
            origin = CGPoint(x: vector.dx > 0 ? anchor.x : anchor.x - w, y: anchor.y - h / 2)
        } else {
            origin = CGPoint(x: anchor.x - w / 2, y: vector.dy > 0 ? anchor.y : anchor.y - h)
        }
        return origin
    }
}

// MARK: - JmoVxia---公共方法

extension CLRadarChartView {
    static func calculateSize(radius: CGFloat, side: Int, verticalInset: CGFloat, horizontalInset: CGFloat) -> CGSize {
        let value = radius - horizontalInset
        let maxHeight: CGFloat = {
            if side % 2 == .zero {
                return 2 * value + verticalInset * 2.0
            } else {
                let angle = (90 - (360 / CGFloat(side) * 0.5)) * .pi / 180
                let tangent = sin(angle) * value
                return tangent + value + verticalInset * 2.0
            }
        }()
        let height = value * 2.0
        let padding = maxHeight - height
        return .init(width: radius * 2.0, height: height + max(0, padding))
    }

    func reload() {
        setNeedsDisplay()
    }
}
