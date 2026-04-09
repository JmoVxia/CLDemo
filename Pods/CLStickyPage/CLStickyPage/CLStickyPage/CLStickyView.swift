//
//  CLStickyView.swift
//  CLStickyPage
//
//  Created by JmoVxia Chen on 2026/4/10.
//

import UIKit


// MARK: - 统一容器数据源
public protocol CLStickyViewDataSource: AnyObject {
    /// 返回页面总数。
    func numberOfPages(in stickyView: CLStickyView) -> Int

    /// 返回指定索引的页面，可为 View 页面或 Controller 页面。
    func stickyView(_ stickyView: CLStickyView, pageAt index: Int) -> CLStickyPage

    /// 返回用于托管子控制器生命周期的父控制器。
    /// 当页面包含 `CLStickyControllerPage` 时必须返回有效值。
    func parentViewController(for stickyView: CLStickyView) -> UIViewController?
}

public extension CLStickyViewDataSource {
    func parentViewController(for stickyView: CLStickyView) -> UIViewController? { nil }
}

// MARK: - 统一容器代理
public protocol CLStickyViewDelegate: AnyObject {
    /// 水平分页滚动过程回调。
    func stickyView(_ stickyView: CLStickyView, contentScrollViewDidScroll scrollView: UIScrollView, progress: CGFloat)

    /// 切页结束回调。
    func stickyView(_ stickyView: CLStickyView, didScrollToPageAt index: Int)
}

public extension CLStickyViewDelegate {
    func stickyView(_ stickyView: CLStickyView, contentScrollViewDidScroll scrollView: UIScrollView, progress: CGFloat) {}
    func stickyView(_ stickyView: CLStickyView, didScrollToPageAt index: Int) {}
}

// MARK: - 统一吸顶分页视图（支持 View / Controller 混用）
public class CLStickyView: UIView {
    /// 数据源。未设置时调用 `reload` 会触发 `preconditionFailure`。
    public weak var dataSource: CLStickyViewDataSource?

    /// 代理。
    public weak var delegate: CLStickyViewDelegate?

    /// 是否启用懒加载（只读）。
    public var isLazyLoadingEnabled: Bool { isLazyLoading }

    /// 头部视图。
    public var headerView: UIView? {
        get { pagerView.headerView }
        set { pagerView.headerView = newValue }
    }

    /// 悬停视图。
    public var hoverView: UIView? {
        get { pagerView.hoverView }
        set { pagerView.hoverView = newValue }
    }

    /// body 区域背景视图。
    public var backgroundView: UIView? {
        get { pagerView.backgroundView }
        set { pagerView.backgroundView = newValue }
    }

    /// `hoverView` 进入悬浮态后距离容器顶部的预留距离。
    public var hoverStickyTopInset: CGFloat {
        get { pagerView.hoverStickyTopInset }
        set { pagerView.hoverStickyTopInset = newValue }
    }

    /// 是否显示滚动条。
    public var showIndicator: Bool {
        get { pagerView.showIndicator }
        set { pagerView.showIndicator = newValue }
    }

    /// 是否允许横向分页滚动。
    public var isHorizontalScrollEnabled: Bool {
        get { pagerView.isHorizontalScrollEnabled }
        set { pagerView.isHorizontalScrollEnabled = newValue }
    }

    /// 当前页索引（支持 get/set）。
    public var currentPageIndex: Int {
        get { pagerView.currentPageIndex }
        set { scrollToPage(at: newValue, animated: false) }
    }

    /// 当前总页数（只读）。
    public var numberOfPages: Int {
        pagerView.numberOfPages
    }

    /// 当前页对象（懒加载模式下仅已创建页面可获取）。
    public var currentPage: CLStickyPage? {
        page(at: currentPageIndex)
    }

    /// 当前页控制器（当前页为 Controller 模式时可获取）。
    public var currentController: CLStickyControllerPage? {
        guard let visibleControllerIndex else { return nil }
        return controllerHosts[visibleControllerIndex]?.controller
    }

    private let isLazyLoading: Bool
    private let pagerView: CLStickyPageView
    private weak var parentViewController: UIViewController?
    private var pageCache: [Int: CLStickyPage] = [:]
    private var pageAdapters: [Int: CLStickyViewPage] = [:]
    private var controllerHosts: [Int: CLStickyPagerHostView] = [:]
    private var visibleControllerIndex: Int?
    private var isAttachedToWindow = false
    private var pendingScrollAnimated: Bool?

    /// 初始化。
    /// - Parameters:
    ///   - frame: 初始 frame。
    ///   - isLazyLoading: 是否懒加载，默认 `true`。
    public init(frame: CGRect = .zero, isLazyLoading: Bool = true) {
        self.isLazyLoading = isLazyLoading
        pagerView = CLStickyPageView(frame: .zero, isLazyLoading: isLazyLoading)
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        tearDownControllerHosts()
    }

    public override func didMoveToWindow() {
        super.didMoveToWindow()

        let nowAttached = window != nil
        guard nowAttached != isAttachedToWindow else { return }
        isAttachedToWindow = nowAttached

        guard let visibleControllerIndex, let host = controllerHosts[visibleControllerIndex] else { return }
        host.setAppeared(nowAttached, animated: false)
    }
}

// MARK: - 统一容器公共方法
public extension CLStickyView {
    /// 重新加载页面，并可指定重载后的目标页。
    /// - Parameter index: 目标索引。传 `nil` 时沿用内部默认策略。
    func reload(toPageAt index: Int? = nil) {
        guard let dataSource else {
            preconditionFailure("CLStickyView: 请先设置 dataSource")
        }

        parentViewController = dataSource.parentViewController(for: self)
        tearDownControllerHosts()
        pageCache.removeAll()
        pageAdapters.removeAll()
        pagerView.reload(toPageAt: index)

        if pagerView.numberOfPages > 0 {
            updateVisibleController(to: pagerView.currentPageIndex, animated: false)
        } else {
            updateVisibleController(to: nil, animated: false)
        }
    }

