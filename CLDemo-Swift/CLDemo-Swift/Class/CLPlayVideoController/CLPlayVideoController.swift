//
//  CLPlayVideoController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/4/28.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

class CLPlayVideoController: CLController {
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
            Bundle.main.paths(forResourcesOfType: "mp4", inDirectory: nil).forEach { path in
                self.tableViewHepler.dataSource.append(CLPlayVideoitem(path: path))
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    deinit {
        CLLog("CLPlayVideoController deinit")
        CLVideoPlayer.destroy()
    }
}
extension CLPlayVideoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let path = (tableViewHepler.dataSource[indexPath.row] as? CLPlayVideoitem)?.path else { return }
        CLVideoPlayer.cancel(path)
    }
}
