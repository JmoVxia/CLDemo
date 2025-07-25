//
//  CLNestedSlideController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2024/7/3.
//

import CLNestedSlide
import UIKit

class CLNestedSlideController: CLController {
    // MARK: - UI 组件

    private lazy var nestedSlideView: CLNestedSlideView = {
        let view = CLNestedSlideView(isLazyLoading: false)
        view.dataSource = self
        view.delegate = self
        return view
    }()

    /// 顶部渐变卡片头部
    private lazy var headerView: UIView = {
        let v = UIView()
        v.backgroundColor = .orange.withAlphaComponent(0.35)
        // 主标题
        let titleLabel = UILabel()
        titleLabel.text = "CLNestedSlide Demo"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        // 副标题
        let subtitleLabel = UILabel()
        subtitleLabel.text = "专业级嵌套滑动演示"
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textAlignment = .center
        v.addSubview(titleLabel)
        v.addSubview(subtitleLabel)
        titleLabel.snp.makeConstraints { make in make.centerX.equalToSuperview(); make.top.equalToSuperview().offset(48) }
        subtitleLabel.snp.makeConstraints { make in make.centerX.equalToSuperview(); make.top.equalTo(titleLabel.snp.bottom).offset(8) }
        return v
    }()

    /// 毛玻璃分段栏
    private lazy var segmentedBar: CLSegmentedBar = {
        let bar = CLSegmentedBar()
        bar.setTitles(["首页", "发现", "我的", "设置"])
        bar.onSelect = { [weak self] index in self?.nestedSlideView.scrollToPage(at: index, animated: true) }
        return bar
    }()

    /// 页面数据
    private let pageData: [(String, String, UIColor)] = [
        ("首页", "这里是首页内容\n可以展示主要功能", .systemGreen),
        ("发现", "这里是发现页面\n可以浏览新内容", .systemBlue),
        ("我的", "这里是个人中心\n管理个人信息", .systemOrange),
        ("设置", "这里是设置页面\n配置应用选项", .systemPurple),
    ]

    // MARK: - 生命周期

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 245 / 255, green: 247 / 255, blue: 251 / 255, alpha: 1)
        setupUI()
    }

    /// UI布局
    private func setupUI() {
        view.addSubview(nestedSlideView)
        nestedSlideView.snp.makeConstraints { make in make.edges.equalTo(view.safeAreaLayoutGuide) }
        headerView.snp.makeConstraints { make in make.height.equalTo(240) }
        segmentedBar.snp.makeConstraints { make in make.height.equalTo(60) }
        nestedSlideView.headerView = headerView
        nestedSlideView.hoverView = segmentedBar
        nestedSlideView.reload()
    }
}

extension CLNestedSlideController: CLNestedSlideViewDataSource {
    func numberOfPages(in nestedSlideView: CLNestedSlideView) -> Int { pageData.count }
    func nestedSlideView(_ nestedSlideView: CLNestedSlideView, pageFor index: Int) -> CLNestedSlideViewPage {
        CLPageView()
    }
}

extension CLNestedSlideController: CLNestedSlideViewDelegate {
    func contentScrollViewDidScroll(_ nestedSlideView: CLNestedSlideView, scrollView: UIScrollView, progress: CGFloat) {
        let currentIndex = Int(progress.rounded())
        let clampedIndex = min(max(currentIndex, 0), pageData.count - 1)
        let offset = progress - CGFloat(clampedIndex)
        segmentedBar.updateIndicatorWithOffset(baseIndex: clampedIndex, offset: offset)
        segmentedBar.updateTitleColorWithProgress(baseIndex: clampedIndex, offset: offset)
    }

    func contentScrollViewDidScrollToPage(at index: Int) {
        segmentedBar.setSelectedIndex(index)
    }
}
