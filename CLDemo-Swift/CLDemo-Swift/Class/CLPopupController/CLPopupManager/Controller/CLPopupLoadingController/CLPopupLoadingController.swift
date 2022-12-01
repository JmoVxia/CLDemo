//
//  CLPopupLoadingController.swift
//  CL
//
//  Created by JmoVxia on 2020/5/18.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import Lottie

class CLPopupLoadingController: CLPopoverController {
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .init("#000000", alpha: 0.15)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    private lazy var loadingView: LottieAnimationView = {
        let view = LottieAnimationView.init(name: "loading")
        view.backgroundBehavior = .pauseAndRestore
        view.loopMode = .loop
        view.play()
        return view
    }()
}
extension CLPopupLoadingController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundView)
        backgroundView.addSubview(loadingView)
        backgroundView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(65)
        }
        loadingView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(55)
        }
    }
}
