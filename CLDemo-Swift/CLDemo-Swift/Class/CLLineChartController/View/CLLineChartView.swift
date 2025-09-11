//
//  CLLineChartView.swift
//  CLDemo-Swift
//
//  Created by JmoVxia on 2022/11/12.
//

import UIKit

class CLLineChartView: UIView {
    weak var dataSource: CLLineChartViewDataSource?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CLLineChartView {
    func reload(with animation: Bool = false) {
        guard let dataSource else { return }

        layer.removeAllAnimations()
        layer.sublayers?.removeAll()

        let lines = dataSource.numberOfLines(in: self)
        guard lines > 0 else { return }

        let size = dataSource.size(in: self)
        let axisInX = dataSource.axisInX(in: self)
        let axisInY = dataSource.axisInY(in: self)

        let paddingLeft: CGFloat = 40
        let paddingBottom: CGFloat = 30
        let paddingRight: CGFloat = 16
        let paddingTop: CGFloat = 16

        // 图表坐标系：定义顶部 y、x 轴所在的原点 y、图表宽高
        let chartLeftX: CGFloat = paddingLeft
        let chartRightX: CGFloat = size.width - paddingRight
        let chartTopY: CGFloat = paddingTop
        let chartOriginY: CGFloat = size.height - paddingBottom // X 轴所在的 y（图表底部）
        let chartWidth: CGFloat = max(0, chartRightX - chartLeftX)
        let chartHeight: CGFloat = max(0, chartOriginY - chartTopY)

        // 比例尺
        let widthScale = chartWidth / (axisInX.max - axisInX.min)
        let heightScale = chartHeight / (axisInY.max - axisInY.min)

        // 绘制坐标轴
//        let axisLayer = CAShapeLayer()
//        let axisPath = UIBezierPath()
//
//        // X 轴 从 (paddingLeft, chartOriginY) 到 (chartRightX, chartOriginY)
//        axisPath.move(to: CGPoint(x: chartLeftX, y: chartOriginY))
//        axisPath.addLine(to: CGPoint(x: chartRightX, y: chartOriginY))
//
//        // Y 轴 从 (paddingLeft, chartOriginY) 到 (paddingLeft, chartTopY)
//        axisPath.move(to: CGPoint(x: chartLeftX, y: chartOriginY))
//        axisPath.addLine(to: CGPoint(x: chartLeftX, y: chartTopY))
//
//        axisLayer.path = axisPath.cgPath
//        axisLayer.strokeColor = UIColor.lightGray.cgColor
//        axisLayer.lineWidth = 1
//        layer.addSublayer(axisLayer)

        // 刻度数量
        let xTicks = dataSource.numberOfXTicks(in: self)
        let yTicks = dataSource.numberOfYTicks(in: self)
        let xStepValue = (axisInX.max - axisInX.min) / CGFloat(max(xTicks - 1, 1))
        let yStepValue = (axisInY.max - axisInY.min) / CGFloat(max(yTicks - 1, 1))

        // 绘制 X 刻度线和文字
        for i in 0 ..< xTicks {
            let value = axisInX.min + CGFloat(i) * xStepValue
            let tickX = chartLeftX + (value - axisInX.min) * widthScale

            // 刻度线（向下）
//            let tickPath = UIBezierPath()
//            tickPath.move(to: CGPoint(x: tickX, y: chartOriginY))
//            tickPath.addLine(to: CGPoint(x: tickX, y: chartOriginY + 5))
//            let tickLayer = CAShapeLayer()
//            tickLayer.path = tickPath.cgPath
//            tickLayer.strokeColor = UIColor.gray.cgColor
//            tickLayer.lineWidth = 1
//            layer.addSublayer(tickLayer)

            // 文字（X 轴标签）
            let textLayer = CATextLayer()
            textLayer.string = String(format: "%.0f", value)
            textLayer.fontSize = 10
            textLayer.foregroundColor = UIColor.gray.cgColor
            textLayer.alignmentMode = .center
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.frame = CGRect(x: tickX - 15, y: chartOriginY + 5, width: 30, height: 12)
            layer.addSublayer(textLayer)
        }

        // 绘制 Y 刻度线、文字和水平网格线
        for i in 0 ..< yTicks {
            let value = axisInY.min + CGFloat(i) * yStepValue
            // tickY 从 chartOriginY 向上减去高度偏移
            let tickY = chartOriginY - (value - axisInY.min) * heightScale

            // 刻度线（左侧）
//            let tickPath = UIBezierPath()
//            tickPath.move(to: CGPoint(x: chartLeftX - 5, y: tickY))
//            tickPath.addLine(to: CGPoint(x: chartLeftX, y: tickY))
//            let tickLayer = CAShapeLayer()
//            tickLayer.path = tickPath.cgPath
//            tickLayer.strokeColor = UIColor.gray.cgColor
//            tickLayer.lineWidth = 1
//            layer.addSublayer(tickLayer)

            // 文字（Y 轴标签，右对齐靠在左侧 padding 区域）
            let textLayer = CATextLayer()
            textLayer.string = String(format: "%.0f", value)
            textLayer.fontSize = 10
            textLayer.foregroundColor = UIColor.gray.cgColor
            textLayer.alignmentMode = .right
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.frame = CGRect(x: 0, y: tickY - 6, width: paddingLeft - 8, height: 12)
            layer.addSublayer(textLayer)

            // 水平虚线网格（不画最底部 i == 0）
//            if i != 0 {
            let gridLayer = CAShapeLayer()
            let gridPath = UIBezierPath()
            gridPath.move(to: CGPoint(x: chartLeftX, y: tickY))
            gridPath.addLine(to: CGPoint(x: chartRightX, y: tickY))
            gridLayer.path = gridPath.cgPath
            gridLayer.strokeColor = UIColor.lightGray.cgColor
            gridLayer.lineWidth = 0.5
            gridLayer.lineDashPattern = [4, 4] // 虚线
            layer.addSublayer(gridLayer)
//            }
        }

        // 绘制折线图
        for line in 0 ..< lines {
            let points = dataSource.chartView(self, numberOfPointsInLine: line)
                .map { CGPoint(
                    x: chartLeftX + ($0.x - axisInX.min) * widthScale,
                    y: chartOriginY - ($0.y - axisInY.min) * heightScale
                ) }

            let lineLayer = dataSource.chartView(self, layerForLineAt: line)
            let linePath: UIBezierPath = .init(curve: points, withSmoothness: 0.3, interval: .init(origin: .zero, size: CGSize(width: chartWidth, height: chartHeight)))
            lineLayer.path = linePath.cgPath
            lineLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = dataSource.chartView(self, gradientColorsForLineAt: line)
            gradientLayer.frame = CGRect(origin: .zero, size: size)
            gradientLayer.mask = {
                guard let start = points.first, let end = points.last, let cgPath = lineLayer.path else { return nil }
                let maskPath = UIBezierPath(cgPath: cgPath)
                // 将路径封闭到底部图表原点（chartOriginY），而不是整个 view 底部
                maskPath.addLine(to: CGPoint(x: end.x, y: chartOriginY))
                maskPath.addLine(to: CGPoint(x: start.x, y: chartOriginY))
                maskPath.close()
                let maskLayer = CAShapeLayer()
                maskLayer.path = maskPath.cgPath
                return maskLayer
            }()

            layer.addSublayer(gradientLayer)
            layer.addSublayer(lineLayer)

            guard animation else { continue }
            let animationLayer = CABasicAnimation(keyPath: "strokeEnd")
            animationLayer.duration = 2
            animationLayer.fromValue = 0
            animationLayer.toValue = 1
            animationLayer.isRemovedOnCompletion = false
            animationLayer.fillMode = .forwards
            animationLayer.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            lineLayer.add(animationLayer, forKey: "strokeEnd")
        }

        // 整体遮罩动画（遮罩的大小也以 view 的 size 为准，这里保持不变）
        guard animation else { return }
        let animationLayer = CAShapeLayer()
        animationLayer.path = UIBezierPath(rect: CGRect(origin: .zero, size: size)).cgPath
        animationLayer.anchorPoint = CGPoint(x: 1, y: 0)
        layer.mask = animationLayer

        let animation = CABasicAnimation(keyPath: "bounds.size.width")
        animation.duration = 2
        animation.fromValue = size.width
        animation.toValue = 0
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animationLayer.add(animation, forKey: "bounds.size.width")
    }
}
