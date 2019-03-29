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
        
        do {
            let rotateAnimationView: CLRotateAnimationView = CLRotateAnimationView(frame: CGRect(x: 120, y: 120, width: 80, height: 80));
            rotateAnimationView.updateWithConfigure { (configure) -> (Void) in
                configure.backgroundColor = UIColor.orange;
                configure.number = 8;
                configure.duration = 4;
                configure.intervalDuration = 0.2;
            }
            rotateAnimationView.startAnimation()
            self.view.addSubview(rotateAnimationView)
        }

        do {
            let roundAnimationView = CLRoundAnimationView(frame: CGRect(x: 120, y: 250, width: 90, height: 90))
            roundAnimationView.updateWithConfigure { (configure) -> (Void) in
                configure.outBackgroundColor = UIColor(red:1.00, green:0.00, blue:0.01, alpha:0.60)
                configure.inBackgroundColor = UIColor(red:0.28, green:0.54, blue:0.96, alpha:1.00)
                configure.duration = 1
                configure.strokeStart = 0
                configure.strokeEnd = 0.25
                configure.inLineWidth = 5
                configure.outLineWidth = 15
                configure.position = .animationMiddle
            }
            view.addSubview(roundAnimationView)
            roundAnimationView.startAnimation()
        }

        do {
            let roundAnimationView = CLRoundAnimationView(frame: CGRect(x: 150, y: 420, width: 90, height: 90))
            roundAnimationView.updateWithConfigure { (configure) -> (Void) in
                configure.outBackgroundColor = UIColor.clear
                configure.inBackgroundColor = UIColor(red:0.28, green:0.54, blue:0.96, alpha:1.00)
                configure.duration = 1
                configure.strokeStart = 0
                configure.strokeEnd = 0.6
                configure.inLineWidth = 5
                configure.outLineWidth = 5
                configure.position = .animationMiddle
            }
            view.addSubview(roundAnimationView)
            roundAnimationView.startAnimation()
        }
        
        do {
            let imageView: CLRotateImageView = CLRotateImageView(frame: CGRect(x: 280, y: 300, width: 60, height: 60), superview: view)
            imageView.showAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                imageView.hiddenAnimating()
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
                imageView.showAnimating()
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 7) {
                imageView.hiddenAnimating()
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 9) {
                imageView.showAnimating()
            }
        }
    }
}
