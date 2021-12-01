//
//  CLBroadcastViewController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/10/12.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLBroadcastViewController: CLController {
    private lazy var arrayDS: [String] = {
        var array = [String]()
        array.append("我是第一个")
        array.append("我是第二个")
        array.append("我是第三个")
        array.append("我是第四个")
        array.append("我是第五个")
        array.append("我是第六个")
        array.append("我是第七个")
        return array
    }()
    private lazy var layoutView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var collectionVerticalLabel: UILabel = {
        let view = UILabel()
        view.text = "UICollectionView 竖直"
        view.textColor = .red
        return view
    }()
    private lazy var collectionHorizontalLabel: UILabel = {
        let view = UILabel()
        view.text = "UICollectionView 水平"
        view.textColor = .red
        return view
    }()
    private lazy var scrollViewLabel: UILabel = {
        let view = UILabel()
        view.text = "UIScrollView"
        view.textColor = .red
        return view
    }()
    private lazy var carouseView: CLCarouselView = {
        let view = CLCarouselView()
        view.backgroundColor = UIColor.orange.withAlphaComponent(0.25)
        view.dataSource = self
        view.delegate = self
        view.isAutoScroll = true
        view.autoScrollDeley = 1
        return view
    }()
    private lazy var horizontalInfiniteView: CLInfiniteView = {
        let layout = CLFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: view.bounds.width / 3.0, height: 80)
        let view = CLInfiniteView(frame: .zero, collectionViewLayout: layout)
        view.register(CLInfiniteViewCell.self, forCellWithReuseIdentifier: "CLInfiniteViewCell")
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor.green.withAlphaComponent(0.25)
        return view
    }()
    private lazy var verticalInfiniteView: CLInfiniteView = {
        let layout = CLFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: view.bounds.width, height: 50)
        let view = CLInfiniteView(frame: .zero, collectionViewLayout: layout)
        view.register(CLInfiniteViewCell.self, forCellWithReuseIdentifier: "CLInfiniteViewCell")
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor.yellow.withAlphaComponent(0.25)
        return view
    }()
    private lazy var timer: CLGCDTimer = {
        let gcdTimer = CLGCDTimer(interval: 1, delaySecs: 1) {[weak self] (_) in
            self?.scrollToNext()
        }
        return gcdTimer
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        reloadData()
    }
    deinit {
        CLLog("CLBroadcastViewController deinit")
    }
}
extension CLBroadcastViewController {
    func initUI() {
        view.addSubview(layoutView)
        layoutView.addSubview(collectionVerticalLabel)
        layoutView.addSubview(collectionHorizontalLabel)
        layoutView.addSubview(scrollViewLabel)
        layoutView.addSubview(carouseView)
        layoutView.addSubview(horizontalInfiniteView)
        layoutView.addSubview(verticalInfiniteView)
    }
    func makeConstraints() {
        layoutView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        carouseView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(120)
        }
        horizontalInfiniteView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(80)
            make.bottom.equalTo(carouseView.snp.top).offset(-30)
        }
        verticalInfiniteView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(150)
            make.bottom.equalTo(horizontalInfiniteView.snp.top).offset(-30)
        }
        collectionVerticalLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(verticalInfiniteView.snp.top)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        collectionHorizontalLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(horizontalInfiniteView.snp.top)
            make.centerX.equalToSuperview()
        }
        scrollViewLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(carouseView.snp.top)
        }
    }
    func reloadData() {
        carouseView.reloadData()
        horizontalInfiniteView.reloadData()
        verticalInfiniteView.reloadData()
        
        timer.start()
    }
    func scrollToNext() {
        
        horizontalInfiniteView.scrollToRightItem()
        verticalInfiniteView.scrollToBottomItem()
    }
}
extension CLBroadcastViewController: CLCarouselViewDataSource {
    func carouselViewRows() -> Int {
        return arrayDS.count
    }
    func carouselViewDidChange(cell: CLCarouselCell, index: Int) {
        cell.label.text = arrayDS[index]
    }
}
extension CLBroadcastViewController: CLCarouselViewDelegate {
    func carouselViewDidSelect(cell: CLCarouselCell, index: Int) {
        print("点击\(index)")
    }
}
extension CLBroadcastViewController: CLInfiniteViewDataSource {
    func numberOfItems(in infiniteView: CLInfiniteView) -> Int {
        return arrayDS.count
    }
    func infiniteView(_ infiniteView: CLInfiniteView, cellForItemAt indexPath: IndexPath, index: Int) -> UICollectionViewCell {
        let cell = infiniteView.dequeueReusableCell(withReuseIdentifier: "CLInfiniteViewCell", for: indexPath)
        if let cell = cell as? CLInfiniteViewCell {
            cell.label.text = arrayDS[index]
        }
        return cell
    }
}
extension CLBroadcastViewController: CLInfiniteViewDelegate {
    func infiniteView(_ infiniteView: CLInfiniteView, didSelectCellAt index: Int) {
        CLLog("didSelectCellAtIndex: \(index)")
    }
}
