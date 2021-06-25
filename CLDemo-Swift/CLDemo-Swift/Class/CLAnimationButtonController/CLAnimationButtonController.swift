//
//  CLAnimationButtonController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/3/17.
//  Copyright © 2021 JmoVxia. All rights reserved.
//  https://github.com/okmr-d/DOFavoriteButton

import UIKit
import SnapKit

class CLAnimationButtonController: CLController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let starButton = CLAnimationButton(frame: CGRect(x: (view.bounds.maxX - 40) * 0.5, y: 250, width: 40, height: 40), image: UIImage(named: "star")!)
        starButton.isSelected = true
        starButton.addTarget(self, action: #selector(tappedButtonAction), for: .touchUpInside)
        view.addSubview(starButton)

        let likeButton = CLAnimationButton(frame: .zero, image: UIImage(named: "like")!)
        likeButton.addTarget(self, action: #selector(tappedButtonAction), for: .touchUpInside)
        view.addSubview(likeButton)
        likeButton.snp.makeConstraints { (make) in
            make.size.equalTo(40)
            make.center.equalToSuperview()
        }
        let smileButton = CLAnimationButton(frame: .zero, image: UIImage(named: "smile")!)
        smileButton.addTarget(self, action: #selector(tappedButtonAction), for: .touchUpInside)
        view.addSubview(smileButton)
        smileButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(40)
            make.top.equalTo(likeButton.snp.bottom).offset(40)
        }
        let heartButton = CLAnimationButton(frame: .zero, image: UIImage(named: "heart")!)
        heartButton.addTarget(self, action: #selector(tappedButtonAction), for: .touchUpInside)
        view.addSubview(heartButton)
        heartButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(40)
            make.bottom.equalTo(likeButton.snp.top).offset(-40)
        }
    }
    @objc func tappedButtonAction(button: CLAnimationButton) {
        button.isSelected ? button.deselect() : button.select()
    }
}
