//
//  CLQRCode.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2024/3/28.
//

import Foundation

extension CGPoint {
    func isContained(in points: [CGPoint]) -> Bool {
        points.contains(where: { $0 == self })
    }

    func adjacentPoints() -> [CGPoint] {
        [
            CGPoint(x: x - 1, y: y),
            CGPoint(x: x + 1, y: y),
            CGPoint(x: x, y: y - 1),
            CGPoint(x: x, y: y + 1),
        ]
    }
}

extension CLQRCode {
    enum CorrectionLevel: String {
        case low = "L"
        case medium = "M"
        case quartile = "Q"
        case high = "H"
    }

    enum DecorationStyle {
        case heart
        case mosaic(radius: CGFloat)
        case vertical
        case horizontal
        case tile(radius: CGFloat)

        static var random: DecorationStyle {
            let allStyles: [DecorationStyle] = [.heart, .mosaic(radius: CGFloat.random(in: 0.0 ... 0.5)), .vertical, horizontal, .tile(radius: CGFloat.random(in: 0.0 ... 0.5))]
            return allStyles.randomElement() ?? .heart
        }
    }

    struct BorderStyle {
        struct CornerStyle {
            var gradientRotation = GradientRotation()
            var radii = CGFloat.random(in: 0.0 ... 0.5)
            var corners: UIRectCorner = {
                let allCorners: [UIRectCorner] = [.topLeft, .topRight, .bottomLeft, .bottomRight]
                let selectedCorners = allCorners.shuffled().prefix(Int.random(in: 1 ... 4))
                return selectedCorners.reduce(UIRectCorner()) { $0.union($1) }
            }()
        }

        var innerCorner = CornerStyle()
        var outerCorner = CornerStyle()
    }

    struct GradientRotation {
        var colors: [(color: UIColor, location: CGFloat)] = [
            (UIColor.random.withAlphaComponent(0.8), 0.0),
            (UIColor.random.withAlphaComponent(0.6), 0.4),
            (UIColor.random.withAlphaComponent(0.8), 1.0),
        ]
        var angleDegrees = CGFloat.random(in: 0.0 ... 360.0)
    }
}

struct CLQRCode {
    var content: String

    var scalingFactor = CGFloat.random(in: 0.6 ... 0.85)

    var baseSize = 30.0

    var correctionLevel = CorrectionLevel.high

    var decorationStyle = DecorationStyle.random

    var borders = (topLeft: BorderStyle(), topRight: BorderStyle(), bottomLeft: BorderStyle())

    var gradientRotation = GradientRotation()
}

extension CLQRCode {
    func generate() -> UIImage? {
        guard !content.isEmpty else { return nil }
        return autoreleasepool {
            guard let qrCodeFilter = CIFilter(name: "CIQRCodeGenerator"), let data = content.data(using: .utf8) else { return nil }
            qrCodeFilter.setDefaults()
            qrCodeFilter.setValue(data, forKey: "inputMessage")
            qrCodeFilter.setValue(correctionLevel.rawValue, forKey: "inputCorrectionLevel")
            guard let ciImage = qrCodeFilter.outputImage else { return nil }

            let codeMatrix = extractCodeMatrix(from: ciImage)
            let finalSize = max(baseSize, 30) * Double(ciImage.extent.size.width)
            return drawQRCode(from: codeMatrix, size: CGFloat(finalSize))
        }
    }
}

