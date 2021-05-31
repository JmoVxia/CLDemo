//
//  CLWaveformView.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/6/2.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

@objcMembers
class CLWaveformView: UIView {

    let widthScaling: CGFloat = 0.95
    let heightScaling: CGFloat = 0.8
    
    var filter: CLSampleDataFilter?
    var loadingView: UIActivityIndicatorView!
    
    var asset: AVAsset? {
        didSet {
            guard let asset = asset else { return }
            loadingView.startAnimating()
            //从资源中获取到样本数据后进行绘制
            CLSampleDataProvider.loadAudioSamplesFormAsset(asset){sampleData in
                self.filter = CLSampleDataFilter(sampleData: sampleData)
                self.loadingView.stopAnimating()
                self.setNeedsDisplay()
            }
        }
    }

    var waveColor: UIColor = .hexColor(with: "#996699", alpha: 0.6) {
        didSet {
            layer.borderWidth = 2.0
            layer.borderColor = waveColor.cgColor
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func setupView() {
        backgroundColor = .hexColor(with: "#CCCCCC", alpha: 0.4)
        layer.cornerRadius = 2.0
        layer.masksToBounds = true

        loadingView = UIActivityIndicatorView(style: .white)
        addSubview(loadingView)
    }
    override func draw(_ rect: CGRect) {
//        do {
//            //1. 获取绘图上下文
//            guard let context = UIGraphicsGetCurrentContext() else { return }
//            //2. 获取需要进行绘制的数据
//            guard let filteredSamples = filter?.filteredSamplesForSize(bounds.size, scale: 2) else {
//                return
//            }
//            //3. 设置画布的缩放和上下左右间距
//            context.scaleBy(x: widthScaling, y: heightScaling);
//            let xOffset = bounds.size.width - (bounds.size.width * widthScaling)
//            let yOffset = bounds.size.height - (bounds.size.height * heightScaling)
//            context.translateBy(x: xOffset / 2, y: yOffset / 2);
//
//            //4. 绘制上半部分
//            let midY = rect.midY
//            let halfPath = CGMutablePath()
//            halfPath.move(to: CGPoint(x: 0, y: midY))
//
//            for i in 0..<filteredSamples.count {
//                let sample = CGFloat(filteredSamples[i])
//                halfPath.addLine(to: CGPoint(x: CGFloat(i), y: midY - sample))
//            }
//            halfPath.addLine(to: CGPoint(x: CGFloat(filteredSamples.count), y: midY))
//
//            //5. 绘制下半部分,对上半部分进行translate和sacle变化,即翻转上半部分
//            let fullPath = CGMutablePath()
//            fullPath.addPath(halfPath)
//            var transform = CGAffineTransform.identity;
//            transform = transform.translatedBy(x: 0, y: rect.height);
//            transform = transform.scaledBy(x: 1.0, y: -1.0);
//            fullPath.addPath(halfPath, transform:transform)
//
//            //6. 将完整路径添加到上下文
//            context.addPath(fullPath);
//            context.setFillColor(waveColor.cgColor);
//            context.drawPath(using: .fill);
//        }
        do {
            //1. 获取绘图上下文
            guard let context = UIGraphicsGetCurrentContext() else { return }
            //2. 获取需要进行绘制的数据
            guard let filteredSamples = filter?.filteredSamplesForSize(bounds.size) else {
                return
            }
            //3. 设置画布的缩放和上下左右间距
            context.scaleBy(x: widthScaling, y: heightScaling);
            let xOffset = bounds.size.width - (bounds.size.width * widthScaling)
            let yOffset = bounds.size.height - (bounds.size.height * heightScaling)
            context.translateBy(x: xOffset / 2, y: yOffset / 2);
            //4. 绘制
            let halfPath = CGMutablePath()
            halfPath.move(to: CGPoint(x: 0, y: rect.height))
            for i in 0..<filteredSamples.count {
                let sample = CGFloat(filteredSamples[i])
                halfPath.addLine(to: CGPoint(x: CGFloat(i), y: rect.height - sample))
            }
            halfPath.addLine(to: CGPoint(x: CGFloat(filteredSamples.count), y: rect.height))
            //5. 将完整路径添加到上下文
            context.addPath(halfPath);
            context.setFillColor(waveColor.cgColor);
            context.drawPath(using: .fill);
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = loadingView.frame.size
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0
        loadingView.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}