    /// 滚动到指定页。
    /// - Parameters:
    ///   - index: 目标索引。
    ///   - animated: 是否动画滚动。
    func scrollToPage(at index: Int, animated: Bool) {
        pendingScrollAnimated = animated
        pagerView.scrollToPage(at: index, animated: animated)

        guard !animated, !isLazyLoading, pagerView.numberOfPages > 0 else { return }

        pendingScrollAnimated = nil
        let clampedIndex = min(max(index, 0), pagerView.numberOfPages - 1)
        updateVisibleController(to: clampedIndex, animated: false)
        delegate?.stickyView(self, didScrollToPageAt: clampedIndex)
    }

    /// 获取指定索引的页面（懒加载模式下仅已创建页面可获取）。
    func page(at index: Int) -> CLStickyPage? {
        guard index >= 0, index < pagerView.numberOfPages else { return nil }
        return pageCache[index]
    }
}

// MARK: - 统一容器内部逻辑
private extension CLStickyView {
    func setupUI() {
        pagerView.dataSource = self
        pagerView.delegate = self

        addSubview(pagerView)
        pagerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func tearDownControllerHosts() {
        if isAttachedToWindow, let visibleControllerIndex, let visibleHost = controllerHosts[visibleControllerIndex] {
            visibleHost.setAppeared(false, animated: false)
        }

        visibleControllerIndex = nil
        controllerHosts.values.forEach { $0.uninstall() }
        controllerHosts.removeAll()
    }

    func updateVisibleController(to rawIndex: Int?, animated: Bool) {
        let targetIndex: Int?
        if let rawIndex, pagerView.numberOfPages > 0 {
            targetIndex = min(max(rawIndex, 0), pagerView.numberOfPages - 1)
        } else {
            targetIndex = nil
        }

        let targetHost = targetIndex.flatMap { controllerHostIfController(at: $0) }
        let resolvedTargetIndex = targetHost == nil ? nil : targetIndex

        guard resolvedTargetIndex != visibleControllerIndex else { return }

        let previousHost = visibleControllerIndex.flatMap { controllerHosts[$0] }
        if isAttachedToWindow {
            previousHost?.setAppeared(false, animated: animated)
            targetHost?.setAppeared(true, animated: animated)
        } else {
            previousHost?.setAppeared(false, animated: false)
        }

        visibleControllerIndex = resolvedTargetIndex
    }

    func stickyPage(at index: Int) -> CLStickyPage {
        if let cached = pageCache[index] {
            return cached
        }

        guard let dataSource else {
            preconditionFailure("CLStickyView: 请先设置 dataSource")
        }

        let page = dataSource.stickyView(self, pageAt: index)
        pageCache[index] = page
        return page
    }

    func adaptedPage(at index: Int) -> CLStickyViewPage {
        if let adapted = pageAdapters[index] {
            return adapted
        }

        let page = stickyPage(at: index)
        if let viewPage = page as? CLStickyViewPage {
            pageAdapters[index] = viewPage
            return viewPage
        }

        guard page is CLStickyControllerPage else {
            preconditionFailure("CLStickyView: pageAt: 返回值必须实现 CLStickyViewPage 或 CLStickyControllerPage")
        }

        guard let host = controllerHostIfController(at: index) else {
            preconditionFailure("CLStickyView: Controller 页面托管失败")
        }

        pageAdapters[index] = host
        return host
    }

    func controllerHostIfController(at index: Int) -> CLStickyPagerHostView? {
        if let host = controllerHosts[index] {
            if let parentViewController = resolvedParentViewController() {
                host.installIfNeeded(in: parentViewController)
            }
            return host
        }

        guard let controller = pageCache[index] as? CLStickyControllerPage else { return nil }
        guard let parentViewController = resolvedParentViewController() else {
            preconditionFailure("CLStickyView: 当前包含 Controller 页面，请在 dataSource 中提供 parentViewController(for:)")
        }

        let host = CLStickyPagerHostView(controller: controller)
        host.installIfNeeded(in: parentViewController)
        controllerHosts[index] = host
        return host
    }

    func resolvedParentViewController() -> UIViewController? {
        if let parentViewController {
            return parentViewController
        }

        guard let dataSource else { return nil }
        let resolvedParent = dataSource.parentViewController(for: self)
        parentViewController = resolvedParent
        return resolvedParent
    }
}

// MARK: - CLStickyPageViewDataSource
extension CLStickyView: CLStickyPageViewDataSource {
    public func numberOfPages(in pageView: CLStickyPageView) -> Int {
        dataSource?.numberOfPages(in: self) ?? 0
    }

    public func pageView(_ pageView: CLStickyPageView, pageAt index: Int) -> CLStickyViewPage {
        adaptedPage(at: index)
    }
}

// MARK: - CLStickyPageViewDelegate
extension CLStickyView: CLStickyPageViewDelegate {
    public func pageView(_ pageView: CLStickyPageView, contentScrollViewDidScroll scrollView: UIScrollView, progress: CGFloat) {
        delegate?.stickyView(self, contentScrollViewDidScroll: scrollView, progress: progress)
    }

    public func pageView(_ pageView: CLStickyPageView, didScrollToPageAt index: Int) {
        let animated = pendingScrollAnimated ?? true
        pendingScrollAnimated = nil

        if index >= 0 {
            _ = adaptedPage(at: index)
            updateVisibleController(to: index, animated: animated)
            delegate?.stickyView(self, didScrollToPageAt: index)
        } else {
            updateVisibleController(to: nil, animated: false)
        }
    }
}

