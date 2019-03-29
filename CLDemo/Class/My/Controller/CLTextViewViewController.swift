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

    lazy var textView: CLTextView = {
        let textView = CLTextView(frame: CGRect(x: 0, y: 120, width: view.frame.width, height: 0)).then { (textView) in
            textView.updateWithConfigure({ (configure) in
                configure.statistics = .count
                configure.edgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: -10, right: -15)
            })
            textView.delegate = self
        }
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.95, alpha:1.00)
//        let _ = CLTextView().then { (textView) in
//            view.addSubview(textView)
//            textView.snp.makeConstraints({ (make) in
//                if #available(iOS 11.0, *) {
//                    make.left.right.equalTo(view.safeAreaLayoutGuide)
//                } else {
//                    make.left.right.equalTo(0)
//                }
//                make.top.equalTo(120).priority(.high)
//            })
//            textView.updateWithConfigure({ (configure) in
//                configure.statistics = .count
//                configure.edgeInsets = UIEdgeInsets(top: 30, left: 10, bottom: -30, right: -10)
//            })
//            textView.delegate = self
//        }
        view.addSubview(textView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.frame = CGRect(x: 0, y: 120, width: view.frame.width, height: 0)
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

