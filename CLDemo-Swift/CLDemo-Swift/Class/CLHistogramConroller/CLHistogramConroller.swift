//
//  CLHistogramConroller.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/12/8.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLHistogramConroller: CLController {
    private lazy var histogramView: CLHistogramView = {
        let view = CLHistogramView()
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(histogramView)
        histogramView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(view)
        }
    }
}
