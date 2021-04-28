//
//  CLCarouselView.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/10/12.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

protocol CLCarouselViewDataSource: AnyObject {
    ///轮播总个数
    func carouselViewRows() -> Int
    ///数据源改变
    func carouselViewDidChange(cell: CLCarouselCell, index: Int)
}
protocol CLCarouselViewDelegate: AnyObject {
    ///点击cell
    func carouselViewDidSelect(cell: CLCarouselCell, index: Int)
}

class CLCarouselView: UIView {
    ///数据源协议
    weak var dataSource: CLCarouselViewDataSource?
    ///代理
    weak var delegate: CLCarouselViewDelegate?
    /// 设定自动滚动间隔(默认三秒)
    var autoScrollDeley: TimeInterval = 3
    /// 自动轮播
    var isAutoScroll : Bool = true
    /// 当前索引
    private var currentIndex: Int = 0
    /// 定时器
    private var timer: CLGCDTimer?
    ///总个数
    private var rows: Int = 0
    ///滑动视图
    private lazy var scrollView : UIScrollView = {
       let view = UIScrollView()
        view.isPagingEnabled = true
        view.bounces = false
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        return view
    }()
    ///上一个cell
    private lazy var lastCell : CLCarouselCell = {
        let view = CLCarouselCell()
        return view
    }()
    ///当前cell
    private lazy var currentCell : CLCarouselCell = {
        let view = CLCarouselCell()
        return view
    }()
    ///下一个cell
    private lazy var nextCell : CLCarouselCell = {
        let view = CLCarouselCell()
        return view
    }()
    override init(frame : CGRect){
        super.init(frame: frame)
        initUI()
        makeConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLCarouselView {
    private func initUI(){
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickCell)))
        addSubview(scrollView)
        scrollView.addSubview(lastCell)
        scrollView.addSubview(currentCell)
        scrollView.addSubview(nextCell)
    }
    private func makeConstraints() {
        scrollView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        lastCell.snp.makeConstraints({ (make) in
            make.center.size.equalToSuperview()
        })
        currentCell.snp.makeConstraints({ (make) in
            make.size.centerY.equalToSuperview()
            make.left.equalTo(lastCell.snp.right)
        })
        nextCell.snp.makeConstraints({ (make) in
            make.size.centerY.equalToSuperview()
            make.left.equalTo(currentCell.snp.right)
        })
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = CGSize(width: (bounds.width) * 3.0, height: 0)
    }
}
extension CLCarouselView {
    func reloadData() {
        let rows = dataSource?.carouselViewRows() ?? 0
        self.rows = rows
        if isAutoScroll {
            removeTimer()
            setUpTimer()
        }
        resetData()
    }
}
extension CLCarouselView {
    private func setUpTimer(){
        timer = CLGCDTimer(interval: autoScrollDeley, delaySecs: autoScrollDeley, action: {[weak self] (_) in
            self?.scrollToLast()
        })
        timer?.start()
    }
    private func removeTimer(){
        timer?.cancel()
    }
}
extension CLCarouselView {
    @objc private func clickCell(){
        delegate?.carouselViewDidSelect(cell: currentCell, index: currentIndex)
    }
}
extension CLCarouselView {
    func scrollToLast(){
        let offset = CGPoint(x: scrollView.contentOffset.x - bounds.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
    func scrollToNext(){
        let offset = CGPoint(x: scrollView.contentOffset.x + bounds.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
}
extension CLCarouselView {
    private func resetData(){
        scrollView.isScrollEnabled = rows != 1
        if rows == 1 {
            dataSource?.carouselViewDidChange(cell: currentCell, index: 0)
        }else {
            let left: Int = (currentIndex - 1 + rows) % rows
            let middle: Int = currentIndex
            let right: Int = (currentIndex + 1) % rows
            dataSource?.carouselViewDidChange(cell: lastCell, index: left)
            dataSource?.carouselViewDidChange(cell: currentCell, index: middle)
            dataSource?.carouselViewDidChange(cell: nextCell, index: right)
        }
        DispatchQueue.main.async {
            self.scrollView.setContentOffset(CGPoint(x:(self.bounds.width),y:0), animated: false)
        }
    }
}
extension CLCarouselView: UIScrollViewDelegate {
    /// 开始用手滚动时干掉定时器
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if isAutoScroll == true {
            removeTimer()
        }
    }
    /// 用手滚动结束时重新添加定时器
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isAutoScroll == true {
            setUpTimer()
        }
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(scrollView)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard rows > 0 else {
            return
        }
        let offsetX = scrollView.contentOffset.x
        if offsetX >= (bounds.width) * 2 {
            currentIndex = (currentIndex + 1) % rows
            resetData()
        }else if offsetX <= 0 {
            currentIndex = (currentIndex - 1 + rows) % rows
            resetData()
        }
    }
}
