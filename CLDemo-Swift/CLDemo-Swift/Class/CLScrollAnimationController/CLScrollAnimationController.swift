//
//  CLScrollAnimationController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/8/18.
//  Copyright © 2020 JmoVxia. All rights reserved.
//


//from https://github.com/YouXianMing/Animations


import UIKit

class CLScrollAnimationController: CLController {
    private var dataSouce = [(imageView: UIImageView, value: CLScrollComputingValue)]()
    private var page: Int = 0 {
        didSet {
            scrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(page), height: view.bounds.height)
        }
    }
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.bounces = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        return view
    }()
}
extension CLScrollAnimationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        page = 5
        for item in 0..<page {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: String(format: "%d", item))
            imageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            imageView.alpha = item == 0 ? 1.0 : 0.0
            view.insertSubview(imageView, at: 0)
            let value = CLScrollComputingValue(startValue: CGFloat(item - 1) * view.bounds.width, midValue: CGFloat(item) * view.bounds.width, endValue: CGFloat(item + 1) * view.bounds.width)
            dataSouce.append((imageView, value))
        }
    }
}
extension CLScrollAnimationController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for item in dataSouce {
            item.imageView.alpha = item.value.outputValue(scrollView.contentOffset.x)
        }
    }
}
