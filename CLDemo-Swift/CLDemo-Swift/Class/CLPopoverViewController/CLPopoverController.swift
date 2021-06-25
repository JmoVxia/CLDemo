//
//  CLPopoverController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/12/7.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLPopoverController: CLController {
    @IBAction func top(_ sender: UIButton) {
        let pop = CLPopoverView { (configure) in
            configure.arrowDirection = .top
            configure.maskBackgroundColor = UIColor.red.withAlphaComponent(0.4)
        }
        let contentView = UIView.init(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        pop.show(contentView, fromView: sender)
    }
    @IBAction func left(_ sender: UIButton) {
        let pop = CLPopoverView { (configure) in
            configure.arrowDirection = .left
            configure.arrowPositionRatio = 0.2
        }
        let contentView = UIView.init(frame: CGRect(x: 0, y: 0, width: 100, height: 300))
        pop.show(contentView, fromView: sender)
    }
    @IBAction func bottom(_ sender: UIButton) {
        let pop = CLPopoverView { (configure) in
            configure.arrowDirection = .bottom
            configure.maskBackgroundColor = UIColor.orange.withAlphaComponent(0.2)
            configure.popoverColor = UIColor.green.withAlphaComponent(0.4)
        }
        let contentView = UIView.init(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        pop.show(contentView, fromView: sender)
    }
    @IBAction func right(_ sender: UIButton) {
        let pop = CLPopoverView { (configure) in
            configure.arrowDirection = .right
            configure.arrowPositionRatio = 0.1
        }
        let contentView = UIView.init(frame: CGRect(x: 0, y: 0, width: 100, height: 300))
        pop.show(contentView, fromView: sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        button.setTitleColor(.black, for: .normal)
        button.setTitle("点我", for: .normal)
        button.addTarget(self, action: #selector(rightItem(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    @objc func rightItem(_ buton: UIButton) {
        let pop = CLPopoverView { (configure) in
            configure.arrowDirection = .bottom
            configure.arrowPositionRatio = 0.1
            configure.highlightFromView = true
            configure.arrowPositionRatio = 0.8
            configure.sideEdge = 10
        }
        let contentView = UIView.init(frame: CGRect(x: 0, y: 0, width: 100, height: 300))
        pop.show(contentView, fromView: buton)
    }
}
