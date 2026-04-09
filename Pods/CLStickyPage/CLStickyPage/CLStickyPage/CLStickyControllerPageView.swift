import UIKit
import SnapKit


// MARK: - 控制器容器数据源
public protocol CLStickyControllerPageViewDataSource: AnyObject {
    /// 返回页面总数。
    func numberOfPages(in controllerPageView: CLStickyControllerPageView) -> Int

    /// 返回指定索引的页面控制器。
    func controllerPageView(_ controllerPageView: CLStickyControllerPageView, pageControllerAt index: Int) -> CLStickyControllerPage

    /// 返回用于托管子控制器生命周期的父控制器。
    func parentViewController(for controllerPageView: CLStickyControllerPageView) -> UIViewController
}

// MARK: - 控制器容器代理
public protocol CLStickyControllerPageViewDelegate: AnyObject {
    /// 水平分页滚动过程回调。
    func controllerPageView(_ controllerPageView: CLStickyControllerPageView, contentScrollViewDidScroll scrollView: UIScrollView, progress: CGFloat)

    /// 切页结束回调。
    func controllerPageView(_ controllerPageView: CLStickyControllerPageView, didScrollToPageAt index: Int)
}

public extension CLStickyControllerPageViewDelegate {
    func controllerPageView(_ controllerPageView: CLStickyControllerPageView, contentScrollViewDidScroll scrollView: UIScrollView, progress: CGFloat) {}
    func controllerPageView(_ controllerPageView: CLStickyControllerPageView, didScrollToPageAt index: Int) {}
}

// MARK: - 控制器版吸顶分页视图
public final class CLStickyControllerPageView: UIView {
    /// 数据源。未设置时调用 `reload` 会触发 `preconditionFailure`。
    public weak var dataSource: CLStickyControllerPageViewDataSource?

    /// 代理。
    public weak var delegate: CLStickyControllerPageViewDelegate?

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

    /// 当前页控制器（懒加载模式下仅已创建页面可获取）。
    public var currentController: CLStickyControllerPage? {
        pageHosts[currentPageIndex]?.controller
    }

    private let isLazyLoading: Bool
    private let pagerView: CLStickyPageView
    private weak var parentViewController: UIViewController?
    private var pageHosts: [Int: CLStickyPagerHostView] = [:]
    private var visibleIndex: Int?
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
        tearDownPageHosts()
    }

    public override func didMoveToWindow() {
        super.didMoveToWindow()

        let nowAttached = window != nil
        guard nowAttached != isAttachedToWindow else { return }
        isAttachedToWindow = nowAttached

        guard let visibleIndex, let host = pageHosts[visibleIndex] else { return }
        host.setAppeared(nowAttached, animated: false)
    }
}

// MARK: - 公共方法
public extension CLStickyControllerPageView {
    /// 重新加载页面，并可指定重载后的目标页。
    /// - Parameter index: 目标索引。传 `nil` 时沿用内部默认策略。
    func reload(toPageAt index: Int? = nil) {
        guard let dataSource else {
            preconditionFailure("CLStickyControllerPageView: 请先设置 dataSource")
        }

        parentViewController = dataSource.parentViewController(for: self)
        tearDownPageHosts()
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
        delegate?.controllerPageView(self, didScrollToPageAt: clampedIndex)
    }
}

