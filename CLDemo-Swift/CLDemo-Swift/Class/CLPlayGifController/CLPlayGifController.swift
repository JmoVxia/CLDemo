//
//  CLPlayGifController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/5/31.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

class CLPlayGifController: CLController {
    private lazy var tableViewHepler: CLTableViewHepler = {
        let hepler = CLTableViewHepler(delegate: self)
        return hepler
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = tableViewHepler
        tableView.delegate = tableViewHepler
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(statusBarHeight + (navigationController?.navigationBar.bounds.height ?? 0))
        }
        DispatchQueue.global().async {
            Bundle.main.paths(forResourcesOfType: "gif", inDirectory: nil).forEach { path in
                self.tableViewHepler.dataSource.append(CLPlayGifItem(path: path))
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    deinit {
        CLGifPlayer.destroy()
        CLLog("CLPlayGifController deinit")
    }
}
extension CLPlayGifController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let path = (tableViewHepler.dataSource[indexPath.row] as? CLPlayGifItem)?.path else { return }
        CLGifPlayer.cancel(path)
    }
}
