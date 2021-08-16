//
//  CLHoneycombScrollViewController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/8/16.
//

import UIKit
import SnapKit

//MARK: - JmoVxia---枚举
extension CLHoneycombScrollViewController {
    class CLHoneycombDataModel {
        var index: Int = 0
        var selected: Bool = false
        
        init(index: Int) {
            self.index = index
        }
    }
}
//MARK: - JmoVxia---类-属性
class CLHoneycombScrollViewController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
    private var dataSource = [CLHoneycombDataModel]()
    private lazy var honeycombView: CLHoneycombView = {
        let view = CLHoneycombView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.itemRowSpacing = 10
        view.itemColumnSpacing = 10
        view.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.register(CLHoneycombCustomCell.self, forCellWithReuseIdentifier: "CLHoneycombCustomCell")
        view.delegate = self
        view.dataSource = self
        return view
    }()
}
//MARK: - JmoVxia---生命周期
extension CLHoneycombScrollViewController {
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
//MARK: - JmoVxia---布局
private extension CLHoneycombScrollViewController {
    func initUI() {
        updateTitleLabel { label in
            label.text = "UIScrollView"
        }
        view.backgroundColor = .hex("#93DAAE")
        view.addSubview(honeycombView)
    }
    func makeConstraints() {
        honeycombView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
//MARK: - JmoVxia---数据
private extension CLHoneycombScrollViewController {
    func initData() {
        for i in 0..<210 {
            let model = CLHoneycombDataModel(index: i)
            dataSource.append(model)
        }
        honeycombView.reloadData()
    }
}
//MARK: - JmoVxia---override
extension CLHoneycombScrollViewController {
}
//MARK: - JmoVxia---objc
@objc private extension CLHoneycombScrollViewController {
}
//MARK: - JmoVxia---私有方法
private extension CLHoneycombScrollViewController {
}
//MARK: - JmoVxia---公共方法
extension CLHoneycombScrollViewController {
}
extension CLHoneycombScrollViewController: CLHoneycombDataSource {
    func honeycombViewNumberOfItemsPerRow(_ honeycombView: CLHoneycombView) -> Int {
        return 4
    }
    func honeycombViewNumberOfItems(_ honeycombView: CLHoneycombView) -> Int {
        return dataSource.count
    }
    func honeycombView(_ honeycombView: CLHoneycombView, cellForRowAtIndex index: Int) -> CLHoneycombCell {
        let cell = honeycombView.dequeueReusableCell(withReuseIdentifier: "CLHoneycombCustomCell") as! CLHoneycombCustomCell
        cell.imageView.image = UIImage(named: "Hexagon-\(index % 30 + 1)")
        return cell
    }
}
extension CLHoneycombScrollViewController: CLHoneycombDelegate {
    func honeycombView(_ honeycombView: CLHoneycombView, willDisplayCell cell: CLHoneycombCell, forIndex index: Int) {
        (cell as? CLHoneycombCustomCell)?.animation()
    }
    func honeycombView(_ honeycombView: CLHoneycombView, didSelectItemAtIndex index: Int) {
        dataSource[index].selected = true
    }
    func honeycombView(_ honeycombView: CLHoneycombView, didDeselectItemAtIndex index: Int) {
        dataSource[index].selected = false
    }
}