private extension CLQRCode {
    func extractCodeMatrix(from image: CIImage) -> [[(CGPoint, Bool)]] {
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

    func drawQRCode(from codePoints: [[(CGPoint, Bool)]], size: CGFloat) -> UIImage {
        let delta = size / CGFloat(codePoints.count)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        return renderer.image { ctx in
            let context = ctx.cgContext
            func drawPath(_ path: UIBezierPath, gradientRotation: GradientRotation) {
                guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientRotation.colors.map(\.color.cgColor) as CFArray, locations: gradientRotation.colors.map(\.location)) else { return }

                context.saveGState()
                context.setShouldAntialias(true)
                context.addPath(path.cgPath)
                context.clip(using: .evenOdd)

                let angleRadians = gradientRotation.angleDegrees * .pi / 180.0
                let diagonalLength = sqrt(pow(path.bounds.width, 2) + pow(path.bounds.height, 2))
                let centerPoint = CGPoint(x: path.bounds.midX, y: path.bounds.midY)

                let startPoint = CGPoint(
                    x: centerPoint.x - cos(angleRadians) * diagonalLength / 2,
                    y: centerPoint.y - sin(angleRadians) * diagonalLength / 2
                )
                let endPoint = CGPoint(
                    x: centerPoint.x + cos(angleRadians) * diagonalLength / 2,
                    y: centerPoint.y + sin(angleRadians) * diagonalLength / 2
                )
                context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
                context.restoreGState()
            }
            let path = UIBezierPath()
            let drawPoints = codePoints.flatMap { $0.compactMap { $0.1 ? $0.0 : nil } }
            for points in codePoints {
                for (point, isCodePoint) in points where isCodePoint {
                    guard point.x >= 8 || point.y >= 8 else { continue }
                    guard point.y >= 8 || point.x < CGFloat(codePoints.count - 8) else { continue }
                    guard point.x >= 8 || point.y < CGFloat(codePoints.count - 8) else { continue }
                    switch decorationStyle {
                    case .heart:
                        path.append(heartPath(point, delta: delta))
                    case let .mosaic(radius):
                        path.append(adhesionPointPath(point, delta: delta, radius: radius, in: drawPoints))
                    case .vertical:
                        path.append(verticalPointPath(point, delta: delta))
                    case .horizontal:
                        path.append(horizontalPointPath(point, delta: delta))
                    case let .tile(radius):
                        path.append(pointPath(point, delta: delta, radius: radius))
                    }
                }
            }

            drawPath(outBorderPath(.init(x: 4, y: 4), delta: delta, corner: borders.topLeft.outerCorner), gradientRotation: borders.topLeft.outerCorner.gradientRotation)
            drawPath(outBorderPath(.init(x: codePoints.count - 5, y: 4), delta: delta, corner: borders.topRight.outerCorner), gradientRotation: borders.topRight.outerCorner.gradientRotation)
            drawPath(outBorderPath(.init(x: 4, y: codePoints.count - 5), delta: delta, corner: borders.bottomLeft.outerCorner), gradientRotation: borders.bottomLeft.outerCorner.gradientRotation)

            drawPath(inBorderPath(.init(x: 4, y: 4), delta: delta, corner: borders.topLeft.innerCorner), gradientRotation: borders.topLeft.innerCorner.gradientRotation)
            drawPath(inBorderPath(.init(x: codePoints.count - 5, y: 4), delta: delta, corner: borders.topRight.innerCorner), gradientRotation: borders.topRight.innerCorner.gradientRotation)
            drawPath(inBorderPath(.init(x: 4, y: codePoints.count - 5), delta: delta, corner: borders.bottomLeft.innerCorner), gradientRotation: borders.bottomLeft.innerCorner.gradientRotation)

            drawPath(path, gradientRotation: gradientRotation)
        }
    }
}

private extension CLQRCode {
    func heartPath(_ point: CGPoint, delta: CGFloat) -> UIBezierPath {
        let padding = 0.0
        let curveRadius = (delta * scalingFactor - 2 * padding) / 4.0
        let heartPath = UIBezierPath()
        let tipLocation = CGPoint(x: point.x * delta + delta * scalingFactor / 2, y: point.y * delta + delta * scalingFactor - padding)
        heartPath.move(to: tipLocation)
        let topLeftCurveStart = CGPoint(x: point.x * delta + padding, y: point.y * delta + delta * scalingFactor / 4.0)
        heartPath.addQuadCurve(to: topLeftCurveStart, controlPoint: CGPoint(x: topLeftCurveStart.x, y: topLeftCurveStart.y + curveRadius))
        heartPath.addArc(withCenter: CGPoint(x: topLeftCurveStart.x + curveRadius, y: topLeftCurveStart.y), radius: curveRadius, startAngle: .pi, endAngle: 0, clockwise: true)
        let topRightCurveStart = CGPoint(x: topLeftCurveStart.x + 2 * curveRadius, y: topLeftCurveStart.y)
        heartPath.addArc(withCenter: CGPoint(x: topRightCurveStart.x + curveRadius, y: topRightCurveStart.y), radius: curveRadius, startAngle: .pi, endAngle: 0, clockwise: true)
        let topRightCurveEnd = CGPoint(x: topLeftCurveStart.x + 4 * curveRadius, y: topRightCurveStart.y)
        heartPath.addQuadCurve(to: tipLocation, controlPoint: CGPoint(x: topRightCurveEnd.x, y: topRightCurveEnd.y + curveRadius))
        return heartPath
    }

