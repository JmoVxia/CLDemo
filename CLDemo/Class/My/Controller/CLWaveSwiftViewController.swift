//
//  CLWaveSwiftViewController.swift
//  CLDemo
//
//  Created by AUG on 2019/3/18.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

import UIKit

class CLWaveSwiftViewController: CLBaseViewController {

    var waveView: CLWaveView!
    override func viewDidLoad() {
        super.viewDidLoad()
        waveView = CLWaveView(frame: CGRect(x: 0, y: 99, width: view.frame.size.width, height: 90))
        waveView.alpha = 0.6
        waveView.updateWithConfig(configure: { (configure) in
            configure.color = UIColor.orange;
            configure.y = 40;
            configure.speed = 0.05;
        })
        view.addSubview(waveView)
    }
    
    deinit {
       waveView.invalidate()
    }
}
