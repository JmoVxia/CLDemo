//
//  CLWaveSwiftViewController.swift
//  CLDemo
//
//  Created by AUG on 2019/3/18.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

import UIKit

class CLWaveController: CLController {

    var waveView: CLWaveView!
    override func viewDidLoad() {
        super.viewDidLoad()
        waveView = CLWaveView(frame: CGRect(x: 0, y: 99, width: view.frame.size.width, height: 150))
        waveView.alpha = 0.6
        waveView.updateWithConfigure({ (configure) in
            configure.color = UIColor.orange;
            configure.y = 120
            configure.speed = 0.05
            configure.upSpeed = 0.1
        })
        view.addSubview(waveView)
    }
    
    deinit {
       waveView.invalidate()
    }
}
