//
//  CLCameraImagePreviewController.swift
//  CLCamera
//
//  Created by Chen JmoVxia on 2024/2/20.
//

import SnapKit
import UIKit

// MARK: - JmoVxia---CLCameraVideoPreviewControllerDelegate

protocol CLCameraImagePreviewControllerDelegate: AnyObject {
    func imagePreviewController(_ controller: CLCameraImagePreviewController, didClickDoneButtonWith photo: UIImage)
}

// MARK: - JmoVxia---类-属性

class CLCameraImagePreviewController: UIViewController {
    init(image: UIImage) {
        photo = image
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        modalPresentationCapturesStatusBarAppearance = true
        previewImageView.image = image
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var mainStackView: UIStackView = {
        let view = UIStackView()
        view.isUserInteractionEnabled = true
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.insetsLayoutMarginsFromSafeArea = false
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .zero
        view.spacing = 0
        return view
    }()

    private lazy var toolBar: CLCameraPreviewToolBar = {
        let view = CLCameraPreviewToolBar()
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.delegate = self
        return view
    }()

    private lazy var previewStackView: UIStackView = {
        let view = UIStackView()
        view.isUserInteractionEnabled = true
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.insetsLayoutMarginsFromSafeArea = false
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .zero
        view.spacing = 0
        return view
    }()

    private lazy var previewScrollView: UIScrollView = {
        let view = UIScrollView()
        view.isUserInteractionEnabled = true
        view.bounces = false
        view.maximumZoomScale = 2.0
        view.minimumZoomScale = 1.0
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.backgroundColor = .clear
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()

    private lazy var previewImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()

    private var photo: UIImage

    weak var delegate: CLCameraImagePreviewControllerDelegate?
}

// MARK: - JmoVxia---生命周期

extension CLCameraImagePreviewController {
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

private extension CLCameraImagePreviewController {
    func setupUI() {
        view.backgroundColor = .black
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(previewStackView)
        mainStackView.addArrangedSubview(toolBar)
        previewStackView.addArrangedSubview(previewScrollView)
        previewScrollView.addSubview(previewImageView)
    }

    func makeConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        previewImageView.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
}

// MARK: - JmoVxia---数据

private extension CLCameraImagePreviewController {
    func configData() {}
}

// MARK: - JmoVxia---override

extension CLCameraImagePreviewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    override var prefersStatusBarHidden: Bool {
        true
    }
}

// MARK: - JmoVxia---objc

@objc private extension CLCameraImagePreviewController {}

// MARK: - JmoVxia---私有方法

private extension CLCameraImagePreviewController {}

// MARK: - JmoVxia---公共方法

extension CLCameraImagePreviewController {}

// MARK: - JmoVxia---CLCameraPreviewToolBarDelegate

extension CLCameraImagePreviewController: CLCameraPreviewToolBarDelegate {
    func didTapCancelButton(on toolBar: CLCameraPreviewToolBar) {
        dismiss(animated: false, completion: nil)
    }

    func didTapDoneButton(on toolBar: CLCameraPreviewToolBar) {
        delegate?.imagePreviewController(self, didClickDoneButtonWith: photo)
    }
}

// MARK: - JmoVxia---UIScrollViewDelegate

extension CLCameraImagePreviewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        previewImageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let x = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0) + scrollView.contentSize.width * 0.5
        let y = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0) + scrollView.contentSize.height * 0.5
        previewImageView.center = .init(x: x, y: y)
    }
}
