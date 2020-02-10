//
//  CLFlipView.swift
//  CLDemo
//
//  Created by JmoVxia on 2019/12/26.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit

class CLFlipView: UIView {
    ///顶部图片
    var topImage: UIImage? {
        didSet {
            self.imageView.image = topImage
        }
    }
    ///底部图片
    var bottomImage: UIImage?
    ///动画时间
    var duration = 2.0
    ///动画次数
    var repeatCount = Int64.max
    ///动画执行次数
    private var animationStopCount: Int = 0
    ///是否是顶层
    private var isTopImage: Bool = true
    ///是否停止
    private var isStop: Bool = true
    ///是否暂停
    private var isPause: Bool = false

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = topImage
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        addSubview(imageView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    deinit {
        print("+++++++++ CLFlipView deinit ++++++++++++")
    }
}
extension CLFlipView {
    private func flipAnimation() {
        let keyAnimation = CAKeyframeAnimation()
        keyAnimation.values = [NSValue(caTransform3D: CATransform3DMakeRotation(0, 0, 1, 0)), NSValue(caTransform3D: CATransform3DMakeRotation(.pi / 2, 0, 1, 0)), NSValue(caTransform3D: CATransform3DMakeRotation(0, 0, 1, 0))]
        keyAnimation.isCumulative = false
        keyAnimation.duration = duration
        keyAnimation.repeatCount = 1
        keyAnimation.delegate = self
        keyAnimation.isRemovedOnCompletion = false
        layer.add(keyAnimation, forKey: "transform")
        perform(#selector(changeImage), with: nil, afterDelay: duration * 0.5)
    }
    @objc private func changeImage() {
        if isStop || isPause {
            return
        }
        isTopImage = !isTopImage
        imageView.image = isTopImage ? topImage : bottomImage
    }
}
extension CLFlipView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if isStop {
            return
        }
        animationStopCount = animationStopCount + 1
        if animationStopCount < repeatCount {
            flipAnimation()
        }else {
            stopAnimation()
        }
    }
}
extension CLFlipView {
    ///开始动画
    func startAnimation() -> Void {
        if !isStop {
            return
        }
        isStop = false
        flipAnimation()
    }
    ///停止动画
    func stopAnimation() -> Void {
        if isStop {
            return
        }
        isStop = true
        layer.removeAllAnimations()
        resumeAnimation()
    }
    ///暂停动画
    func pauseAnimation() {
        if isPause {
            return
        }
        isPause = true
        //取出当前时间,转成动画暂停的时间
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        //设置动画运行速度为0
        layer.speed = 0.0;
        //设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
        layer.timeOffset = pausedTime
    }
    ///恢复动画
    func resumeAnimation() {
        if !isPause {
            return
        }
        isPause = false
        //获取暂停的时间差
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        //用现在的时间减去时间差,就是之前暂停的时间,从之前暂停的时间开始动画
        let timeSincePause = imageView.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
}
