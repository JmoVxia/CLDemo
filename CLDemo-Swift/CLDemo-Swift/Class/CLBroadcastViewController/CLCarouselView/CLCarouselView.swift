//
//  CLCarouselView.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/10/12.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

protocol CLCarouselViewDataSource: AnyObject {
    func numberOfItems(inCarouselView carouselView: CLCarouselView) -> Int
    func carouselView(_ carouselView: CLCarouselView, configureCell cell: CLCarouselCell, forItemAt index: Int)
}

protocol CLCarouselViewDelegate: AnyObject {
    func carouselView(_ carouselView: CLCarouselView, didSelectItemAt index: Int)
}

class CLCarouselView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var scrollView: UIScrollView = {
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

    private lazy var pageControl: CLCarouselPageControl = {
        let control = CLCarouselPageControl()
        control.isUserInteractionEnabled = false
        return control
    }()

    private let previousCell = CLCarouselCell()

    private let currentCell = CLCarouselCell()

    private let nextCell = CLCarouselCell()

    private var timer: CLGCDTimer?

    private var rows = Int.zero

    private var currentIndex = Int.zero {
        didSet {
            dataSource?.carouselView(self, configureCell: previousCell, forItemAt: rows == 1 ? .zero : (currentIndex - 1 + rows) % rows)
            dataSource?.carouselView(self, configureCell: currentCell, forItemAt: rows == 1 ? .zero : currentIndex)
            dataSource?.carouselView(self, configureCell: nextCell, forItemAt: rows == 1 ? .zero : (currentIndex + 1) % rows)
            scrollView.setContentOffset(CGPoint(x: bounds.width, y: 0), animated: false)
            pageControl.currentPage = currentIndex
        }
    }

    weak var dataSource: CLCarouselViewDataSource?

    weak var delegate: CLCarouselViewDelegate?

    var autoScrollDelay = TimeInterval(3)

    var isAutoScrollEnabled = true
}

extension CLCarouselView {
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = CGSize(width: (bounds.width) * 3.0, height: 0)
        scrollView.setContentOffset(CGPoint(x: bounds.width, y: 0), animated: false)
    }
}

private extension CLCarouselView {
    func setupUI() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCellTap)))
        addSubview(scrollView)
        addSubview(pageControl)
        scrollView.addSubview(previousCell)
        scrollView.addSubview(currentCell)
        scrollView.addSubview(nextCell)
    }

    func makeConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        previousCell.snp.makeConstraints { make in
            make.center.size.equalToSuperview()
        }
        currentCell.snp.makeConstraints { make in
            make.size.centerY.equalToSuperview()
            make.left.equalTo(previousCell.snp.right)
        }
        nextCell.snp.makeConstraints { make in
            make.size.centerY.equalToSuperview()
            make.left.equalTo(currentCell.snp.right)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-5)
        }
    }
}

private extension CLCarouselView {
    func setupTimer() {
        timer = CLGCDTimer(interval: autoScrollDelay, delaySecs: autoScrollDelay)
        timer?.start { [weak self] count in
            self?.scrollToNext()
        }
    }

    func removeTimer() {
        timer = nil
    }
}

private extension CLCarouselView {
    func scrollToPrevious() {
        let offset = CGPoint(x: scrollView.contentOffset.x - bounds.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }

    func scrollToNext() {
        let offset = CGPoint(x: scrollView.contentOffset.x + bounds.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
}

@objc private extension CLCarouselView {
    func handleCellTap() {
        delegate?.carouselView(self, didSelectItemAt: currentIndex)
    }
}

extension CLCarouselView: UIScrollViewDelegate {
    /// 开始用手滚动时干掉定时器
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard isAutoScrollEnabled else { return }
        removeTimer()
    }

    /// 用手滚动结束时重新添加定时器
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard isAutoScrollEnabled else { return }
        setupTimer()
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard rows > 0 else { return }
        let offsetX = scrollView.contentOffset.x
        if offsetX >= (bounds.width) * 2 {
            currentIndex = (currentIndex + 1) % rows
        } else if offsetX <= 0 {
            currentIndex = (currentIndex - 1 + rows) % rows
        }
    }
}

extension CLCarouselView {
    func reloadData() {
        rows = dataSource?.numberOfItems(inCarouselView: self) ?? 0
        pageControl.isHidden = rows == 1
        pageControl.numberOfPages = rows
        currentIndex = .zero
        isAutoScrollEnabled ? setupTimer() : removeTimer()
    }
}
