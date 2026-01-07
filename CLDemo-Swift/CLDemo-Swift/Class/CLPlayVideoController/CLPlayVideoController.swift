//
//  CLPlayVideoController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/4/28.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

class CLPlayVideoController: CLController {
    private lazy var tableViewRowManager = CLTableViewRowManager()

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.dataSource = tableViewRowManager
        view.delegate = tableViewRowManager
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
            let allPaths = Bundle.main.paths(forResourcesOfType: "mp4", inDirectory: nil)
            let items = [[String]](repeating: allPaths, count: 5).flatMap { $0 }.shuffled().map { CLPlayVideoitem(url: URL(fileURLWithPath: $0)) }
            self.tableViewRowManager.dataSource.append(contentsOf: items)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    deinit {
        CLVideoPlayer.destroy()
    }
}
