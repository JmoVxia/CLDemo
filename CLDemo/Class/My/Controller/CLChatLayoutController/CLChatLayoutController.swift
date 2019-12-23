//
//  CLChatController.swift
//  CLDemo
//
//  Created by JmoVxia on 2019/12/23.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit

class CLChatLayoutController: CLBaseViewController {
    private var dataSource = [String]()
    private lazy var tableView: CLIntrinsicTableView = {
        let tableView = CLIntrinsicTableView()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalToSuperview()
            }
        }
        addData()
        let item = UIBarButtonItem.init(title: "添加", style: .done, target: self, action: #selector(addData))
        navigationItem.rightBarButtonItem = item
    }
    @objc func addData() {
        dataSource.append("\(dataSource.count + 1)")
        reloadDataScrollToBottom()
    }
    func reloadDataScrollToBottom() {
        tableView.reloadData()
        let item = max(dataSource.count - 1, 0)
        tableView.scrollToRow(at: IndexPath(item: item, section: 0), at: .bottom, animated: false)
    }
}
extension CLChatLayoutController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    
}
