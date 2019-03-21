//
//  CLRotateAnimationSwiftController.swift
//  CLDemo
//
//  Created by AUG on 2019/3/21.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

import UIKit

class CLRotateAnimationSwiftController: CLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let roundAnimationView = CLRoundAnimationView(frame: CGRect(x: 120, y: 320, width: 90, height: 90))
        view.addSubview(roundAnimationView)
    }
}
