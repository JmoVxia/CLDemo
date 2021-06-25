//
//  CLDrawMarqueeView.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/11/9.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import SnapKit

protocol CLDrawMarqueeViewDelegate: NSObject {
    func drawMarqueeView(view: CLDrawMarqueeView, index: Int, animationDidStopFinished finished: Bool)
}
extension CLDrawMarqueeViewDelegate {
    func drawMarqueeView(view: CLDrawMarqueeView, index: Int, animationDidStopFinished finished: Bool) {
        
    }
}

//MARK: - JmoVxia---枚举
extension CLDrawMarqueeView {
    enum Direction {
        case left
        case right
    }
}
//MARK: - JmoVxia---类-属性
class CLDrawMarqueeView: UIView {
    weak var delegate: CLDrawMarqueeViewDelegate?
    private (set) var speed: CGFloat = 2
    private (set) var direction: Direction = .left
    private (set) var index: Int = 0
    private (set) var isPaused: Bool = false
    private var stoped: Bool = false
    private var isFrist: Bool = true
    private var animationViewWidth: CGFloat {
        return label.bounds.width
    }
    private var animationViewHeight: CGFloat {
        return label.bounds.height
    }
    private lazy var label: UILabel = {
        let view = UILabel()
        return view
    }()
    init(speed: CGFloat = 2.0, direction: Direction = .left) {
        super.init(frame: .zero)
        self.speed = speed
        self.direction = direction
        initUI()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        CLLog("CLDrawMarqueeView deinit")
    }
}
//MARK: - JmoVxia---布局
private extension CLDrawMarqueeView {
    func initUI() {
        layer.masksToBounds = true
        addSubview(label)
        NotificationCenter.default.addObserver(self, selector: #selector(applictionDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    func makeConstraints() {
        label.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            if direction == .left {
                make.left.equalToSuperview()
            }else {
                make.right.equalToSuperview()
            }
        }
    }
}
//MARK: - JmoVxia---公共方法
extension CLDrawMarqueeView {
    func setText(_ text: String) {
        label.text = text
        label.sizeToFit()
        setNeedsLayout()
        layoutIfNeeded()
    }
    func startAnimation() {
        label.layer.removeAnimation(forKey: "animationViewPosition")
        stoped = false
        let pointRightCenter = CGPoint(x: ((isFrist && direction == .left) ? 0 : bounds.width) + animationViewWidth * 0.5, y: animationViewHeight * 0.5)
        let pointLeftCenter = CGPoint(x: -animationViewWidth * 0.5 + ((isFrist && direction == .right) ? bounds.width : 0), y: animationViewHeight * 0.5)
        let fromPoint = direction == .left ? pointRightCenter : pointLeftCenter
        let toPoint = direction == .left ? pointLeftCenter  : pointRightCenter
        
        label.center = fromPoint
        
        let movePath = UIBezierPath()
        movePath.move(to: fromPoint)
        movePath.addLine(to: toPoint)
        
        let moveAnimation = CAKeyframeAnimation(keyPath: "position")
        moveAnimation.path = movePath.cgPath
        moveAnimation.isRemovedOnCompletion = false
        moveAnimation.timingFunctions = [CAMediaTimingFunction(name: .linear)]
        moveAnimation.duration = CFTimeInterval(animationViewWidth / 30 * (1 / speed))
        moveAnimation.delegate = self
        label.layer.add(moveAnimation, forKey: "animationViewPosition")
        isFrist = false
    }
    func stopAnimation() {
        stoped = true
        label.layer.removeAnimation(forKey: "animationViewPosition")
    }
    ///暂停动画
    func pauseAnimation() {
        if isPaused || stoped {
            return
        }
        isPaused = true
        let pausedTime = label.layer.convertTime(CACurrentMediaTime(), from: nil)
        label.layer.speed = 0.0;
        label.layer.timeOffset = pausedTime
    }
    ///恢复动画
    func resumeAnimation() {
        if !isPaused || stoped {
            return
        }
        isPaused = false
        let pausedTime = label.layer.timeOffset
        label.layer.speed = 1.0
        label.layer.timeOffset = 0.0
        label.layer.beginTime = 0.0
        let timeSincePause = label.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        label.layer.beginTime = timeSincePause
    }
}
@objc private extension CLDrawMarqueeView {
    func applictionDidBecomeActive() {
        resumeAnimation()
    }
    func applicationWillResignActive() {
        pauseAnimation()
    }
}
extension CLDrawMarqueeView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        index += 1
        delegate?.drawMarqueeView(view: self, index: index, animationDidStopFinished: flag)
        if (flag && !stoped) {
            startAnimation()
        }
    }
}
