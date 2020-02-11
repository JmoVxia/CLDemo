//
//  CLTitleControllerView.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/5/1.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

protocol CLTitleControllerViewDataSource {
    func titleControllerViewTitles() -> [String]
    func titleControllerViewFont() -> UIFont
    func titleControllerView(titleColorAt index: Int) -> (nomal: UIColor, seleted: UIColor)
    func titleControllerView(controllerClassAt index: Int) -> (class: UIViewController.Type, fatherController: UIViewController)
}

class CLTitleControllerButton: UIButton {
    var isCreated: Bool = false
}

class CLTitleControllerView: UIView {
    private var dataSource: CLTitleControllerViewDataSource!
    private var gap: CGFloat = 0.0
    private var seletedButton: CLTitleControllerButton?
    private var buttonArray: [CLTitleControllerButton] = [CLTitleControllerButton]()
    lazy var titleScrollView: UIScrollView = {
        let view = UIScrollView()
        view.bounces = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    lazy var contentScrollView: UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.delegate = self;
        view.bounces = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    lazy var selectedView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        return view
    }()
    init(frame: CGRect, dataSource: CLTitleControllerViewDataSource) {
        super.init(frame: frame)
        self.dataSource = dataSource
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLTitleControllerView {
    private func initUI() {
        addSubview(titleScrollView)
        addSubview(contentScrollView)
        titleScrollView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 40)
        contentScrollView.frame = CGRect(x: 0, y: titleScrollView.bounds.maxY, width: bounds.width, height: bounds.height - titleScrollView.bounds.maxY)
        let titles = dataSource.titleControllerViewTitles()
        let font = dataSource.titleControllerViewFont()
        let allWidth: CGFloat = (titles.joined() as NSString).size(withAttributes: [.font : font]).width
        gap = max(30.0, (bounds.width - allWidth) / CGFloat(titles.count))
        var lastButton: UIButton?
        for (index, title) in titles.enumerated() {
            let titleColor = dataSource.titleControllerView(titleColorAt: index)
            let width = (title as NSString).size(withAttributes: [.font : font]).width + gap
            let button: CLTitleControllerButton = CLTitleControllerButton()
            button.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
            titleScrollView.addSubview(button)
            button.titleLabel?.font = font
            button.setTitle(title, for: .normal)
            button.setTitle(title, for: .selected)
            button.setTitle(title, for: .highlighted)
            button.setTitleColor(titleColor.nomal, for: .normal)
            button.setTitleColor(titleColor.seleted, for: .selected)
            button.frame = CGRect(x: (lastButton?.frame.maxX ?? 0.0), y: 0, width: width, height: titleScrollView.bounds.height)
            lastButton = button
            buttonArray.append(button)
        }
        titleScrollView.contentSize = CGSize(width: allWidth + gap * CGFloat(titles.count), height: titleScrollView.bounds.height)
        contentScrollView.contentSize = CGSize(width: bounds.width * CGFloat(titles.count), height: bounds.height - titleScrollView.bounds.maxY)
        if let fristButton = titleScrollView.subviews.first as? CLTitleControllerButton {
            seletedButton(fristButton, animation: false)
            scrollViewDidEndScrollingAnimation(contentScrollView)
        }
    }
}
extension CLTitleControllerView {
    private func seletedButton(_ button: CLTitleControllerButton, animation: Bool) {
        seletedButton?.isSelected = false
        titleScrollView.addSubview(selectedView)
        UIView.animate(withDuration: animation ? 0.25 : 0.0) {
            button.isSelected = true
            self.seletedButton = button
            self.selectedView.backgroundColor = button.titleColor(for: .selected)
            self.selectedView.frame = CGRect(x: 0, y: self.titleScrollView.bounds.height - 2, width: button.bounds.width - self.gap, height: 2)
            self.selectedView.center.x = button.center.x
        }

        var offsetX = max(button.center.x - bounds.width * 0.5 , 0.0)
        let maxOffsetX = titleScrollView.contentSize.width - bounds.width
        offsetX = min(offsetX, maxOffsetX)
        titleScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        
        var offset = contentScrollView.contentOffset
        let index: CGFloat = CGFloat(titleScrollView.subviews.firstIndex(of: button) ?? 0)
        offset.x = index * contentScrollView.bounds.width
        contentScrollView.setContentOffset(offset, animated: true)
    }
}
extension CLTitleControllerView: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
        if !(seletedButton?.isCreated ?? true) {
            seletedButton?.isCreated = true
            let item = dataSource.titleControllerView(controllerClassAt: index)
            let controller = item.class.init()
            controller.view.frame = CGRect(x: contentScrollView.contentOffset.x, y: 0, width: contentScrollView.bounds.width, height: contentScrollView.bounds.height)
            scrollView.addSubview(controller.view)
            item.fatherController.addChild(controller)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
        if let button = titleScrollView.subviews[index] as? CLTitleControllerButton {
            clickButton(button)
        }
        scrollViewDidEndScrollingAnimation(contentScrollView)
    }
}
extension CLTitleControllerView {
    @objc private func clickButton(_ button: CLTitleControllerButton) {
        seletedButton(button, animation: true)
    }
}
