//
//  CLPopupLoadingController.swift
//  CL
//
//  Created by JmoVxia on 2020/5/18.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import Lottie
import UIKit

class CLPopoverLoadingController: CLPopoverController {
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor("#000000", alpha: 0.15)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()

    private lazy var loadingView: LottieAnimationView = {
        let view = LottieAnimationView(name: "loading")
        view.backgroundBehavior = .pauseAndRestore
        view.loopMode = .loop
        view.play()
        return view
    }()
}

extension CLPopoverLoadingController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundView)
        backgroundView.addSubview(loadingView)
        backgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(65)
        }
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(55)
        }
    }
}

extension CLPopoverLoadingController {
    override func showAnimation(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = 1.0
        } completion: { _ in
            completion?()
        }
    }

    override func dismissAnimation(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = 0.0
        } completion: { _ in
            completion?()
        }
    }
}
