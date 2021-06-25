//
//  CLFlipController.swift
//  CLDemo
//
//  Created by JmoVxia on 2019/12/26.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit
import SnapKit

class CLFlipController: CLController {
    lazy var twoSidedView: CLTwoSidedView = {
        let view = CLTwoSidedView()
        view.topView = UIImageView.init(image: UIImage.init(named: "qq"))
        view.bottomView = UIImageView.init(image: UIImage.init(named: "微信"))
        return view
    }()
    lazy var flipView: CLFlipView = {
        let view = CLFlipView()
        view.topImage = UIImage.init(named: "qq")
        view.bottomImage = UIImage.init(named: "微信")
        return view
    }()
    lazy var startButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.randomColor
        view.setTitle("开始动画", for: .normal)
        view.setTitle("开始动画", for: .selected)
        view.setTitle("开始动画", for: .highlighted)
        view.addTarget(self, action: #selector(startAnimation), for: .touchUpInside)
        return view
    }()
    lazy var stopButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.randomColor
        view.setTitle("停止动画", for: .normal)
        view.setTitle("停止动画", for: .selected)
        view.setTitle("停止动画", for: .highlighted)
        view.addTarget(self, action: #selector(stopAnimation), for: .touchUpInside)
        return view
    }()
    lazy var pauseButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.randomColor
        view.setTitle("暂停动画", for: .normal)
        view.setTitle("暂停动画", for: .selected)
        view.setTitle("暂停动画", for: .highlighted)
        view.addTarget(self, action: #selector(pauseAnimation), for: .touchUpInside)
        return view
    }()
    lazy var resumeButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.randomColor
        view.setTitle("恢复动画", for: .normal)
        view.setTitle("恢复动画", for: .selected)
        view.setTitle("恢复动画", for: .highlighted)
        view.addTarget(self, action: #selector(resumeAnimation), for: .touchUpInside)
        return view
    }()
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
        print("=========== CLFlipController deinit ============")
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
