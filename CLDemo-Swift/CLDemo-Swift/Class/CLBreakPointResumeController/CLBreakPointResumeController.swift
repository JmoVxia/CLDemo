//
//  CLBreakPointResumeController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/6/10.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

class CLBreakPointResumeController: CLController {
    private lazy var tableViewHepler: CLTableViewHepler = {
        let hepler = CLTableViewHepler()
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
        title = "最大并发3"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(statusBarHeight + (navigationController?.navigationBar.bounds.height ?? 0))
        }
        do {
            let item = CLBreakPointResumeItem(url: URL(string: "https://dldir1.qq.com/qqtv/mac/TencentVideo_V2.21.0.52979.dmg")!)
            tableViewHepler.dataSource.append(item)
        }
        do {
            let item = CLBreakPointResumeItem(url: URL(string: "https://package.mac.wpscdn.cn/mac_wps_pkg/3.7.0/WPS_Office_3.7.0(5920).dmg")!)
            tableViewHepler.dataSource.append(item)
        }
        do {
            let item = CLBreakPointResumeItem(url: URL(string: "https://dldir1.qq.com/qqfile/QQforMac/QQCatalyst/QQ_8.4.10.118.dmg")!)
            tableViewHepler.dataSource.append(item)
        }
        do {
            let item = CLBreakPointResumeItem(url: URL(string: "https://d1.music.126.net/dmusic/NeteaseMusic_2.3.5_852_web.dmg")!)
            tableViewHepler.dataSource.append(item)
        }
        do {
            let item = CLBreakPointResumeItem(url: URL(string: "https://down.sandai.net/mac/thunder_4.0.1.14502.dmg")!)
            tableViewHepler.dataSource.append(item)
        }
        do {
            let item = CLBreakPointResumeItem(url: URL(string: "https://down.sandai.net/mac/player_3.0.1.12449.dmg")!)
            tableViewHepler.dataSource.append(item)
        }
        do {
            let item = CLBreakPointResumeItem(url: URL(string: "https://dldir1.qq.com/weixin/mac/WeChatMac.dmg")!)
            tableViewHepler.dataSource.append(item)
        }
        tableView.reloadData()
    }
}
