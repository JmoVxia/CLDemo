//
//  CLQRCode.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2024/3/28.
//

import Foundation

import Foundation

extension CGPoint {
    // 检查点是否在数组中
    func isContained(in points: [CGPoint]) -> Bool {
        points.contains(where: { $0 == self })
    }

    // 获取周围的点
    func adjacentPoints() -> [CGPoint] {
        [
            CGPoint(x: x - 1, y: y), // 左
            CGPoint(x: x + 1, y: y), // 右
            CGPoint(x: x, y: y - 1), // 上
            CGPoint(x: x, y: y + 1), // 下
        ]
    }
}

extension CLQRCode {
    enum CLQRCodeCorrectionLevel: String {
        case low = "L"
        case normal = "M"
        case superior = "Q"
        case high = "H"
    }

    struct CKDColor {
        var `in`: UIColor = .black
        var out: UIColor = .black
    }
}

struct CLQRCode {
    var text: String
    var scale = 1.0
    var delta = 90.0
    var correctionLevel = CLQRCodeCorrectionLevel.low
    var colorsArray = [UIColor.black]

    var leftTop = CKDColor()

    var rightTop = CKDColor()

    var leftBottom = CKDColor()
}

extension CLQRCode {
    func generateQRCode() -> UIImage? {
        guard !text.isEmpty else { return nil }
        return autoreleasepool {
            guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
            let data = text.data(using: .utf8)
            filter.setDefaults()
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue(correctionLevel.rawValue, forKey: "inputCorrectionLevel")
            guard let originalImg = filter.outputImage else { return nil }

            let points = getPixelsPoints(from: originalImg)
            let extent = originalImg.extent.size.width
            let size = min(max(delta, 30), 60) * extent
            return drawWithPoints(points, size: size)
        }
    }
}

private extension CLQRCode {
    func getPixelsPoints(from image: CIImage) -> [[(CGPoint, Bool)]] {
        guard let imageRef = CIContext(options: nil).createCGImage(image, from: image.extent.integral) else { return [[]] }
        let width = imageRef.width
        let height = imageRef.height

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var rawData = [UInt8](repeating: 0, count: Int(height * width * 4))

        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let bitsPerComponent = 8

        guard let context = CGContext(data: &rawData, width: Int(width), height: Int(height), bitsPerComponent: bitsPerComponent, bytesPerRow: Int(bytesPerRow), space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return [[]] }

        context.draw(imageRef, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))

