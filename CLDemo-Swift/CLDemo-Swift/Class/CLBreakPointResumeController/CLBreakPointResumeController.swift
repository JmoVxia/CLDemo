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
        title = "最大并发3"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(statusBarHeight + (navigationController?.navigationBar.bounds.height ?? 0))
        }
        do {
            let item = CLBreakPointResumeItem(url: URL(string: "https://dldir1.qq.com/qqtv/mac/TencentVideo_V2.21.0.52979.dmg")!)
            tableViewHepler.rows.append(item)
        }
        do {
            let item = CLBreakPointResumeItem(url: URL(string: "https://package.mac.wpscdn.cn/mac_wps_pkg/3.7.0/WPS_Office_3.7.0(5920).dmg")!)
            tableViewHepler.rows.append(item)
        }
        do {
            let item = CLBreakPointResumeItem(url: URL(string: "https://dldir1.qq.com/qqfile/QQforMac/QQCatalyst/QQ_8.4.10.118.dmg")!)
            tableViewHepler.rows.append(item)
        }
        do {
            let item = CLBreakPointResumeItem(url: URL(string: "https://d1.music.126.net/dmusic/NeteaseMusic_2.3.5_852_web.dmg")!)
            tableViewHepler.rows.append(item)
        }
        do {
            let item = CLBreakPointResumeItem(url: URL(string: "https://down.sandai.net/mac/thunder_4.0.1.14502.dmg")!)
            tableViewHepler.rows.append(item)
        }
        do {
            let item = CLBreakPointResumeItem(url: URL(string: "https://down.sandai.net/mac/player_3.0.1.12449.dmg")!)
            tableViewHepler.rows.append(item)
        }
        do {
            let item = CLBreakPointResumeItem(url: URL(string: "https://dldir1.qq.com/weixin/mac/WeChatMac.dmg")!)
            tableViewHepler.rows.append(item)
        }
        tableView.reloadData()
    }
}
