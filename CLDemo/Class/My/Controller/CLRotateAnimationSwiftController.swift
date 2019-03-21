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
        roundAnimationView.updateWithConfigure { (configure) -> (Void) in
            configure.outBackgroundColor = UIColor.lightGray;
            configure.inBackgroundColor = UIColor.orange;
            configure.duration = 1;
            configure.strokeStart = 0;
            configure.strokeEnd = 0.2;
            configure.inLineWidth = 5;
            configure.outLineWidth = 5;
        }
        view.addSubview(roundAnimationView)
        roundAnimationView.startAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            roundAnimationView.pauseAnimation()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            roundAnimationView.resumeAnimation()
        }
    }
}
