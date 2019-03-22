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
    
    private let defaultConfigure = CLWaveViewConfigure.defaultConfigure()
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
    func initUI() {
        displayLink = CADisplayLink(target: self, selector: #selector(currentWave))
        shapeLayer.fillColor = defaultConfigure.color.cgColor
        layer.addSublayer(shapeLayer)
        //启动定时器
        displayLink?.add(to: RunLoop.main, forMode: .common)
    }
    @objc func currentWave() {
        offsetX = offsetX + defaultConfigure.speed
        defaultConfigure.y = max(defaultConfigure.y - defaultConfigure.upSpeed, defaultConfigure.amplitude)
        currentFirstWaveLayerPath()
    }
    func currentFirstWaveLayerPath() {
        //创建一个路径
        let path: CGMutablePath = CGMutablePath()
        var y: CGFloat = defaultConfigure.y
        path.move(to: CGPoint.init(x: 0, y: y))
        for i in 0...Int(defaultConfigure.width) {
            y = defaultConfigure.amplitude * sin(defaultConfigure.cycle * CGFloat(i) + CGFloat(offsetX)) + defaultConfigure.y
            //将点连成线
            path.addLine(to: CGPoint(x: CGFloat(i), y: y), transform: .identity)
        }
        path.addLine(to: CGPoint.init(x: defaultConfigure.width, y: frame.size.height))
        path.addLine(to: CGPoint.init(x: 0, y: frame.size.height))
        path.closeSubpath()
        shapeLayer.path = path
    }
    ///更新基本配置，block不会造成循环引用
    func updateWithConfig(configure: ((CLWaveViewConfigure) -> Void)?) {
        defaultConfigure.width = frame.size.width
        configure?(defaultConfigure);
        shapeLayer.fillColor = defaultConfigure.color.cgColor;
    }
    ///销毁
    func invalidate() {
        displayLink?.invalidate()
    }
}
