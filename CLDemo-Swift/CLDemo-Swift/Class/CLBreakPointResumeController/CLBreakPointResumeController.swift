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
        view.contentInset = .init(top: 0, left: 0, bottom: safeAreaEdgeInsets.bottom, right: 0)
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        let urls = [
            "https://down.sandai.net/mac/thunder_5.20.1.66132.dmg",
            "https://dldir1.qq.com/qqtv/mac/TencentVideo2.85.2.54044.dmg",
            "https://static-d.iqiyi.com/ext/common/iQIYIMedia_271.dmg",
            "https://res.126.net/dl/client/macmail/dashi/mailmaster.dmg?spm=pos.free_webmail_9c89159b6fde1dc2.loginPage.login163Page.header.nav&from=mail340&resolution=2048x1152&os=Mac%20OS&fromDlpro=1&device_id=5217d21942152b6aa6739b9404c4b41e_v1&uuid=3b3e455a-c3cc-48f6-8b6a-3ccf7f72a16f&uid=&scene=appTrack&action=banner_mac_dl&device=desktop&product=mailmac&dltype=site&os_version=10.15.7&session_id=CF149B83-E3AE-4581-8E47-60C378747DBF",
            "https://cdn.aliyundrive.net/downloads/apps/desktop/aDrive-4.11.0.dmg?spm=aliyundrive.index.0.0.7db16f60K7MGLB&file=aDrive-4.11.0.dmg",
            "https://08284b-987279547.antpcdn.com:19001/b/pkg-ant.baidu.com/issue/netdisk/MACguanjia/4.29.5/BaiduNetdisk_mac_4.29.5_x64.dmg",
            "https://dldir1.qq.com/qqtv/mac/TencentVideo_V2.21.0.52979.dmg",
            "https://dldir1.qq.com/qqtv/mac/TencentVideo_V2.21.0.52979.dmg",
            "https://package.mac.wpscdn.cn/mac_wps_pkg/3.7.0/WPS_Office_3.7.0(5920).dmg",
            "https://dldir1.qq.com/qqfile/QQforMac/QQCatalyst/QQ_8.4.10.118.dmg",
            "https://d1.music.126.net/dmusic/NeteaseMusic_2.3.5_852_web.dmg",
            "https://down.sandai.net/mac/thunder_4.0.1.14502.dmg",
            "https://down.sandai.net/mac/player_3.0.1.12449.dmg",
            "https://dldir1.qq.com/weixin/mac/WeChatMac.dmg",
        ]

        for url in urls {
            let item = CLBreakPointResumeItem(url: URL(string: url)!)
            item.downloadCallback = { [weak self] file in
                self?.download(file)
            }
            item.cancelCallback = { file in
                CLBreakPointResumeManager.cancel(file)
            }
            item.deleteCallback = { [weak self] file in
                self?.delete(file)
            }
            tableViewHepler.rows.append(item)
        }
        tableView.reloadData()
    }

    func download(_ url: URL) {
        CLBreakPointResumeManager.download(url) { [weak self] downloadURL, progress in
            let rows = self?.tableViewHepler.rows.filter { ($0 as? CLBreakPointResumeItem)?.url == downloadURL } as? [CLBreakPointResumeItem]
            rows?.forEach { $0.progress = progress }
        } completionBlock: { result in
            result.failure { error in
                CLLog("下载失败,error:\(error)")
            }.success { path in
                CLLog("下载成功,path:\(path)")
            }
        }
    }

    func delete(_ url: URL) {
        try? CLBreakPointResumeManager.delete(url)
        let rows = tableViewHepler.rows.filter { ($0 as? CLBreakPointResumeItem)?.url == url } as? [CLBreakPointResumeItem]
        rows?.forEach { $0.progress = 0 }
    }
}
