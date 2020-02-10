//
//  CLPopupController.swift
//  CLDemo
//
//  Created by JmoVxia on 2019/12/28.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit

class CLPopupFlopController: CLBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton()
        view.addSubview(button)
        button.backgroundColor = UIColor.randomColor
        button.setTitle("点我翻牌", for: .normal)
        button.addTarget(self, action: #selector(showFlop), for: .touchUpInside)
        button.snp.makeConstraints { (make) in
            make.size.equalTo(120)
            make.center.equalToSuperview()
        }
    }
    @objc func showFlop() {
        CLPopupManager.showFlop()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            CLPopupManager.showFlop(statusBarHidden: true)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            CLPopupManager.showFlop(statusBarStyle: .default, statusBarHidden: false)
        }
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6) {
//            CLPopupManager.showFlop(statusBarStyle: .default)
//        }
    }
}
