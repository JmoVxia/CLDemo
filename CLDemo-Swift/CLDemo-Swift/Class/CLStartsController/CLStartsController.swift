//
//  CLFiveStartsController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/12/28.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLStartsController: CLController {
    lazy var startsView: CLStartsView = {
        let view = CLStartsView(frame: .zero)
        view.dataSource = self
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(startsView)
        startsView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 250, height: 50))
        }
        startsView.reloadData()
        startsView.currentScore = 0
    }
}
extension CLStartsController: CLStartsViewDataSource {
    func numberOfItems(in startsView: CLStartsView) -> Int {
        return 5
    }    
    func imageOfStartsView(startsView: CLStartsView) -> (nomal: UIImage, selected: UIImage) {
        return (UIImage(named: "evaluateBIcon")!, UIImage(named: "evaluateCIcon")!)
    }
}
