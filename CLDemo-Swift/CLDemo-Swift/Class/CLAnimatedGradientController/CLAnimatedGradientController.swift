//
//  CLAnimatedGradientController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/2/8.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit
import SnapKit


//MARK: - JmoVxia---类-属性
class CLAnimatedGradientController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
    let color1: CGColor = UIColor(red: 209/255, green: 107/255, blue: 165/255, alpha: 1).cgColor
    let color2: CGColor = UIColor(red: 134/255, green: 168/255, blue: 231/255, alpha: 1).cgColor
    let color3: CGColor = UIColor(red: 95/255, green: 251/255, blue: 241/255, alpha: 1).cgColor
    
    let gradient: CAGradientLayer = CAGradientLayer()
    var gradientColorSet: [[CGColor]] = []
    var colorIndex: Int = 0
}
//MARK: - JmoVxia---生命周期
extension CLAnimatedGradientController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "动画渐变"
        setupGradient()
        animateGradient()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
extension CLAnimatedGradientController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            animateGradient()
        }
    }
}
private extension CLAnimatedGradientController {
    func setupGradient(){
        gradientColorSet = [
            [color1, color2],
            [color2, color3],
            [color3, color1]
        ]
        
        gradient.frame = self.view.bounds
        gradient.colors = gradientColorSet[colorIndex]
        
        self.view.layer.addSublayer(gradient)
    }

    func animateGradient() {
        gradient.colors = gradientColorSet[colorIndex]
        
        let gradientAnimation = CABasicAnimation(keyPath: "colors")
        gradientAnimation.delegate = self
        gradientAnimation.duration = 3.0
        
        updateColorIndex()
        gradientAnimation.toValue = gradientColorSet[colorIndex]
        
        gradientAnimation.fillMode = .forwards
        gradientAnimation.isRemovedOnCompletion = false
        
        gradient.add(gradientAnimation, forKey: "colors")
    }
    
    func updateColorIndex(){
        if colorIndex < gradientColorSet.count - 1 {
            colorIndex += 1
        } else {
            colorIndex = 0
        }
    }
}
//MARK: - JmoVxia---私有方法
private extension CLAnimatedGradientController {
}
//MARK: - JmoVxia---公共方法
extension CLAnimatedGradientController {
}
