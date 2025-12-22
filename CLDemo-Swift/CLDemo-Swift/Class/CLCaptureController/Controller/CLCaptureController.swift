//
//  CLCaptureController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2024/2/19.
//

import CLCamera
import UIKit

// MARK: - JmoVxia---类-属性

class CLCaptureController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {}

    private lazy var cameraButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.purple.withAlphaComponent(0.35)
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 8
        view.setTitle("拍照", for: .normal)
        view.setTitleColor(.orange, for: .normal)
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        view.configuration = config
        view.addTarget(self, action: #selector(cameraAction), for: .touchUpInside)
        return view
    }()
}

// MARK: - JmoVxia---生命周期

extension CLCaptureController {
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

private extension CLCaptureController {
    func setupUI() {
        view.backgroundColor = .lightGray
        view.addSubview(cameraButton)
    }

    func makeConstraints() {
        cameraButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - JmoVxia---数据

private extension CLCaptureController {
    func configData() {}
}

// MARK: - JmoVxia---override

extension CLCaptureController {}

// MARK: - JmoVxia---objc

@objc private extension CLCaptureController {
    func cameraAction() {
        let vc = CLCameraController()
        vc.delegate = self
        present(vc, animated: true)
    }
}

extension CLCaptureController: CLCameraControllerDelegate {
    func cameraController(_ controller: CLCameraController, didFinishTakingPhoto photo: UIImage) {
        controller.presentingViewController?.dismiss(animated: true)
        CLLog("photo: \(photo)")
    }

    func cameraController(_ controller: CLCameraController, didFinishTakingVideo videoURL: URL) {
        controller.presentingViewController?.dismiss(animated: true)
        CLLog("videoURL: \(videoURL)")
    }
}

// MARK: - JmoVxia---私有方法

private extension CLCaptureController {}

// MARK: - JmoVxia---公共方法

extension CLCaptureController {}
