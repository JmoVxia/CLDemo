//
//  CLQRController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2024/3/28.
//

import UIKit

// MARK: - JmoVxia---类-属性

class CLQRController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {}

    private lazy var qrImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
}

// MARK: - JmoVxia---生命周期

extension CLQRController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        makeConstraints()
        configData()
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

// MARK: - JmoVxia---布局

private extension CLQRController {
    func setupUI() {
        view.addSubview(qrImageView)
    }

    func makeConstraints() {
        qrImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.center.equalToSuperview()
            make.width.equalTo(qrImageView.snp.height)
        }
    }
}

// MARK: - JmoVxia---数据

private extension CLQRController {
    func configData() {
        DispatchQueue.global().async {
            let image = CLQRCode(content: nanosecondStampString + dateRandomString).generate()
            DispatchQueue.main.async {
                self.qrImageView.image = image
            }
        }
    }
}

// MARK: - JmoVxia---override

extension CLQRController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        configData()
    }
}

// MARK: - JmoVxia---objc

@objc private extension CLQRController {}

// MARK: - JmoVxia---私有方法

private extension CLQRController {}

// MARK: - JmoVxia---公共方法

extension CLQRController {}
