//
//  CLStartsView.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/12/28.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import SnapKit

protocol CLStartsViewDataSource: NSObject {
    func numberOfItems(in startsView: CLStartsView) -> Int
    func imageOfStartsView(startsView: CLStartsView) -> (nomal: UIImage, selected: UIImage)
}

//MARK: - JmoVxia---类-属性
class CLStartsView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        addGestureRecognizer(tapGesture)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    weak var dataSource: CLStartsViewDataSource?
    private var stars: Int = 5
    var currentScore: Int = 5 {
        didSet {
            if oldValue != currentScore {
                topStarView?.snp.remakeConstraints({ (make) in
                    make.left.top.bottom.equalToSuperview()
                    make.width.equalToSuperview().multipliedBy(CGFloat(currentScore) / CGFloat(stars))
                })
                UIView.animate(withDuration: 0.2) {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                }
            }
        }
    }
    private var topStarView: UIView?
    private var bottomStarView: UIView?
}
extension CLStartsView {
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let offset = ((touches as NSSet).anyObject() as? UITouch)?.location(in: self).x else { return }
        let width = (bounds.width / CGFloat(stars))
        currentScore = max(Int(round(offset / width)), 1)
    }
}
//MARK: - JmoVxia---objc
@objc private extension CLStartsView {
    func tapAction(_ tap: UITapGestureRecognizer) {
        let offset = tap.location(in: self).x
        let width = (bounds.width / CGFloat(stars))
        currentScore = max(1, Int(ceil(offset / width)))
    }
}
//MARK: - JmoVxia---私有方法
private extension CLStartsView {
    func createStarViewWithImage(_ image: UIImage) -> UIView {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .clear
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        var lastView: UIImageView?
        for i in 0..<stars {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            view.addSubview(imageView)
            if let lastView = lastView {
                imageView.snp.makeConstraints { (make) in
                    make.top.bottom.equalTo(self)
                    make.left.equalTo(lastView.snp.right)
                    make.width.equalTo(lastView)
                    if i == stars - 1 {
                        make.right.equalTo(self)
                    }
                }
            }else {
                imageView.snp.makeConstraints { (make) in
                    make.left.top.bottom.equalTo(self)
                    if i == stars - 1 {
                        make.right.equalTo(self)
                    }
                }
            }
            lastView = imageView
        }
        return view
    }
}
extension CLStartsView {
    func reloadData() {
        guard let dataSource = dataSource else { return }
        self.stars = dataSource.numberOfItems(in: self)
        let image = dataSource.imageOfStartsView(startsView: self)
        
        subviews.forEach({$0.removeFromSuperview()})
        bottomStarView = createStarViewWithImage(image.nomal)
        topStarView = createStarViewWithImage(image.selected)
    }
}
