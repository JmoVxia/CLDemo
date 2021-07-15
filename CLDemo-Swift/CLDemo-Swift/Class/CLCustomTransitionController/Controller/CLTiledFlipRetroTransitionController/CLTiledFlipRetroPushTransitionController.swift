//
//  CLTiledFlipRetroPushTransitionController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/16.
//

import UIKit
import SnapKit

//MARK: - JmoVxia---枚举
extension CLTiledFlipRetroPushTransitionController {
}
//MARK: - JmoVxia---类-属性
class CLTiledFlipRetroPushTransitionController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "1")
        return view
    }()
}
//MARK: - JmoVxia---生命周期
extension CLTiledFlipRetroPushTransitionController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
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
private extension CLTiledFlipRetroPushTransitionController {
    func initUI() {
        view.addSubview(imageView)
    }
    func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

