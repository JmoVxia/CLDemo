//
//  CLTextViewViewController.swift
//  CLDemo
//
//  Created by AUG on 2019/3/28.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit

class CLTextViewViewController: CLController {
    //MARK:JmoVxia---autolayout
    lazy var textView: CLTextView = {
        let textView = CLTextView()
        view.addSubview(textView)
        textView.snp.makeConstraints({ (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            if #available(iOS 11.0, *) {
                make.left.right.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.left.right.equalTo(0)
            }
        })
        textView.updateWithConfigure({ (configure) in
            configure.statistics = .bytesLength
            configure.showLengthLabel = true
            configure.maxBytesLength = 2000
            configure.maxCount = NSIntegerMax
            configure.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: -10)
        })
        return textView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.95, alpha:1.00)
    }
}

extension CLTextViewViewController: CLTextViewDelegate {
    func textViewBeginEditing(textView: CLTextView) {
        print("开始输入")
    }
    
    func textViewEndEditing(textView: CLTextView) {
        print("结束输入")
    }
    
    func textViewDidChange(textView: CLTextView) {
        print("==========\(textView.text)")
    }
    
}

