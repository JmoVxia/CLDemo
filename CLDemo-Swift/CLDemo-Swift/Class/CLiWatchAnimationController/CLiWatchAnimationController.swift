//
//  CLiWatchAnimationController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/8/2.
//

import UIKit
import SnapKit

//MARK: - JmoVxia---枚举
extension CLiWatchAnimationController {
}
//MARK: - JmoVxia---类-属性
class CLiWatchAnimationController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
    private lazy var hexagonalView: HexagonalView = {
        let view = HexagonalView(frame: view.bounds)
        view.hexagonalDataSource = self
        view.hexagonalDelegate = self
        return view
    }()
    let iconArray: [UIImage] = ["Hexacon-1","Hexacon-2","Hexacon-3","Hexacon-4","Hexacon-5","Hexacon-6","Hexacon-7","Hexacon-8","Hexacon-9","Hexacon-10","Hexacon-11","Hexacon-12","Hexacon-13","Hexacon-14","Hexacon-15","Hexacon-16","Hexacon-17","Hexacon-18","Hexacon-19","Hexacon-20","Hexacon-21","Hexacon-22","Hexacon-23","Hexacon-24","Hexacon-25"].map { UIImage(named: $0)! }
    var dataArray = [UIImage]()
}
//MARK: - JmoVxia---生命周期
extension CLiWatchAnimationController {
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
private extension CLiWatchAnimationController {
    func initUI() {
        view.backgroundColor = UIColor(red: 18/255, green: 52/255, blue: 86/255, alpha: 1)
        for _ in 0...28 {
            dataArray += iconArray
        }
        view.addSubview(hexagonalView)
        hexagonalView.reloadData()
    }
    func makeConstraints() {
    }
}
extension CLiWatchAnimationController: HexagonalViewDataSource {
    func hexagonalView(_ hexagonalView: HexagonalView, imageForIndex index: Int) -> UIImage? {
        return dataArray[index]
    }
    func numberOfItemInHexagonalView(_ hexagonalView: HexagonalView) -> Int {
        return dataArray.count - 1
    }
}

extension CLiWatchAnimationController: HexagonalViewDelegate {
    func hexagonalView(_ hexagonalView: HexagonalView, didSelectItemAtIndex index: Int) {
        print("didSelectItemAtIndex: \(index)")
    }
}
