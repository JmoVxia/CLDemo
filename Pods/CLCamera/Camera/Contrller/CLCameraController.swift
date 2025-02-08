//
//  CLCameraController.swift
//  CLCamera
//
//  Created by Chen JmoVxia on 2024/2/26.
//

import SnapKit
import UIKit

// MARK: - JmoVxia---CLCameraViewControllerDelegate

public protocol CLCameraControllerDelegate: AnyObject {
    func cameraController(_ controller: CLCameraController, didFinishTakingPhoto photo: UIImage)
    func cameraController(_ controller: CLCameraController, didFinishTakingVideo videoURL: URL)
}

// MARK: - JmoVxia---类-属性

public class CLCameraController: UIViewController {
    public init(config: ((inout CLCameraConfig) -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        modalPresentationCapturesStatusBarAppearance = true
        config?(&self.config)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {}

    private lazy var controlView: CLCameraControlView = {
        let view = CLCameraControlView(config: config)
        view.delegate = self
        cameraHelper.setupPreviewLayer(to: view.previewContentView)
        return view
    }()

    private lazy var cameraHelper: CLCameraHelper = {
        let helper = CLCameraHelper(config: config)
        helper.delegate = self
        return helper
    }()

    private var config = CLCameraConfig()

    public weak var delegate: CLCameraControllerDelegate?
}

// MARK: - JmoVxia---生命周期

public extension CLCameraController {
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
        requestPermissions()
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

private extension CLCameraController {
    func setupUI() {
        view.backgroundColor = .black
        view.addSubview(controlView)
    }

    func makeConstraints() {
        controlView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - JmoVxia---数据

private extension CLCameraController {
    func requestPermissions() {
        CLPermissions.request([.camera, .microphone]) { state in
            guard CLPermissions.isAllowed(.camera) else { return self.showError(.cameraPermissionDenied) }
            guard CLPermissions.isAllowed(.microphone) else { return self.showError(.microphonePermissionDenied) }
            DispatchQueue.main.async {
                self.showAnimation()
            }
        }
    }
}

// MARK: - JmoVxia---override

public extension CLCameraController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    override var prefersStatusBarHidden: Bool {
        true
    }
}

// MARK: - JmoVxia---objc

@objc private extension CLCameraController {}

// MARK: - JmoVxia---私有方法

private extension CLCameraController {
    func showAnimation() {
        controlView.showRunningAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.controlView.showFocusAnimationAt(point: self.controlView.previewContentView.center)
        }
    }

    func stopRunning() {
        cameraHelper.stopRunning()
    }

    func showError(_ error: CLCameraError) {
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - JmoVxia---公共方法

extension CLCameraController {}

// MARK: - JmoVxia---CLCameraHelperDelegate

extension CLCameraController: CLCameraHelperDelegate {
    func cameraHelper(_ helper: CLCameraHelper, didOccurError error: CLCameraError) {
        showError(error)
    }

    func cameraHelper(_ helper: CLCameraHelper, didFinishTakingPhoto photo: UIImage) {
        let controller = CLCameraImagePreviewController(image: photo)
        controller.delegate = self
        present(controller, animated: false, completion: nil)
    }

    func cameraHelper(_ helper: CLCameraHelper, didFinishTakingVideo url: URL) {
        let controller = CLCameraVideoPreviewController(url: url)
        controller.delegate = self
        present(controller, animated: false, completion: nil)
    }
}

// MARK: - JmoVxia---CLCameraControlDelegate

extension CLCameraController: CLCameraControlDelegate {
    func cameraControlDidTapExit(_ controlView: CLCameraControlView) {
        dismiss(animated: true, completion: nil)
    }

    func cameraControlDidTapChangeCamera(_ controlView: CLCameraControlView) {
        cameraHelper.switchCamera()
    }

    func cameraControlDidTakePhoto(_ controlView: CLCameraControlView) {
        cameraHelper.capturePhoto()
    }

    func cameraControlDidBeginTakingVideo(_ controlView: CLCameraControlView) {
        cameraHelper.startRecordingVideo()
    }

    func cameraControlDidEndTakingVideo(_ controlView: CLCameraControlView) {
        cameraHelper.stopRecordingVideo()
    }

    func cameraControl(_ controlView: CLCameraControlView, didChangeVideoZoom zoomScale: Double) {
        cameraHelper.zoom(zoomScale)
    }

    func cameraControl(_ controlView: CLCameraControlView, didFocusAt point: CGPoint) {
        cameraHelper.focusAt(point)
    }

    func cameraControlDidPrepareForZoom(_ controlView: CLCameraControlView) {
        cameraHelper.prepareForZoom()
    }
}

// MARK: - JmoVxia---CLCameraImagePreviewControllerDelegate

extension CLCameraController: CLCameraImagePreviewControllerDelegate {
    func imagePreviewController(_ controller: CLCameraImagePreviewController, didClickDoneButtonWith photo: UIImage) {
        delegate?.cameraController(self, didFinishTakingPhoto: photo)
    }
}

// MARK: - JmoVxia---CLCameraControlDelegate

extension CLCameraController: CLCameraVideoPreviewControllerDelegate {
    func videoPreviewController(_ controller: CLCameraVideoPreviewController, didClickDoneButtonWith videoURL: URL) {
        delegate?.cameraController(self, didFinishTakingVideo: videoURL)
    }
}