    func pointPath(_ point: CGPoint, delta: CGFloat, radius: CGFloat) -> UIBezierPath {
        let width = delta * scalingFactor
        return UIBezierPath(roundedRect: CGRect(x: point.x * delta, y: point.y * delta, width: width, height: width), cornerRadius: width * radius)
    }

    func verticalPointPath(_ point: CGPoint, delta: CGFloat) -> UIBezierPath {
        let width = delta * scalingFactor
        return UIBezierPath(roundedRect: CGRect(x: point.x * delta, y: point.y * delta, width: width, height: delta), cornerRadius: 0)
    }

    func horizontalPointPath(_ point: CGPoint, delta: CGFloat) -> UIBezierPath {
        let width = delta * scalingFactor
        return UIBezierPath(roundedRect: CGRect(x: point.x * delta, y: point.y * delta, width: delta, height: width), cornerRadius: 0)
    }

    func adhesionPointPath(_ point: CGPoint, delta: CGFloat, radius: CGFloat, in points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        let size: CGFloat = delta * scalingFactor
        let radius: CGFloat = delta * scalingFactor * radius
        let adjacent = point.adjacentPoints()

        let hasLeft = adjacent[0].isContained(in: points)
        let hasRight = adjacent[1].isContained(in: points)
        let hasTop = adjacent[2].isContained(in: points)
        let hasBottom = adjacent[3].isContained(in: points)

        let rect = CGRect(x: point.x * delta, y: point.y * delta, width: size, height: size)

        if !hasLeft, !hasTop {
            path.move(to: CGPoint(x: rect.minX, y: rect.minY + radius))
            path.addArc(withCenter: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                        radius: radius,
                        startAngle: .pi,
                        endAngle: 3 * .pi / 2,
                        clockwise: true)
        } else {
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        }

        if !hasRight, !hasTop {
            path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
            path.addArc(withCenter: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                        radius: radius,
                        startAngle: 3 * .pi / 2,
                        endAngle: 0,
                        clockwise: true)
        } else {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        }

        if !hasRight, !hasBottom {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
            path.addArc(withCenter: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                        radius: radius,
                        startAngle: 0,
                        endAngle: .pi / 2,
                        clockwise: true)
        } else {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }

        if !hasLeft, !hasBottom {
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

    func inBorderPath(_ point: CGPoint, delta: CGFloat, corner: BorderStyle.CornerStyle) -> UIBezierPath {
        let width = (3 - (1 - scalingFactor)) * delta
        let cornerRadii = CGSize(width: width * corner.radii, height: width * corner.radii)
        return UIBezierPath(roundedRect: CGRect(origin: .init(x: point.x * delta - 1 * delta, y: point.y * delta - 1 * delta), size: .init(width: width, height: width)),
                            byRoundingCorners: corner.corners,
                            cornerRadii: cornerRadii)
    }

    func outBorderPath(_ point: CGPoint, delta: CGFloat, corner: BorderStyle.CornerStyle) -> UIBezierPath {
        let outWidth = (7 - (1 - scalingFactor)) * delta
        let inWidth = (5 - (1 - scalingFactor)) * delta
        let outerCornerRadii = CGSize(width: outWidth * corner.radii, height: outWidth * corner.radii)
        let innerCornerRadii = CGSize(width: inWidth * corner.radii, height: inWidth * corner.radii)
        let outerPath = UIBezierPath(roundedRect: CGRect(origin: .init(x: point.x * delta - 3 * delta, y: point.y * delta - 3 * delta), size: .init(width: outWidth, height: outWidth)),
                                     byRoundingCorners: corner.corners,
                                     cornerRadii: outerCornerRadii)
        let hollowPath = UIBezierPath(roundedRect: CGRect(origin: .init(x: point.x * delta - 2 * delta, y: point.y * delta - 2 * delta), size: .init(width: inWidth, height: inWidth)),
                                      byRoundingCorners: corner.corners,
                                      cornerRadii: innerCornerRadii)
        outerPath.append(hollowPath)
        outerPath.usesEvenOddFillRule = true
        return outerPath
    }
}
