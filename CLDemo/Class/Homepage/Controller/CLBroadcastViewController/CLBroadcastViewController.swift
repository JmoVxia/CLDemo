//
//  CLBroadcastViewController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/10/12.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLBroadcastViewController: CLBaseViewController {
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
    private lazy var customLabel: UILabel = {
        let view = UILabel()
        view.text = "自定义View"
        view.textColor = .red
        return view
    }()
    private lazy var broadcastView: CLBroadcastView = {
        let view = CLBroadcastView()
        view.register(CLBroadcastMainCell.self, forCellReuseIdentifier: "CLBroadcastMainCell")
        view.delegate = self
        view.dataSource = self
        view.tag = 0
        return view
    }()
    private lazy var broadcastView1: CLBroadcastView = {
        let view = CLBroadcastView()
        view.register(CLBroadcastMainCell.self, forCellReuseIdentifier: "CLBroadcastMainCell")
        view.delegate = self
        view.dataSource = self
        view.tag = 1
        return view
    }()
    private lazy var broadcastView2: CLBroadcastView = {
        let view = CLBroadcastView()
        view.register(CLBroadcastMainCell.self, forCellReuseIdentifier: "CLBroadcastMainCell")
        view.delegate = self
        view.dataSource = self
        view.tag = 2
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
        view.addSubview(collectionVerticalLabel)
        view.addSubview(collectionHorizontalLabel)
        view.addSubview(scrollViewLabel)
        view.addSubview(customLabel)
        view.addSubview(broadcastView)
        view.addSubview(broadcastView1)
        view.addSubview(broadcastView2)
        view.addSubview(carouseView)
        view.addSubview(horizontalInfiniteView)
        view.addSubview(verticalInfiniteView)
    }
    func makeConstraints() {
        carouseView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(120)
            make.bottom.equalTo(broadcastView.snp.top).offset(-30)
        }
        broadcastView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        broadcastView1.snp.makeConstraints { (make) in
            make.top.equalTo(broadcastView.snp.bottom)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        broadcastView2.snp.makeConstraints { (make) in
            make.top.equalTo(broadcastView1.snp.bottom)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-120)
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
        }
        collectionHorizontalLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(horizontalInfiniteView.snp.top)
            make.centerX.equalToSuperview()
        }
        scrollViewLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(carouseView.snp.top)
        }
        customLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(broadcastView.snp.top)
        }
    }
    func reloadData() {
        broadcastView.reloadData()
        broadcastView1.reloadData()
        broadcastView2.reloadData()
        
        carouseView.reloadData()
        horizontalInfiniteView.reloadData()
        verticalInfiniteView.reloadData()
        
        timer.start()
    }
    func scrollToNext() {
        broadcastView.scrollToNext()
        broadcastView1.scrollToNext()
        broadcastView2.scrollToNext()
        
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
extension CLBroadcastViewController: CLBroadcastViewDelegate {
    func broadcastView(_ broadcast: CLBroadcastView, didSelect index: Int) {
        print("点击\(index)")
    }
}
extension CLBroadcastViewController: CLBroadcastViewDataSource {
    func broadcastViewRows(_ broadcast: CLBroadcastView) -> Int {
        return arrayDS.count
    }
    func broadcastView(_ broadcast: CLBroadcastView, cellForRowAt index: Int) -> CLBroadcastCell {
        let cell = broadcast.dequeueReusableCell(withIdentifier: "CLBroadcastMainCell")
        cell.backgroundColor = UIColor.red.withAlphaComponent(0.35)
        let currentIndex = (index + broadcast.tag) % self.arrayDS.count
        (cell as? CLBroadcastMainCell)?.adText = arrayDS[currentIndex]
        return cell
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
