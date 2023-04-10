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
        let view = UITableView(frame: .zero, style: .plain)
        view.dataSource = tableViewHepler
        view.delegate = tableViewHepler
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(statusBarHeight + (navigationController?.navigationBar.bounds.height ?? 0))
        }
        DispatchQueue.global().async {
            Bundle.main.paths(forResourcesOfType: "mp4", inDirectory: nil).forEach { path in
                self.tableViewHepler.rows.append(CLPlayVideoitem(path: path))
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
        guard let path = (tableViewHepler.rows[indexPath.row] as? CLPlayVideoitem)?.path else { return }
        CLVideoPlayer.cancel(path)
    }
}
