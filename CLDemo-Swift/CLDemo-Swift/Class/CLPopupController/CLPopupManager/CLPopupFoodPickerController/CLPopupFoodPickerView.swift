//
//  CLPopupFoodPickerView.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/13.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import SwiftyJSON

class CLPopupFoodPickerView: UIView {
    var selectedCallback: ((String, String, String, String)->())?
    var foodModel: CLPopupFoodPickerModel?
    private var selectedCount: Int = 0
    private var buttonArray = [UIButton]()
    private var topButtonArray = [UIButton]()
    private var tableViewArray = [CLPopupFoodPickerContentView]()
    private lazy var clipView: UIView = {
        let clipView = UIView()
        clipView.backgroundColor = UIColor.clear
        clipView.clipsToBounds = true
        return clipView
    }()
    private lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .themeColor
        return lineView
    }()
    private lazy var showView: UIView = {
        let showView = UIView()
        showView.backgroundColor = UIColor.clear
        return showView
    }()
    private lazy var contentView: UIScrollView = {
        let contentView = UIScrollView()
        contentView.showsHorizontalScrollIndicator = false
        contentView.showsVerticalScrollIndicator = false
        contentView.isPagingEnabled = true
        contentView.delegate = self
        contentView.bounces = false
        if #available(iOS 11.0, *) {
            contentView.contentInsetAdjustmentBehavior = .never
        }
        return contentView
    }()

    private var seleceButton: UIButton!
    private var seleceTopButton: UIButton!
    private var lastOffsetX: CGFloat = 0.0
    private var lastX: CGFloat = 0.0
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        initData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLPopupFoodPickerView {
    func initData() {
        DispatchQueue.global().async {
            let path = Bundle.main.path(forResource: "food", ofType: "json")
            let url = URL(fileURLWithPath: path!)
            if let data = try? Data(contentsOf: url) {
                self.foodModel = CLPopupFoodPickerModel.init(json: JSON(data))
                DispatchQueue.main.async {
                    self.refreshTableView(index: 0)
                }
            }
        }
    }
    private func initUI() {
        let width: CGFloat = (frame.width) / 3.0
        let height: CGFloat = 40;
        var lastButton: UIButton?
        for i in 0...2 {
            let button = creatButton(title: "请选择", titleColor: .hex("#333333"))
            button.isHidden = i > 0
            button.addTarget(self, action: #selector(buttonClickAction(_:)), for: .touchUpInside)
            addSubview(button)
            let x: CGFloat = lastButton?.frame.maxX ?? 0
            button.setNewFrame(CGRect(x: x, y: 0, width: width, height: height))
            lastButton = button
            buttonArray.append(button)
            
            let topButton = creatButton(title: "请选择", titleColor: .themeColor)
            topButton.isHidden = button.isHidden
            topButton.isUserInteractionEnabled = false
            topButton.setNewFrame(button.frame)
            showView.addSubview(topButton)
            topButtonArray.append(topButton)
        }
        
        addSubview(contentView)
        contentView.setNewFrame(CGRect(x: 0, y: height, width: frame.width, height: frame.height - height))
        contentView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)

        seleceButton(buttonArray.first!)

        addSubview(clipView)
        clipView.setNewFrame(seleceButton.frame)
        
        clipView.addSubview(showView)
        showView.setNewFrame(CGRect(x: 0, y: 0, width: frame.width, height: height))
        
        clipView.addSubview(lineView)
        lineView.setNewFrame(CGRect(x: clipView.frame.width * 0.2, y: clipView.frame.height - 2, width: clipView.frame.width * 0.6, height: 2))
    }
    private func seleceButton(_ button: UIButton) {
        if seleceButton != button {
            seleceButton = button
            let index = buttonArray.firstIndex(of: seleceButton) ?? 0
            seleceTopButton = topButtonArray[index]
            seleceButton.isHidden = false
            seleceTopButton.isHidden = false
            for (i, item) in buttonArray.enumerated() {
                if i > index {
                    item.setTitle("请选择", for: .normal)
                    item.setTitle("请选择", for: .selected)
                    item.isHidden = true
                    topButtonArray[i].setTitle("请选择", for: .normal)
                    topButtonArray[i].setTitle("请选择", for: .selected)
                    topButtonArray[i].isHidden = true
                    if tableViewArray.count > i {
                        tableViewArray[i].selectedTitle = nil
                    }
                }
            }
            contentView.contentSize = CGSize(width: contentView.frame.width * CGFloat(index + 1), height: contentView.frame.height)
            contentView.setContentOffset(CGPoint(x: CGFloat(index) * frame.width, y: 0), animated: true)
            if !seleceButton.isSelected {
                let view = CLPopupFoodPickerContentView()
                view.selectedCallback = {[weak self](data) in
                    self?.refreshTableView(model: data, index: index + 1)
                }
                view.frame = CGRect(x: CGFloat(index) * contentView.frame.width, y: 0, width: contentView.frame.width, height: contentView.frame.height);
                contentView.addSubview(view)
                button.isSelected = true
                tableViewArray.append(view)
            }
        }
    }
    private func refreshTableView(model: CLPopupFoodPickerContentModel? = nil, index: Int) {
        let name = model?.title ?? "请选择"
        seleceButton.setTitle(name, for: .normal)
        seleceButton.setTitle(name, for: .selected)
        seleceTopButton.setTitle(name, for: .normal)
        seleceTopButton.setTitle(name, for: .selected)
        if index < buttonArray.count {
            let button = buttonArray[index]
            seleceButton(button)
        }else {
            guard let frist = buttonArray[0].titleLabel?.text, let second = buttonArray[1].titleLabel?.text, let third = buttonArray[2].titleLabel?.text, let foodId = model?.foodId else {
                return
            }
            selectedCallback?(frist, second, third, foodId)
        }
        if index == 0 {
            guard let group = foodModel?.baseGroup else {
                return
            }
            let modelArray = group.map({ (baseGroun) -> CLPopupFoodPickerContentModel in
                return CLPopupFoodPickerContentModel(title: baseGroun.foodBaseGroupName)
            })
            tableViewArray[index].dataArray = modelArray
        }else if index == 1 {
            guard let group = foodModel?.baseGroup.first(where: { (baseGroup) -> Bool in
                return baseGroup.foodBaseGroupName == buttonArray[0].titleLabel?.text
            })else {
                return
            }
            let modelArray = group.group.map({ (baseGroun) -> CLPopupFoodPickerContentModel in
                return CLPopupFoodPickerContentModel(title: baseGroun.foodGroupName)
            })
            tableViewArray[index].dataArray = modelArray
        }else if index == 2 {
            guard let group = foodModel?.baseGroup.first(where: { (baseGroup) -> Bool in
                return baseGroup.foodBaseGroupName == buttonArray[0].titleLabel?.text
            })else {
                return
            }
            guard let foodGroup = group.group.first(where: { (group) -> Bool in
                return group.foodGroupName == buttonArray[1].titleLabel?.text
            }) else {
                return
            }
            let modelArray = foodGroup.foods.map({ (baseGroun) -> CLPopupFoodPickerContentModel in
                return CLPopupFoodPickerContentModel(title: baseGroun.foodName, foodId: baseGroun.foodId)
            })
            tableViewArray[index].dataArray = modelArray
        }
    }
    private func creatButton(title: String, titleColor: UIColor) -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.setTitle(title, for: .normal)
        button.setTitle(title, for: .selected)
        button.setTitleColor(titleColor, for: .selected)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = PingFangSCBold(16)
        return button
    }
}
extension CLPopupFoodPickerView {
    @objc private func buttonClickAction(_ button: UIButton) {
        seleceButton(button)
    }
}
extension CLPopupFoodPickerView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = ((scrollView.contentOffset.x - lastOffsetX) / scrollView.frame.width) * clipView.frame.width + lastX
        clipView.setNewFrame(CGRect(x: min(max(x, 0), scrollView.frame.width - clipView.frame.width), y: clipView.frame.minY, width: clipView.frame.width, height: clipView.frame.height))
        showView.setNewFrame(CGRect(x: -min(max(x, 0), scrollView.frame.width - clipView.frame.width), y: showView.frame.minY, width: showView.frame.width, height: showView.frame.height))
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
        seleceButton(buttonArray[index])
        lastOffsetX = scrollView.contentOffset.x
        lastX = seleceButton.frame.minX
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
}