// MARK: - 内部逻辑
private extension CLStickyControllerPageView {
    func setupUI() {
        pagerView.dataSource = self
        pagerView.delegate = self

        addSubview(pagerView)
        pagerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func tearDownPageHosts() {
        if isAttachedToWindow, let visibleIndex, let visibleHost = pageHosts[visibleIndex] {
            visibleHost.setAppeared(false, animated: false)
        }

        visibleIndex = nil
        pageHosts.values.forEach { $0.uninstall() }
        pageHosts.removeAll()
    }

    func updateVisibleController(to rawIndex: Int?, animated: Bool) {
        let targetIndex: Int?
        if let rawIndex, pagerView.numberOfPages > 0 {
            targetIndex = min(max(rawIndex, 0), pagerView.numberOfPages - 1)
        } else {
            targetIndex = nil
        }

        guard targetIndex != visibleIndex else { return }

        let previousHost = visibleIndex.flatMap { pageHosts[$0] }
        let targetHost = targetIndex.map { pageHost(at: $0) }

        if isAttachedToWindow {
            previousHost?.setAppeared(false, animated: animated)
            targetHost?.setAppeared(true, animated: animated)
        } else {
            previousHost?.setAppeared(false, animated: false)
        }

        visibleIndex = targetIndex
    }

    func pageHost(at index: Int) -> CLStickyPagerHostView {
        if let host = pageHosts[index] {
            if let parentViewController {
                host.installIfNeeded(in: parentViewController)
            }
            return host
        }

        guard let dataSource else {
            preconditionFailure("CLStickyControllerPageView: 请先设置 dataSource")
        }

        if parentViewController == nil {
            parentViewController = dataSource.parentViewController(for: self)
        }

        guard let parentViewController else {
            preconditionFailure("CLStickyControllerPageView: parentViewController(for:) 必须返回有效控制器")
        }

        let controller = dataSource.controllerPageView(self, pageControllerAt: index)
        let host = CLStickyPagerHostView(controller: controller)
        host.installIfNeeded(in: parentViewController)
        pageHosts[index] = host
        return host
    }
}

// MARK: - CLStickyPageViewDataSource
extension CLStickyControllerPageView: CLStickyPageViewDataSource {
    public func numberOfPages(in pageView: CLStickyPageView) -> Int {
        dataSource?.numberOfPages(in: self) ?? 0
    }

    public func pageView(_ pageView: CLStickyPageView, pageAt index: Int) -> CLStickyViewPage {
        pageHost(at: index)
    }
}

// MARK: - CLStickyPageViewDelegate
extension CLStickyControllerPageView: CLStickyPageViewDelegate {
    public func pageView(_ pageView: CLStickyPageView, contentScrollViewDidScroll scrollView: UIScrollView, progress: CGFloat) {
        delegate?.controllerPageView(self, contentScrollViewDidScroll: scrollView, progress: progress)
    }

    public func pageView(_ pageView: CLStickyPageView, didScrollToPageAt index: Int) {
        let animated = pendingScrollAnimated ?? true
        pendingScrollAnimated = nil

        if index >= 0 {
            updateVisibleController(to: index, animated: animated)
            delegate?.controllerPageView(self, didScrollToPageAt: index)
        } else {
            updateVisibleController(to: nil, animated: false)
        }
    }
}

// MARK: - 控制器页面宿主（内部）
class CLStickyPagerHostView: UIView, CLStickyViewPage {
    let controller: CLStickyControllerPage

    var scrollView: UIScrollView {
        controller.scrollView
    }

    private var isControllerViewAttached = false
    private var isAppeared = false

    init(controller: CLStickyControllerPage) {
        self.controller = controller
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func installIfNeeded(in parent: UIViewController) {
        if controller.parent !== parent {
            if controller.parent != nil {
                uninstall()
            }

            parent.addChild(controller)
            attachControllerViewIfNeeded()
            controller.didMove(toParent: parent)
            return
        }

        attachControllerViewIfNeeded()
    }

    func uninstall() {
        if isAppeared {
            setAppeared(false, animated: false)
        }

        if controller.parent != nil {
            controller.willMove(toParent: nil)
        }

        controller.view.removeFromSuperview()
        controller.removeFromParent()
        isControllerViewAttached = false
    }

    func setAppeared(_ appeared: Bool, animated: Bool) {
        guard appeared != isAppeared else { return }

        controller.beginAppearanceTransition(appeared, animated: animated)
        controller.endAppearanceTransition()
        isAppeared = appeared
    }

    private func attachControllerViewIfNeeded() {
        guard !isControllerViewAttached || controller.view.superview !== self else { return }

        let contentView = controller.view!
        if contentView.superview !== self {
            contentView.removeFromSuperview()
            addSubview(contentView)
            contentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        isControllerViewAttached = true
    }
}

