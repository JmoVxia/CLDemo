//
//  CLGrayscaleController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2022/2/14.
//

import SnapKit
import UIKit

// MARK: - JmoVxia---类-属性

class CLGrayscaleController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {}

    let image = UIImage(named: "sss")

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = image
        return view
    }()

    private lazy var averageButton: UIButton = {
        let view = UIButton()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .orange.withAlphaComponent(0.2)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.setTitleColor(UIColor.red.withAlphaComponent(0.6), for: .normal)
        view.setTitle("平均值", for: .normal)
        view.setTitleColor(UIColor.red.withAlphaComponent(0.4), for: .normal)
        view.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        return view
    }()

    private lazy var rec601Button: UIButton = {
        let view = UIButton()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .orange.withAlphaComponent(0.2)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.setTitleColor(UIColor.red.withAlphaComponent(0.6), for: .normal)
        view.setTitle("rec601", for: .normal)
        view.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        return view
    }()

    private lazy var rec709Button: UIButton = {
        let view = UIButton()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .orange.withAlphaComponent(0.2)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.setTitleColor(UIColor.red.withAlphaComponent(0.6), for: .normal)
        view.setTitle("rec709", for: .normal)
        view.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        return view
    }()

    private lazy var rec2001Button: UIButton = {
        let view = UIButton()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .orange.withAlphaComponent(0.2)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.setTitleColor(UIColor.red.withAlphaComponent(0.6), for: .normal)
        view.setTitle("rec2001", for: .normal)
        view.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        return view
    }()

    private lazy var maxButton: UIButton = {
        let view = UIButton()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .orange.withAlphaComponent(0.2)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.setTitleColor(UIColor.red.withAlphaComponent(0.6), for: .normal)
        view.setTitle("最大值", for: .normal)
        view.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        return view
    }()

    private lazy var minButton: UIButton = {
        let view = UIButton()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .orange.withAlphaComponent(0.2)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.setTitleColor(UIColor.red.withAlphaComponent(0.6), for: .normal)
        view.setTitle("最小值", for: .normal)
        view.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        return view
    }()

    private lazy var redButton: UIButton = {
        let view = UIButton()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .orange.withAlphaComponent(0.2)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.setTitleColor(UIColor.red.withAlphaComponent(0.6), for: .normal)
        view.setTitle("分量法—红", for: .normal)
        view.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        return view
    }()

    private lazy var greenButton: UIButton = {
        let view = UIButton()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .orange.withAlphaComponent(0.2)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.setTitleColor(UIColor.red.withAlphaComponent(0.6), for: .normal)
        view.setTitle("分量法—绿", for: .normal)
        view.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        return view
    }()

    private lazy var blueButton: UIButton = {
        let view = UIButton()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .orange.withAlphaComponent(0.2)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.setTitleColor(UIColor.red.withAlphaComponent(0.6), for: .normal)
        view.setTitle("分量法—蓝", for: .normal)
        view.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        return view
    }()
}

// MARK: - JmoVxia---生命周期

extension CLGrayscaleController {
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

// MARK: - JmoVxia---布局

private extension CLGrayscaleController {
    func initUI() {
        view.addSubview(imageView)
        view.addSubview(averageButton)
        view.addSubview(rec601Button)
        view.addSubview(rec709Button)
        view.addSubview(rec2001Button)
        view.addSubview(maxButton)
        view.addSubview(minButton)
        view.addSubview(redButton)
        view.addSubview(greenButton)
        view.addSubview(blueButton)
    }

    func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 187.5, height: 281.25))
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
        }
        averageButton.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.size.equalTo(CGSize(width: 150, height: 40))
            make.top.equalTo(imageView.snp.bottom).offset(30)
        }
        rec601Button.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.size.equalTo(averageButton)
            make.top.equalTo(imageView.snp.bottom).offset(30)
        }
        rec709Button.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.size.equalTo(averageButton)
            make.top.equalTo(rec601Button.snp.bottom).offset(30)
        }
        rec2001Button.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.size.equalTo(averageButton)
            make.top.equalTo(rec601Button.snp.bottom).offset(30)
        }
        maxButton.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.size.equalTo(averageButton)
            make.top.equalTo(rec2001Button.snp.bottom).offset(30)
        }
        minButton.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.size.equalTo(averageButton)
            make.top.equalTo(rec2001Button.snp.bottom).offset(30)
        }
        redButton.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.size.equalTo(averageButton)
            make.top.equalTo(minButton.snp.bottom).offset(30)
        }
        greenButton.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.size.equalTo(averageButton)
            make.top.equalTo(minButton.snp.bottom).offset(30)
        }
        blueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(averageButton)
            make.top.equalTo(greenButton.snp.bottom).offset(30)
        }
    }
}

// MARK: - JmoVxia---数据

private extension CLGrayscaleController {
    func initData() {}
}

// MARK: - JmoVxia---override

extension CLGrayscaleController {}

// MARK: - JmoVxia---objc

@objc private extension CLGrayscaleController {
    func clickButton(_ button: UIButton) {
        switch button {
        case averageButton:
            imageView.image = image?.grayscale(.average)
        case rec601Button:
            imageView.image = image?.grayscale(.rec601)
        case rec709Button:
            imageView.image = image?.grayscale(.rec709)
        case rec2001Button:
            imageView.image = image?.grayscale(.rec2100)
        case maxButton:
            imageView.image = image?.grayscale(.max)
        case minButton:
            imageView.image = image?.grayscale(.min)
        case redButton:
            imageView.image = image?.grayscale(.red)
        case greenButton:
            imageView.image = image?.grayscale(.green)
        case blueButton:
            imageView.image = image?.grayscale(.blue)
        default:
            break
        }
    }
}

// MARK: - JmoVxia---私有方法

private extension CLGrayscaleController {}

// MARK: - JmoVxia---公共方法

extension CLGrayscaleController {}
