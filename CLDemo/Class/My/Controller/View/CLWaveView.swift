//
//  CLWaveView.swift
//  CLDemo
//
//  Created by AUG on 2019/3/18.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

import UIKit

class CLWaveViewConfigure: NSObject {
    ///波浪颜色
    var color: UIColor = UIColor.white
    ///水纹振幅
    var amplitude: CGFloat = 12
    ///水纹周期
    var cycle: CGFloat = 0.5 / 30.0
    ///波浪Y
    var y: CGFloat = 0
    ///水纹速度
    var speed: CGFloat = 0.05
    ///水纹宽度
    var width: CGFloat = 0
    ///上升速度
    var upSpeed: CGFloat = 0
    
    ///默认配置
    fileprivate class func defaultConfigure() -> CLWaveViewConfigure {
        let configure = CLWaveViewConfigure()
        configure.y = configure.amplitude
        return configure
    }
}

class CLWaveView: UIView {
    
    private let configure = CLWaveViewConfigure.defaultConfigure()
    private let shapeLayer: CAShapeLayer = CAShapeLayer()
    private var displayLink: CADisplayLink?
    private var offsetX: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        layer.masksToBounds = true
        initUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func initUI() {
        displayLink = CADisplayLink(target: self, selector: #selector(currentWave))
        shapeLayer.fillColor = configure.color.cgColor
        layer.addSublayer(shapeLayer)
        //启动定时器
        displayLink?.add(to: RunLoop.current, forMode: .common)
    }
    @objc private func currentWave() {
        if configure.amplitude == 0 && configure.y == 0 && configure.upSpeed != 0 {
            invalidate()
        }else {
            offsetX = offsetX + configure.speed
            configure.y = max(configure.y - configure.upSpeed, 0)
            if (configure.y < configure.amplitude) {
                configure.amplitude = configure.y;
            }
            currentFirstWaveLayerPath()
        }
    }
    private func currentFirstWaveLayerPath() {
        //创建一个路径
        let path: CGMutablePath = CGMutablePath()
        var y: CGFloat = configure.y
        path.move(to: CGPoint.init(x: 0, y: y))
        for i in 0...Int(configure.width) {
            y = configure.amplitude * sin(configure.cycle * CGFloat(i) + CGFloat(offsetX)) + configure.y
            //将点连成线
            path.addLine(to: CGPoint(x: CGFloat(i), y: y), transform: .identity)
        }
        path.addLine(to: CGPoint.init(x: configure.width, y: frame.size.height))
        path.addLine(to: CGPoint.init(x: 0, y: frame.size.height))
        path.closeSubpath()
        shapeLayer.path = path
    }
    ///更新基本配置，block不会造成循环引用
    func updateWithConfigure(_ configureBlock: ((CLWaveViewConfigure) -> Void)?) {
        configure.width = frame.size.width
        configureBlock?(configure);
        shapeLayer.fillColor = configure.color.cgColor;
    }
    ///销毁
    func invalidate() {
        displayLink?.invalidate()
    }
}
