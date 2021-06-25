//
//  CLTransitionViewController.swift
//  CLDemo
//
//  Created by AUG on 2019/7/13.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit

class CLTransitionViewController: CLController {

    var isPush:Bool = true
    lazy var button: UIButton = {
        let button:UIButton = UIButton()
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(push), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.height.equalTo(80)
        }
    }
    
    @objc func push() {
        guard let navigationController = navigationController else {
            return
        }
        if isPush {
            let controller = CLTransitionViewController()
            controller.isPush = false
            controller.view.backgroundColor = UIColor.yellow
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .push
            transition.subtype = .fromBottom
            transition.timingFunction = CAMediaTimingFunction.init(name: .easeIn)
            navigationController.view.layer.add(transition, forKey: kCATransition)
            navigationController.pushViewController(controller, animated: false)
        }else {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .reveal
            transition.subtype = .fromTop
            transition.timingFunction = CAMediaTimingFunction.init(name: .easeIn)
            navigationController.view.layer.add(transition, forKey: kCATransition)
            navigationController.popViewController(animated: false)
        }
    }
}
