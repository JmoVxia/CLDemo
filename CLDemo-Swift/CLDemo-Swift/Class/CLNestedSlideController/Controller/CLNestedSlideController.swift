import SnapKit
import UIKit

final class CLNestedSlideController: CLController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "CLPinnedPage Demo"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "选择演示方案"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private lazy var viewModeButton: UIButton = makePrimaryButton(title: "View 方案")
    private lazy var controllerModeButton: UIButton = makePrimaryButton(title: "Controller 方案")

    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [viewModeButton, controllerModeButton])
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.distribution = .fillEqually
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 245 / 255, green: 247 / 255, blue: 251 / 255, alpha: 1)
        updateTitleLabel { label in
            label.text = "滑动嵌套"
        }
        setupUI()
        bindActions()
    }
}

private extension CLNestedSlideController {
    func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(buttonStack)

        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.centerY.equalToSuperview().offset(-90)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }

        buttonStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(36)
            make.height.equalTo(116)
        }
    }

    func bindActions() {
        viewModeButton.addTarget(self, action: #selector(handleViewModeTapped), for: .touchUpInside)
        controllerModeButton.addTarget(self, action: #selector(handleControllerModeTapped), for: .touchUpInside)
    }

    func makePrimaryButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 47 / 255, green: 103 / 255, blue: 245 / 255, alpha: 1)
        button.layer.cornerRadius = 14
        return button
    }

    @objc func handleViewModeTapped() {
        navigationController?.pushViewController(CLNestedSlideViewModeController(), animated: true)
    }

    @objc func handleControllerModeTapped() {
        navigationController?.pushViewController(CLNestedSlideControllerModeController(), animated: true)
    }
}
