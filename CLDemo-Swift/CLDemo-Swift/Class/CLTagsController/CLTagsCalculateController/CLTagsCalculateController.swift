//
//  CLTagsCalculateController.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/2.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLTagsCalculateController: CLController {
    lazy var arrayDS: [CLTagsItem] = {
        let arrayDS = [CLTagsItem]()
        return arrayDS
    }()

    lazy var tableview: UITableView = {
        let tableview = UITableView()
        tableview.separatorStyle = .none
        tableview.register(CLTagsCell.classForCoder(), forCellReuseIdentifier: "CLTagsCell")
        tableview.dataSource = self
        tableview.delegate = self
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        initDate()
    }

    func initDate() {
        let array = ["风格", "童年", "紫府东风放夜时", "步莲秾李伴人归", "东风吹碧草，年华换、行客老沧洲", "书", "偷影子的人", "见梅吐旧英", "儒家学派的经典著", "道德观念", "挪威的森林", "书中故事", "了不起的盖茨比", "孤独", "受益匪浅", "回忆都淡了", "谁知道", "呵呵", "历史", "谁", "世家", "谁到人归途", "上吞巴汉控潇湘，怒似连山静镜光", "步莲秾李伴人归", "东风吹碧草，年华换、行客老沧洲", "见梅吐旧英", "儒家学派的经典著", "道德观念", "挪威的森林", "书中故事", "了不起的盖茨比", "孤独", "受益匪浅", "回忆都淡了", "谁知道", "呵呵", "历史", "谁", "世家", "谁到人归途", "山有木兮木有枝，心悦君兮君不知", "极目楚天空，云雨无踪，漫留遗恨锁眉峰。自是荷花开较晚，孤负东风"]
        let maxWidth: CGFloat = screenWidth - safeAreaEdgeInsets.left - safeAreaEdgeInsets.right
        DispatchQueue.global().async {
            self.arrayDS.removeAll()
            for _ in array {
                guard let date = array.sample(size: max(Int(arc4random_uniform(UInt32(array.count))), 1)) else {
                    return
                }
                let item = CLTagsItem(with: date, maxWidth: maxWidth, tagsMinPadding: 10, isAlignment: date.count % 2 == 0)
                self.arrayDS.append(item)
            }
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
    }
}

extension CLTagsCalculateController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayDS.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = arrayDS[indexPath.row]
        return item.tagsHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CLTagsCell", for: indexPath)
        if let cell = cell as? CLTagsCell {
            cell.tagsItem = arrayDS[indexPath.row]
        }
        return cell
    }
}

extension CLTagsCalculateController: UITableViewDelegate {}

extension CLTagsCalculateController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.initDate()
        }, completion: nil)
    }
}
