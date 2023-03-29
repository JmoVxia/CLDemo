//
//  CLPopupFoodPickerContentView.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/13.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

struct CLPopupFoodPickerContentModel {
    var title: String?
    var foodId: String?
}

class CLPopupFoodPickerContentView: UIView {
    var selectedCallback: ((CLPopupFoodPickerContentModel) -> ())?
    var dataArray = [CLPopupFoodPickerContentModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.dataSource = self
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.estimatedRowHeight = 150
        view.estimatedSectionHeaderHeight = 0
        view.estimatedSectionFooterHeight = 0
        view.contentInset = .zero
        view.contentInsetAdjustmentBehavior = .never
        if #available(iOS 13.0, *) {
            view.automaticallyAdjustsScrollIndicatorInsets = false
        }
        if #available(iOS 15.0, *) {
            view.sectionHeaderTopPadding = 0
        }
        return view
    }()
    var selectedTitle: String?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLPopupFoodPickerContentView {
    private func initUI() {
        backgroundColor = .white
        addSubview(tableView)
    }
    private func makeConstraints () {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
extension CLPopupFoodPickerContentView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CLPopupFoodPickerContentCell", for: indexPath) as! CLPopupFoodPickerContentCell
        let model = dataArray[indexPath.row]
        cell.titleLabel.text = model.title
        cell.titleLabel.textColor = model.title == selectedTitle ? .theme : .init("666666")
        return cell
    }
}
extension CLPopupFoodPickerContentView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray[indexPath.row]
        selectedTitle = model.title
        tableView.reloadData()
        selectedCallback?(model)
    }
}
