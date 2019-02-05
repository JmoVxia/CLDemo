//
//  CLPasswordViewSwiftController.swift
//  CLDemo
//
//  Created by AUG on 2019/2/5.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

import UIKit
import SnapKit

class CLPasswordViewSwiftController: CLBaseViewController {
    
    var label1: UILabel!
    var label2: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        label1 = UILabel().then { (label) in
            view.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(30)
                make.centerX.equalToSuperview()
            })
        }
        label2 = UILabel().then { (label) in
            view.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.top.equalTo(label1.snp.bottom).offset(30)
                make.centerX.equalToSuperview()
            })
        }
        let inputView = CLPasswordInputView().then { (inputView) in
            view.addSubview(inputView)
            inputView.delegate = self
            inputView.snp.makeConstraints({ (make) in
                make.left.centerY.right.equalToSuperview()
                make.height.equalTo(50)
            })
        }
        inputView.updateWithConfig { (configure) in
            configure.backgroundColor = UIColor.lightGray
            configure.rectBackgroundColor = UIColor.gray
            configure.rectColor = UIColor.purple
            configure.pointColor = UIColor.red
            configure.spaceMultiple = 1000
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension CLPasswordViewSwiftController: CLPasswordInputViewDelegate {
    ///输入改变
    func passwordInputViewDidChange(passwordInputView:CLPasswordInputView) -> Void {
        label1.text = passwordInputView.text as String
        label2.text = "正在输入";
    }
    ///点击删除
    func passwordInputViewDidDeleteBackward(passwordInputView:CLPasswordInputView) -> Void {
        label2.text = "点击删除";
    }
    ///输入完成
    func passwordInputViewCompleteInput(passwordInputView:CLPasswordInputView) -> Void {
        label2.text = "输入完毕";
    }
    ///开始输入
    func passwordInputViewBeginInput(passwordInputView:CLPasswordInputView) -> Void {
        label2.text = "开始输入"
    }
    ///结束输入
    func passwordInputViewEndInput(passwordInputView:CLPasswordInputView) -> Void {
        label2.text = "结束输入"
    }
}
