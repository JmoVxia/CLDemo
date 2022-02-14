//
//  CLTruncationController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2022/7/15.
//

import UIKit
import SnapKit

//MARK: - JmoVxia---枚举
extension CLTruncationController {
}
//MARK: - JmoVxia---类-属性
class CLTruncationController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
    private lazy var truncationLabel: CLTruncationLabel = {
        let view = CLTruncationLabel()
        view.numberOfLines = 3
        view.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.orange.cgColor
        view.layer.borderWidth = 0.5
        view.addTarget(self, action: #selector(didClickLabelAction), for: .touchUpInside)
        return view
    }()
}
//MARK: - JmoVxia---生命周期
extension CLTruncationController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        makeConstraints()
        initData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
//MARK: - JmoVxia---布局
private extension CLTruncationController {
    func initSubViews() {
        view.addSubview(truncationLabel)
    }
    func makeConstraints() {
        truncationLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(200)
        }
    }
}
//MARK: - JmoVxia---数据
private extension CLTruncationController {
    func initData() {
        truncationLabel.attributedText = NSMutableAttributedString("时间最会骗人，但也能让你明白，这世界上是没有什么不能失去的！") { $0
            .font(.systemFont(ofSize: 14))
            .lineSpacing(5)
            .foregroundColor("#5E6582".uiColor)
            .lineBreakMode(.byWordWrapping)
        }.addText("离去的都是风景，留下的才是人生，走到最后的，才是对的人"){ $0
            .font(.systemFont(ofSize: 10))
            .lineSpacing(5)
            .foregroundColor(.red)
            .lineBreakMode(.byWordWrapping)
        }.addText("记住，要的是重新开始，并不是不从零开始，我们要带着过去所经历的困难和那些所明白的道理，继续走下去。"){ $0
            .font(.systemFont(ofSize: 18))
            .lineSpacing(5)
            .foregroundColor(.orange)
            .lineBreakMode(.byWordWrapping)
        }
        truncationLabel.truncationToken = (NSAttributedString(" ... [展开]"){ $0
            .foregroundColor("#1F70FF".uiColor)
            .font(.systemFont(ofSize: 28))
        }, NSAttributedString(" [折叠]"){ $0
            .foregroundColor("#1F70FF".uiColor)
            .font(.systemFont(ofSize: 28))
        })
        truncationLabel.reload()
    }
}
//MARK: - JmoVxia---override
extension CLTruncationController {
}
//MARK: - JmoVxia---objc
@objc private extension CLTruncationController {
    func didClickLabelAction()  {
        truncationLabel.isOpen.toggle()
        truncationLabel.reload()
    }
}
//MARK: - JmoVxia---私有方法
private extension CLTruncationController {
}
//MARK: - JmoVxia---公共方法
extension CLTruncationController {
}
