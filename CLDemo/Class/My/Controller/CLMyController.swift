//
//  CLMyController.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/5/2.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLMyController: CLBaseViewController {
    lazy var titleView: CLTitleControllerView = {
        let view: CLTitleControllerView = CLTitleControllerView(frame: CGRect(x: 0, y: cl_safeAreaInsets().top + cl_statusBarHeight(), width: self.view.bounds.width, height: self.view.bounds.height - cl_safeAreaInsets().top - cl_statusBarHeight() - (self.tabBarController?.tabBar.bounds.height ?? 0.0)), dataSource: self)
        return view
    }()

}
extension CLMyController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
    }
}
extension CLMyController {
    private func initUI() {
        view.addSubview(titleView)
    }
    private func makeConstraints() {

    }
}
extension CLMyController: CLTitleControllerViewDataSource {
    func titleControllerView(controllerClassAt index: Int) -> (class: UIViewController.Type, fatherController: UIViewController) {
        return (CLMyDetailsController.self, self)
    }
    
    func titleControllerViewTitles() -> [String] {
        return ["推荐", "学习", "精华", "音频", "视频", "福利", "语音", "社会", "世界", "小说", "修仙", "种田"]
    }
    
    func titleControllerViewFont() -> UIFont {
        return UIFont.systemFont(ofSize: 16)
    }
    
    func titleControllerView(titleColorAt index: Int) -> (nomal: UIColor, seleted: UIColor) {
        return (UIColor.orange, UIColor.red)
    }
}
