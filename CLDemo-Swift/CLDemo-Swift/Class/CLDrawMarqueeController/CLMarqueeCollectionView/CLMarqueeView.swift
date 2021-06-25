//
//  CLDrawMarqueeCollectionView.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/11/10.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import SnapKit


class CLMarqueeView: UIView {
    private (set) weak var delegate: (UICollectionViewDelegate & UICollectionViewDataSource)!
    private (set) var collectionView: UICollectionView!
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, delegate: (UICollectionViewDelegate & UICollectionViewDataSource)) {
        super.init(frame: frame)
        self.delegate = delegate
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if super.responds(to: aSelector) {
            return self
        }else if let delegate = delegate, delegate.responds(to: aSelector) {
            return delegate
        }
        return self
    }
    override func responds(to aSelector: Selector!) -> Bool {
        if let delegate = delegate {
            return super.responds(to: aSelector) || delegate.responds(to: aSelector)
        }
        return super.responds(to: aSelector)
    }
}
extension CLMarqueeView {
    func reloadData() {
        collectionView.reloadData()
    }
    func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
}
extension CLMarqueeView {
    func horizontalScroll(_ offset: CGFloat) {
        guard (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection == .horizontal else {
            return
        }
        collectionView.contentOffset.x += offset
    }
    func verticalScroll(_ offset: CGFloat) {
        guard (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection == .vertical else {
            return
        }
        collectionView.contentOffset.y += offset
    }
}
extension CLMarqueeView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate.collectionView(collectionView, numberOfItemsInSection: section)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return delegate.collectionView(collectionView, cellForItemAt: indexPath)
    }
}
extension CLMarqueeView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection == .horizontal {
            let contentOffsetX = scrollView.contentOffset.x
            let framWidth = bounds.width
            let sectionLength = collectionView.contentSize.width / 3.0
            let contentLength = collectionView.contentSize.width
            if contentOffsetX <= 0 {
                collectionView.contentOffset.x = sectionLength - contentOffsetX
            } else if contentOffsetX >= contentLength - framWidth {
                collectionView.contentOffset.x = contentLength - sectionLength - framWidth
            }
        }else {
            let contentOffsetY = scrollView.contentOffset.y
            let framHeight = bounds.height
            let sectionLength = collectionView.contentSize.height / 3.0
            let contentLength = collectionView.contentSize.height
            if contentOffsetY <= 0 {
                collectionView.contentOffset.y = sectionLength - contentOffsetY
            } else if contentOffsetY >= contentLength - framHeight {
                collectionView.contentOffset.y = contentLength - framHeight - sectionLength
            }
        }
        delegate.scrollViewDidScroll?(scrollView)
    }
}

