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
        view.backgroundColor = UIColor.lightGray
        let _ = CLTextView().then { (textView) in
            textView.backgroundColor = UIColor.lightGray
            view.addSubview(textView)
            textView.snp.makeConstraints({ (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(100).priority(.high)
            })
            textView.updateWithConfigure({ (configure) in
                configure.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: -10)
            })
            textView.delegate = self
        }
    }
}

extension CLTextViewViewController: CLTextViewDelegate {
    func textViewBeginEditing(textView: CLTextView) {
        print("开始输入")
    }
    
//    func textViewEndEditing(textView: CLTextView) {
//        print("结束输入")
//    }
    
    func textViewDidChange(textView: CLTextView) {
        print("==========\(textView.text)")
    }
    
}

