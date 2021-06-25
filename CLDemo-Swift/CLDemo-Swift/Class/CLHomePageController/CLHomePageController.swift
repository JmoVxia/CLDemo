//
//  CLHomePageController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/6/22.
//

import UIKit


//MARK: - JmoVxia---类-属性
class CLHomePageController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
    private lazy var tableViewHepler: CLTableViewHepler = {
        let hepler = CLTableViewHepler()
        return hepler
    }()
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        view.dataSource = tableViewHepler
        view.delegate = tableViewHepler
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
}
//MARK: - JmoVxia---生命周期
extension CLHomePageController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        initData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
//MARK: - JmoVxia---布局
private extension CLHomePageController {
    func initUI() {
        updateTitleLabel { label in
            label.text = "Swift".localized
        }
        view.addSubview(tableView)
    }
    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBarHeight + statusBarHeight)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
//MARK: - JmoVxia---数据
private extension CLHomePageController {
    func initData() {
        do{
            let item = CLTitleCellItem(title: "切换语言".localized, type: CLChangeLanguageController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "修改字号".localized, type: CLChangeFontSizeController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "断点续传".localized, type: CLBreakPointResumeController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "聊天框架".localized, type: CLChatController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "UITableView 多视频播放".localized, type: CLPlayVideoController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "UITableView 播放Gif".localized, type: CLPlayGifController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "抽屉效果".localized, type: CLDrawerController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "自定义转场动画".localized, type: CLCustomTransitionController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "动画按钮".localized, type: CLAnimationButtonController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "动画渐变".localized, type: CLAnimatedGradientController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "柱状图".localized, type: CLHistogramConroller.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "转盘菜单".localized, type: CLWheelMenuController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "滑动动画".localized, type: CLScrollAnimationController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "跑马灯".localized, type: CLDrawMarqueeController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "评分控件".localized, type: CLStartsController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "标签动态排布".localized, type: CLTagsController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "自定义弹窗".localized, type: CLPopupController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "游标卡尺".localized, type: CLVernierCaliperController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "翻转动画".localized, type: CLFlipController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "广播轮播".localized, type: CLBroadcastViewController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "转子动画".localized, type: CLRotateAnimationSwiftController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "自定义密码框".localized, type: CLPasswordController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "自定义输入框-限制字数".localized, type: CLTextViewViewController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "波浪视图".localized, type: CLWaveController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "气泡弹框".localized, type: CLPopoverController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "旋转图片".localized, type: CLRotatingPictureViewController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "过渡动画".localized, type: CLTransitionViewController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.dataSource.append(item)
        }
        tableView.reloadData()
    }
}
//MARK: - JmoVxia---私有方法
private extension CLHomePageController {
    func push(_ type: CLController.Type, title: String) {
        let controller = type.init()
        controller.updateTitleLabel { label in
            label.text = title
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}