        let pixels = (0 ..< height).map { y -> [(CGPoint, Bool)] in
            (0 ..< width).map { x -> (CGPoint, Bool) in
                let byteIndex = (bytesPerRow * y) + x * bytesPerPixel
                let red = rawData[byteIndex]
                let green = rawData[byteIndex + 1]
                let blue = rawData[byteIndex + 2]
                return (.init(x: x, y: y), red == 0 && green == 0 && blue == 0)
            }
        }
        return pixels
    }

    func drawWithPoints(_ codePoints: [[(CGPoint, Bool)]], size: CGFloat) -> UIImage? {
        let delta = size / CGFloat(codePoints.count)
        UIGraphicsBeginImageContext(CGSize(width: size, height: size))
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        func drawPath(_ path: UIBezierPath, color: UIColor, mode: CGPathDrawingMode) {
            context.saveGState()
            context.setShouldAntialias(true)
            context.setFillColor(color.cgColor)
            context.addPath(path.cgPath)
            context.drawPath(using: mode)
            context.restoreGState()
        }

//        for points in codePoints {
//            for (point, isCodePoint) in points where isCodePoint {
//                guard point.x >= 8 || point.y >= 8 else { continue }
//                guard point.y >= 8 || point.x < CGFloat(codePoints.count - 8) else { continue }
//                guard point.x >= 8 || point.y < CGFloat(codePoints.count - 8) else { continue }
//                drawPath(heartPath(point), color: colorsArray.randomElement() ?? .black, mode: .fill)
//            }
//        }

        let drawPoints = codePoints.flatMap { $0.compactMap { $0.1 ? $0.0 : nil } }
        for points in codePoints {
            for (point, isCodePoint) in points where isCodePoint {
                guard point.x >= 8 || point.y >= 8 else { continue }
                guard point.y >= 8 || point.x < CGFloat(codePoints.count - 8) else { continue }
                guard point.x >= 8 || point.y < CGFloat(codePoints.count - 8) else { continue }
                drawPath(adhesionPointPath(point, in: drawPoints), color: colorsArray.randomElement() ?? .black, mode: .fill)
            }
        }

        drawPath(outBorderPath(.init(x: 4, y: 4), delta: delta), color: leftTop.out, mode: .eoFill)
        drawPath(outBorderPath(.init(x: codePoints.count - 5, y: 4), delta: delta), color: rightTop.out, mode: .eoFill)
        drawPath(outBorderPath(.init(x: 4, y: codePoints.count - 5), delta: delta), color: leftBottom.out, mode: .eoFill)

        drawPath(inBorderPath(.init(x: 4, y: 4), delta: delta), color: leftTop.in, mode: .fill)
        drawPath(inBorderPath(.init(x: codePoints.count - 5, y: 4), delta: delta), color: rightTop.in, mode: .fill)
        drawPath(inBorderPath(.init(x: 4, y: codePoints.count - 5), delta: delta), color: leftBottom.in, mode: .fill)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension CLQRCode {
    func heartPath(_ point: CGPoint, delta: CGFloat) -> UIBezierPath {
        let padding = 0.0
        let curveRadius = (delta * scale - 2 * padding) / 4.0
        let heartPath = UIBezierPath()
        let tipLocation = CGPoint(x: point.x * delta + delta * scale / 2, y: point.y * delta + delta * scale - padding)
        heartPath.move(to: tipLocation)
        let topLeftCurveStart = CGPoint(x: point.x * delta + padding, y: point.y * delta + delta * scale / 2.4)
        heartPath.addQuadCurve(to: topLeftCurveStart, controlPoint: CGPoint(x: topLeftCurveStart.x, y: topLeftCurveStart.y + curveRadius))
        heartPath.addArc(withCenter: CGPoint(x: topLeftCurveStart.x + curveRadius, y: topLeftCurveStart.y), radius: curveRadius, startAngle: .pi, endAngle: 0, clockwise: true)
        let topRightCurveStart = CGPoint(x: topLeftCurveStart.x + 2 * curveRadius, y: topLeftCurveStart.y)
        heartPath.addArc(withCenter: CGPoint(x: topRightCurveStart.x + curveRadius, y: topRightCurveStart.y), radius: curveRadius, startAngle: .pi, endAngle: 0, clockwise: true)
        let topRightCurveEnd = CGPoint(x: topLeftCurveStart.x + 4 * curveRadius, y: topRightCurveStart.y)
        heartPath.addQuadCurve(to: tipLocation, controlPoint: CGPoint(x: topRightCurveEnd.x, y: topRightCurveEnd.y + curveRadius))
        heartPath.fill()
        return heartPath
    }

    func pointPath(_ point: CGPoint, delta: CGFloat) -> UIBezierPath {
        let width = delta * scale
        return UIBezierPath(roundedRect: CGRect(x: point.x * delta, y: point.y * delta, width: width, height: width), cornerRadius: width * 0.3)
    }

    func adhesionPointPath(_ point: CGPoint, in points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        let size: CGFloat = delta * scale // 点的单位尺寸
        let radius: CGFloat = delta * scale * 0.5 // 圆角的半径，根据实际需要调整

        // 获取周围点
        let adjacent = point.adjacentPoints()

        // 判断周围的点是否存在
        let hasLeft = adjacent[0].isContained(in: points)
        let hasRight = adjacent[1].isContained(in: points)
        let hasTop = adjacent[2].isContained(in: points)
        let hasBottom = adjacent[3].isContained(in: points)

        // 根据相邻点绘制路径
        let rect = CGRect(x: point.x * delta, y: point.y * delta, width: size, height: size)

        if !hasLeft, !hasTop { // 左上圆角
            path.move(to: CGPoint(x: rect.minX, y: rect.minY + radius))
            path.addArc(withCenter: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                        radius: radius,
                        startAngle: .pi,
                        endAngle: 3 * .pi / 2,
                        clockwise: true)
        } else {
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        }

        if !hasRight, !hasTop { // 右上圆角
            path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
            path.addArc(withCenter: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                        radius: radius,
                        startAngle: 3 * .pi / 2,
                        endAngle: 0,
                        clockwise: true)
        } else {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        }

        if !hasRight, !hasBottom { // 右下圆角
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
            path.addArc(withCenter: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                        radius: radius,
                        startAngle: 0,
                        endAngle: .pi / 2,
                        clockwise: true)
        } else {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }

        if !hasLeft, !hasBottom { // 左下圆角
            path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
            path.addArc(withCenter: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                        radius: radius,
                        startAngle: .pi / 2,
                        endAngle: .pi,
                        clockwise: true)
        } else {
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }

        path.close()
        return path
    }

    func inBorderPath(_ point: CGPoint, delta: CGFloat) -> UIBezierPath {
        let radius = (3 * 0.5 - (1 - scale) * 0.5) * delta
        return UIBezierPath(arcCenter: CGPoint(x: point.x * delta + 0.5 * delta * scale, y: point.y * delta + 0.5 * delta * scale), radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
    }

    func outBorderPath(_ point: CGPoint, delta: CGFloat) -> UIBezierPath {
        let outWidth = (7 - (1 - scale)) * delta
        let inWidth = (5 - (1 - scale)) * delta

        let outerPath = UIBezierPath(roundedRect: CGRect(origin: .init(x: point.x * delta - 3 * delta, y: point.y * delta - 3 * delta), size: .init(width: outWidth, height: outWidth)),
                                     cornerRadius: outWidth * (3.0 / 14.0))

        let hollowPath = UIBezierPath(roundedRect: CGRect(origin: .init(x: point.x * delta - 2 * delta, y: point.y * delta - 2 * delta), size: .init(width: inWidth, height: inWidth)),
                                      cornerRadius: inWidth * (3.0 / 14.0))
        outerPath.append(hollowPath)
        outerPath.usesEvenOddFillRule = true
        return outerPath
    }
}
