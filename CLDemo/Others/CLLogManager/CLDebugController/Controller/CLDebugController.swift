//
//  CLDebugController.swift
//  CL
//
//  Created by JmoVxia on 2020/6/5.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLDebugController: CLBaseViewController {
    private var isCanShare: Bool = false {
        didSet {
            if oldValue != isCanShare {
                if isCanShare {
                    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "分享", style: .done, target: self, action: #selector(shareItemAction))
                    navigationItem.rightBarButtonItem?.tintColor = .black
                }else {
                    navigationItem.rightBarButtonItem = nil
                }
            }
        }
    }
    private lazy var backItem: CLBackView = {
        let view = CLBackView()
        view.title = "    "
        view.addTarget(self, action: #selector(backItemAction), for: .touchUpInside)
       return view
    }()
    private lazy var dataSource: [CLChatItemProtocol] = {
        let dataSource = [CLChatItemProtocol]()
        return dataSource
    }()
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private lazy var textField: UITextField = {
        let view = UITextField()
        view.keyboardType = .numberPad
        return view
    }()
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.backgroundColor = UIColor.hexColor(with: "#FFFFFF")
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        if #available(iOS 13.0, *) {
            view.automaticallyAdjustsScrollIndicatorInsets = false
        }
        return view
    }()
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension CLDebugController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        initData()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(notification:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
extension CLDebugController {
    @objc func textDidChange(notification: Notification) {
        if let textField = notification.object as? UITextField, textField.text == "123456789" {
            DispatchQueue.main.async {
                self.contentView.isHidden = true
                self.view.endEditing(true)
            }
        }
    }
}
extension CLDebugController {
    private func initUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backItem)
        view.addSubview(tableView)
        view.addSubview(contentView)
        contentView.addSubview(textField)
    }
    private func makeConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        textField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.centerY.equalToSuperview()
        }
    }
    private func initData() {
        for path in CLLogManager.logPathArray {
            let item = CLDebugItem()
            item.path = path
            dataSource.append(item)
        }
        tableView.reloadData()
    }
}
extension CLDebugController {
    @objc func backItemAction() {
        dismiss(animated: true)
    }
    @objc func shareItemAction() {
        let fileArray = dataSource.compactMap { (item) -> URL? in
            if let debugItem = (item as? CLDebugItem), debugItem.isSelected {
                return URL(fileURLWithPath: debugItem.path)
            }else {
                return nil
            }
        }
        if !fileArray.isEmpty {
            let activity = UIActivityViewController(activityItems: fileArray, applicationActivities: nil)
            activity.completionWithItemsHandler = {[weak self, weak activity] (activityType, completed, returnedItems, activityError) in
                activity?.completionWithItemsHandler = nil
                self?.dismiss(animated: true)
            }
            present(activity, animated: true)
        }
    }
}
extension CLDebugController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource[indexPath.row] as? CLDebugItem else {
            return
        }
        item.isSelected = !item.isSelected
        tableView.reloadRows(at: [indexPath], with: .none)
        isCanShare = dataSource.first(where: {($0 as? CLDebugItem)?.isSelected == true}) != nil
    }
}
extension CLDebugController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource[indexPath.row]
        return item.dequeueReusableCell(tableView: tableView)
    }
}
