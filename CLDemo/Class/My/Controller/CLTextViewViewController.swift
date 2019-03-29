//
//  CLTextViewViewController.swift
//  CLDemo
//
//  Created by AUG on 2019/3/28.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit
import Then
import SnapKit

class CLTextViewViewController: CLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let _ = CLTextView().then { (textView) in
            textView.backgroundColor = UIColor.lightGray
            view.addSubview(textView)
            textView.snp.makeConstraints({ (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(100)
            })
        }
    }
}
