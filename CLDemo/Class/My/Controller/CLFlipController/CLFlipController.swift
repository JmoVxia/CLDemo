//
//  CLFlipController.swift
//  CLDemo
//
//  Created by JmoVxia on 2019/12/26.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit
import SnapKit

class CLFlipController: CLBaseViewController {
    var twoSidedView: CLTwoSidedView = CLTwoSidedView().then { (twoSidedView) in
        twoSidedView.topView = UIImageView.init(image: UIImage.init(named: "qq"))
        twoSidedView.bottomView = UIImageView.init(image: UIImage.init(named: "微信"))
    }
    
    var flipView: CLFlipView = CLFlipView().then { (flipView) in
        flipView.topImage = UIImage.init(named: "qq")
        flipView.bottomImage = UIImage.init(named: "微信")
    }
    var startButton: UIButton = UIButton().then { (startButton) in
        startButton.backgroundColor = UIColor.randomColor
        startButton.setTitle("开始动画", for: .normal)
        startButton.setTitle("开始动画", for: .selected)
        startButton.setTitle("开始动画", for: .highlighted)
        startButton.addTarget(self, action: #selector(startAnimation), for: .touchUpInside)
    }
    var stopButton: UIButton = UIButton().then { (stopButton) in
        stopButton.backgroundColor = UIColor.randomColor
        stopButton.setTitle("停止动画", for: .normal)
        stopButton.setTitle("停止动画", for: .selected)
        stopButton.setTitle("停止动画", for: .highlighted)
        stopButton.addTarget(self, action: #selector(stopAnimation), for: .touchUpInside)
    }
    var pauseButton: UIButton = UIButton().then { (pauseButton) in
        pauseButton.backgroundColor = UIColor.randomColor
        pauseButton.setTitle("暂停动画", for: .normal)
        pauseButton.setTitle("暂停动画", for: .selected)
        pauseButton.setTitle("暂停动画", for: .highlighted)
        pauseButton.addTarget(self, action: #selector(pauseAnimation), for: .touchUpInside)
    }
    var resumeButton: UIButton = UIButton().then { (resumeButton) in
        resumeButton.backgroundColor = UIColor.randomColor
        resumeButton.setTitle("恢复动画", for: .normal)
        resumeButton.setTitle("恢复动画", for: .selected)
        resumeButton.setTitle("恢复动画", for: .highlighted)
        resumeButton.addTarget(self, action: #selector(resumeAnimation), for: .touchUpInside)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(twoSidedView)
        
        view.addSubview(flipView)
        view.addSubview(startButton)
        view.addSubview(stopButton)
        view.addSubview(pauseButton)
        view.addSubview(resumeButton)
        
        twoSidedView.snp.makeConstraints { (make) in
            make.size.equalTo(90)
            make.centerX.equalToSuperview()
            make.top.equalTo(flipView.snp.bottom).offset(20)
        }
        
        flipView.snp.makeConstraints { (make) in
            make.size.equalTo(90)
            make.center.equalToSuperview()
        }
        startButton.snp.makeConstraints { (make) in
            make.size.equalTo(90)
            make.left.equalTo(20)
            make.bottom.equalTo(flipView.snp.top).offset(-20)
        }
        stopButton.snp.makeConstraints { (make) in
            make.size.equalTo(90)
            make.right.equalTo(-20)
            make.bottom.equalTo(flipView.snp.top).offset(-20)
        }
        pauseButton.snp.makeConstraints { (make) in
            make.size.equalTo(90)
            make.left.equalTo(20)
            make.top.equalTo(flipView.snp.bottom).offset(-20)
        }
        resumeButton.snp.makeConstraints { (make) in
            make.size.equalTo(90)
            make.right.equalTo(-20)
            make.top.equalTo(flipView.snp.bottom).offset(-20)
        }
    }
    deinit {
        flipView.stopAnimation()
        print("=======================")
    }
}
extension CLFlipController {
    @objc func startAnimation() {
        flipView.startAnimation()
        twoSidedView.transition(withDuration: 2, completion: nil)
    }
    @objc func stopAnimation() {
        flipView.stopAnimation()
    }
    @objc func resumeAnimation() {
        flipView.resumeAnimation()
    }
    @objc func pauseAnimation() {
        flipView.pauseAnimation()
    }
}
