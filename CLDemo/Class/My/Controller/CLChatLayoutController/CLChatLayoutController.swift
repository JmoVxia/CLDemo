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
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
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
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let contentHeight = self.tableView.sizeThatFits(CGSize(width: self.view.frame.width, height: CGFloat(INT64_MAX))).height
            let insetsTop = max(self.tableView.frame.height - contentHeight, 0.0)
            let oldHeight = self.tableView.contentInset.top
            if oldHeight != insetsTop {
                self.tableView.contentInset = UIEdgeInsets(top: insetsTop, left: 0, bottom: 0, right: 0)
                if self.tableView.frame.height - contentHeight > 0 {
                    self.tableView.contentSize = CGSize(width: self.tableView.frame.width, height: 0)
                }
            }
            let item = max(self.dataSource.count - 1, 0)
            self.tableView.scrollToRow(at: IndexPath(item: item, section: 0), at: .bottom, animated: false)
        }
    }
}
extension CLChatLayoutController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = UIColor.randomColor
        return cell
    }
    
    
}
