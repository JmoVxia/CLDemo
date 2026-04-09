import UIKit
import SnapKit

// MARK: - 数据源协议
public protocol CLStickyPageViewDataSource: AnyObject {
    /// 返回页面数量
    func numberOfPages(in pageView: CLStickyPageView) -> Int
    /// 返回指定索引的页面视图
    func pageView(_ pageView: CLStickyPageView, pageAt index: Int) -> CLStickyViewPage
}

// MARK: - 代理协议
public protocol CLStickyPageViewDelegate: AnyObject {
    /// 水平分页滚动时回调，progress 为进度
    func pageView(_ pageView: CLStickyPageView, contentScrollViewDidScroll scrollView: UIScrollView, progress: CGFloat)
    /// 滚动到指定页面时回调
    func pageView(_ pageView: CLStickyPageView, didScrollToPageAt index: Int)
}
public extension CLStickyPageViewDelegate {
    func pageView(_ pageView: CLStickyPageView, contentScrollViewDidScroll scrollView: UIScrollView, progress: CGFloat) {}
    func pageView(_ pageView: CLStickyPageView, didScrollToPageAt index: Int) {}
}

// MARK: - 吸顶分页主视图
public final class CLStickyPageView: UIView {
    /// 是否显示所有滚动条，默认 true
    public var showIndicator: Bool = true {
        didSet { updateScrollIndicatorDisplay() }
    }
    /// `hoverView` 进入悬浮态后距离容器顶部的预留距离，默认 0。
    /// 仅在设置了 `hoverView` 时生效。
    public var hoverStickyTopInset: CGFloat = 0 {
        didSet {
            guard hoverStickyTopInset != oldValue else { return }
            refreshStickyConfiguration()
        }
    }
    /// 头部视图（可选）
    public var headerView: UIView? {
        didSet {
            guard headerView != oldValue else { return }
            updateStackView(mainStackView, with: headerView, oldValue: oldValue, at: 0)
            refreshStickyConfiguration()
        }
    }
    /// 悬停视图（可选）
    public var hoverView: UIView? {
        didSet {
            guard hoverView != oldValue else { return }
            updateStackView(bodyStackView, with: hoverView, oldValue: oldValue, at: 0)
            refreshStickyConfiguration()
        }
    }
    /// body 区域背景视图（可选，弱引用）
    /// 该视图会被添加到 `mainScrollView`，并约束为与 `bodyStackView` 同尺寸且位于其下层。
    public weak var backgroundView: UIView? {
        didSet {
            guard backgroundView != oldValue else { return }
            updateBackgroundView(backgroundView, oldValue: oldValue)
        }
    }
    /// 数据源
    public weak var dataSource: CLStickyPageViewDataSource?
    /// 代理
    public weak var delegate: CLStickyPageViewDelegate?
    /// 是否启用懒加载模式（只读）
    public var isLazyLoadingEnabled: Bool { isLazyLoading }
    /// 页面总数（只读）
    public var numberOfPages: Int { pageCount }
    /// 当前可见页面（只读）
    public var currentPage: CLStickyViewPage? { visiblePage }
    /// 当前页面索引（支持 get/set）
    public var currentPageIndex: Int {
        get { currentIndex }
        set {
            let targetIndex = clampIndex(newValue)
            guard targetIndex != currentIndex else { return }
            scrollToPage(at: targetIndex, animated: false)
        }
    }
    /// 是否允许横向滑动
    public var isHorizontalScrollEnabled: Bool {
        get { contentScrollView.isScrollEnabled }
        set { contentScrollView.isScrollEnabled = newValue }
    }
    private let isLazyLoading: Bool
    private var currentIndex = 0
    private var visiblePage: CLStickyViewPage?
    private var pageCache = [Int: CLStickyViewPage]()
    private var pageScrollViewBaseInsets = [ObjectIdentifier: (content: UIEdgeInsets, indicator: UIEdgeInsets)]()
    private var placeholderViews = [UIView]()
    private var pageCount = 0
    private var isSwipeEnabled = true
    private var lastMainScrollOffsetY: CGFloat = 0
    private var lastScrollIndicatorState: (main: Bool, page: Bool) = (true, false)
    private lazy var mainScrollView: CLStickyPagerGestureScrollView = {
        let scrollView = CLStickyPagerGestureScrollView()
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    private lazy var contentScrollView: CLStickyPagerSizeObservingScrollView = {
        let scrollView = CLStickyPagerSizeObservingScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSizeChangedHandler = { [weak self] _ in
            guard let self = self else { return }
            self.scrollToPage(at: self.currentPageIndex, animated: false)
        }
        return scrollView
    }()
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.insetsLayoutMarginsFromSafeArea = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private lazy var bodyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.insetsLayoutMarginsFromSafeArea = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private lazy var pageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.insetsLayoutMarginsFromSafeArea = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    // MARK: - 初始化
    public init(frame: CGRect = .zero, isLazyLoading: Bool = true) {
        self.isLazyLoading = isLazyLoading
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    public override init(frame: CGRect) {
        self.isLazyLoading = true
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        self.isLazyLoading = true
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateVerticalScrollOwnership()
        updateVisiblePageScrollInsetForClipping()
    }
}

// MARK: - 公共方法
public extension CLStickyPageView {
    /// 重新加载所有页面，并可选择跳转到指定索引
    /// - Parameter index: 重载后要跳转到的页面索引。如果为 nil，则保留当前页或跳转到新的最后一页。
    func reload(toPageAt index: Int? = nil) {
        guard let dataSource = dataSource else { return }
        let oldIndex = currentIndex
        pageCache.removeAll()
        pageScrollViewBaseInsets.removeAll()
        pageCount = dataSource.numberOfPages(in: self)
        setupPlaceholderViews()
        if pageCount == 0 {
            visiblePage = nil
            currentIndex = 0
            contentScrollView.contentOffset = .zero
            refreshStickyConfiguration()
            delegate?.pageView(self, didScrollToPageAt: -1)
            return
        }
        let newIndex = index.map { clampIndex($0) } ?? min(oldIndex, pageCount - 1)
        scrollToPage(at: newIndex, animated: false)
        refreshStickyConfiguration()
        if newIndex == oldIndex {
            delegate?.pageView(self, didScrollToPageAt: newIndex)
        }
    }
    /// 滚动到指定页面
    func scrollToPage(at index: Int, animated: Bool) {
        let targetIndex = clampIndex(index)
        guard targetIndex < placeholderViews.count else { return }
        if isLazyLoading { loadPage(at: targetIndex) }
        let targetOffset = CGPoint(x: CGFloat(targetIndex) * bounds.width, y: 0)
        contentScrollView.setContentOffset(targetOffset, animated: animated)
        if !animated {
            updateCurrentIndex(to: targetIndex)
        }
    }
    /// 获取指定索引的页面（懒加载模式下可能返回 nil）
    func page(at index: Int) -> CLStickyViewPage? {
        guard isValidIndex(index) else { return nil }
        return isLazyLoading ? pageCache[index] : (placeholderViews[index] as? CLStickyViewPage)
    }
}

// MARK: - UI 构建相关
private extension CLStickyPageView {
    func setupUI() {
        addSubview(mainScrollView)
        mainScrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(bodyStackView)
        bodyStackView.addArrangedSubview(contentScrollView)
        contentScrollView.addSubview(pageStackView)
        contentScrollView.panGestureRecognizer.addTarget(self, action: #selector(handleContentPan(_:)))
    }
    func setupConstraints() {
        mainScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainStackView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        bodyStackView.snp.makeConstraints { make in
            make.height.equalTo(self)
        }
        pageStackView.snp.makeConstraints { make in
            make.edges.height.equalToSuperview()
        }
    }
}

// MARK: - 手势处理
private extension CLStickyPageView {
    @objc func handleContentPan(_ gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: contentScrollView)
        switch gesture.state {
        case .began:
            if abs(velocity.x) > abs(velocity.y) {
                mainScrollView.isScrollEnabled = false
            }
        case .ended, .cancelled, .failed:
            mainScrollView.isScrollEnabled = true
        default:
            break
        }
    }
}

// MARK: - 页面管理
private extension CLStickyPageView {
    func setupPlaceholderViews() {
        guard let dataSource = dataSource else { return }
        placeholderViews.forEach { view in
            pageStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        placeholderViews.removeAll()
        isLazyLoading ? setupLazyLoadingViews() : setupEagerLoadingViews(dataSource: dataSource)
    }
    func setupLazyLoadingViews() {
        for _ in 0..<pageCount {
            let placeholder = UIView()
            placeholder.backgroundColor = .clear
            pageStackView.addArrangedSubview(placeholder)
            placeholderViews.append(placeholder)
            placeholder.snp.makeConstraints { make in
                make.width.equalTo(self.snp.width)
            }
        }
    }
    func setupEagerLoadingViews(dataSource: CLStickyPageViewDataSource) {
        for index in 0..<pageCount {
            let page = dataSource.pageView(self, pageAt: index)
            configurePage(page)
            pageStackView.addArrangedSubview(page)
            placeholderViews.append(page)
            pageCache[index] = page
            page.snp.makeConstraints { make in
                make.width.equalTo(self.snp.width)
            }
        }
        guard pageCount > 0 else { return }
        visiblePage = pageCache[min(currentIndex, pageCount - 1)]
    }
    func loadPage(at index: Int) {
        guard isValidIndex(index) else { return }
        if isLazyLoading {
            guard let dataSource = dataSource else { return }
            loadPageLazily(at: index, dataSource: dataSource)
        } else {
            loadPageEagerly(at: index)
        }
    }
    func loadPageLazily(at index: Int, dataSource: CLStickyPageViewDataSource) {
        guard !(placeholderViews[index] is CLStickyViewPage) else {
            visiblePage = placeholderViews[index] as? CLStickyViewPage
            updateVisiblePageScrollInsetForClipping()
            return
        }
        let page = pageCache[index] ?? dataSource.pageView(self, pageAt: index)
        configurePage(page)
        let placeholder = placeholderViews[index]
        pageStackView.removeArrangedSubview(placeholder)
        placeholder.removeFromSuperview()
        pageStackView.insertArrangedSubview(page, at: index)
        page.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width)
        }
        placeholderViews[index] = page
        visiblePage = page
        pageCache[index] = page
        updateVisiblePageScrollInsetForClipping()
    }
    func loadPageEagerly(at index: Int) {
        guard let page = placeholderViews[index] as? CLStickyViewPage else { return }
        visiblePage = page
        updateVisiblePageScrollInsetForClipping()
    }
    func configurePage(_ page: CLStickyViewPage) {
        cacheBaseInsetsIfNeeded(for: page)
        page.isSwipeEnabled = shouldEnablePageScroll(at: mainScrollView.contentOffset.y)
        page.superScrollEnabledHandler = { [weak self] isEnabled in
            guard let self = self else { return true }
            self.isSwipeEnabled = isEnabled
            return self.canPageScrollWithoutMainScroll
        }
        page.setupScrollViewDelegateIfNeeded()
        setScrollIndicator(for: page.scrollView, show: showIndicator)
    }
    func refreshStickyConfiguration() {
        pageCache.values.forEach(configurePage)
        updateVerticalScrollOwnership()
        updateVisiblePageScrollInsetForClipping()
    }
    func updateStackView(_ stackView: UIStackView, with newView: UIView?, oldValue: UIView?, at index: Int) {
        guard newView !== oldValue else { return }
        if let oldValue = oldValue, stackView.arrangedSubviews.contains(oldValue) {
            stackView.removeArrangedSubview(oldValue)
            oldValue.removeFromSuperview()
        }
        if let newView = newView, !stackView.arrangedSubviews.contains(newView) {
            let safeIndex = min(index, stackView.arrangedSubviews.count)
            stackView.insertArrangedSubview(newView, at: safeIndex)
        }
    }
    func updateBackgroundView(_ newView: UIView?, oldValue: UIView?) {
        guard newView !== oldValue else { return }

        oldValue?.removeFromSuperview()

        guard let newView else { return }

        newView.removeFromSuperview()
        newView.isUserInteractionEnabled = false
        mainScrollView.insertSubview(newView, belowSubview: mainStackView)
        newView.snp.makeConstraints { make in
            make.edges.equalTo(bodyStackView)
        }
    }
    func updateCurrentPageIndex(for scrollView: UIScrollView) {
        guard scrollView == contentScrollView else { return }
        let width = scrollView.bounds.width
        guard width > 0 else { return }
        let newIndex = Int(round(scrollView.contentOffset.x / width))
        let clampedIndex = clampIndex(newIndex)
        updateCurrentIndex(to: clampedIndex)
    }
    func updateCurrentIndex(to index: Int) {
        guard isValidIndex(index) else { return }
        let oldIndex = currentIndex
        currentIndex = index
        loadPage(at: index)
        guard index != oldIndex else { return }
        delegate?.pageView(self, didScrollToPageAt: index)
    }
    func clampIndex(_ index: Int) -> Int {
        return min(max(index, 0), pageCount - 1)
    }
    func isValidIndex(_ index: Int) -> Bool {
        return index >= 0 && index < pageCount && index < placeholderViews.count
    }
    var resolvedHoverTopInset: CGFloat {
        guard hoverView != nil else { return 0 }
        return max(0, hoverStickyTopInset)
    }
    var headerHeight: CGFloat {
        max(0, headerView?.bounds.height ?? 0)
    }
    var isHeaderHeightPendingForStickyInset: Bool {
        headerView != nil && headerHeight <= 0
    }
    var pinActivationOffsetY: CGFloat {
        if isHeaderHeightPendingForStickyInset {
            return .greatestFiniteMagnitude
        }
        return max(0, headerHeight - resolvedHoverTopInset)
    }
    var canPageScrollWithoutMainScroll: Bool {
        pinActivationOffsetY <= 0
    }
    func shouldEnablePageScroll(at mainOffsetY: CGFloat) -> Bool {
        canPageScrollWithoutMainScroll || mainOffsetY >= pinActivationOffsetY
    }
    func cacheBaseInsetsIfNeeded(for page: CLStickyViewPage) {
        let key = ObjectIdentifier(page)
        guard pageScrollViewBaseInsets[key] == nil else { return }
        let scrollView = page.scrollView
        pageScrollViewBaseInsets[key] = (scrollView.contentInset, scrollView.verticalScrollIndicatorInsets)
    }
    func applyAdditionalBottomInset(_ additionalBottomInset: CGFloat, for page: CLStickyViewPage) {
        let key = ObjectIdentifier(page)
        guard let baseInsets = pageScrollViewBaseInsets[key] else { return }
        let extra = max(0, additionalBottomInset)
        let scrollView = page.scrollView

        var contentInset = baseInsets.content
        contentInset.bottom += extra
        if scrollView.contentInset != contentInset {
            scrollView.contentInset = contentInset
        }

        var indicatorInset = baseInsets.indicator
        indicatorInset.bottom += extra
        if scrollView.verticalScrollIndicatorInsets != indicatorInset {
            scrollView.verticalScrollIndicatorInsets = indicatorInset
        }
    }
    func currentContentScrollViewBottomClipHeight() -> CGFloat {
        let frameInMainStack = contentScrollView.convert(contentScrollView.bounds, to: mainStackView)
        let visibleRect = CGRect(origin: mainScrollView.contentOffset, size: mainScrollView.bounds.size)
        let intersection = frameInMainStack.intersection(visibleRect)
        guard !intersection.isNull else { return frameInMainStack.height }
        return max(0, frameInMainStack.height - intersection.height)
    }
    func updateVisiblePageScrollInsetForClipping() {
        guard let visiblePage = visiblePage else { return }
        let visiblePageID = ObjectIdentifier(visiblePage)

        pageCache.values.forEach { page in
            if ObjectIdentifier(page) != visiblePageID {
                applyAdditionalBottomInset(0, for: page)
            }
        }

        applyAdditionalBottomInset(currentContentScrollViewBottomClipHeight(), for: visiblePage)
    }
    func updateVerticalScrollOwnership() {
        let isPageScrollEnabled = shouldEnablePageScroll(at: mainScrollView.contentOffset.y)
        isSwipeEnabled = !isPageScrollEnabled
        visiblePage?.isSwipeEnabled = isPageScrollEnabled
        updateScrollIndicatorsForStateChange()
    }
}

// MARK: - UIScrollViewDelegate 实现
extension CLStickyPageView: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == mainScrollView {
            lastMainScrollOffsetY = scrollView.contentOffset.y
        }
    }
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == contentScrollView else { return }
        guard scrollView.bounds.width > 0 else { return }
        mainScrollView.isScrollEnabled = true
        let targetIndex = Int(round(targetContentOffset.pointee.x / scrollView.bounds.width))
        let clampedIndex = clampIndex(targetIndex)
        targetContentOffset.pointee.x = CGFloat(clampedIndex) * scrollView.bounds.width
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == contentScrollView else { return }
        updateCurrentPageIndex(for: scrollView)
    }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard scrollView == contentScrollView else { return }
        updateCurrentPageIndex(for: scrollView)
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        configureScrollIndicators(scrollView)
        if scrollView == contentScrollView {
            handleContentScrollViewScroll(scrollView)
            return
        }
        handleMainScrollViewScroll(scrollView)
    }
}

// MARK: - 滚动条与滚动协调核心
private extension CLStickyPageView {
    enum ActiveScrollView {
        case main
        case page
        case none
    }
    /// 计算滚动条显示状态
    func calculateScrollIndicatorState(activeScrollView: ActiveScrollView) -> (main: Bool, page: Bool) {
        let pageScrollView = visiblePage?.scrollView
        let mainNeedsIndicator = mainScrollView.contentSize.height > mainScrollView.bounds.height
        let pageNeedsIndicator = pageScrollView?.contentSize.height ?? 0 > pageScrollView?.bounds.height ?? 0
        let shouldShowMainIndicator = shouldShowMainScrollIndicator(
            activeScrollView: activeScrollView,
            mainNeedsIndicator: mainNeedsIndicator,
            pageNeedsIndicator: pageNeedsIndicator
        )
        let shouldShowPageIndicator = shouldShowPageScrollIndicator(
            activeScrollView: activeScrollView,
            pageNeedsIndicator: pageNeedsIndicator,
            showingMainIndicator: shouldShowMainIndicator
        )
        return (main: shouldShowMainIndicator, page: shouldShowPageIndicator)
    }
    func shouldShowMainScrollIndicator(activeScrollView: ActiveScrollView, mainNeedsIndicator: Bool, pageNeedsIndicator: Bool) -> Bool {
        if activeScrollView == .main && isSwipeEnabled && mainNeedsIndicator {
            return true
        }
        if activeScrollView == .none && isSwipeEnabled && mainNeedsIndicator {
            return true
        }
        return false
    }
    func shouldShowPageScrollIndicator(activeScrollView: ActiveScrollView, pageNeedsIndicator: Bool, showingMainIndicator: Bool) -> Bool {
        if activeScrollView == .page && visiblePage?.isSwipeEnabled == true && pageNeedsIndicator {
            return true
        }
        if activeScrollView == .none && !showingMainIndicator && visiblePage?.isSwipeEnabled == true && pageNeedsIndicator {
            return true
        }
        return false
    }
    func updateScrollIndicatorsIfNeeded(_ newState: (main: Bool, page: Bool)) {
        if !showIndicator {
            setScrollIndicator(for: mainScrollView, show: false)
            setScrollIndicator(for: visiblePage?.scrollView, show: false)
            lastScrollIndicatorState = (false, false)
            return
        }
        guard newState.main != lastScrollIndicatorState.main ||
              newState.page != lastScrollIndicatorState.page else { return }
        setScrollIndicator(for: mainScrollView, show: newState.main)
        setScrollIndicator(for: visiblePage?.scrollView, show: newState.page)
        lastScrollIndicatorState = newState
    }
    func configureScrollIndicators(_ scrollView: UIScrollView) {
        if !showIndicator {
            setScrollIndicator(for: scrollView, show: false)
            return
        }
        guard scrollView != contentScrollView else { return }
        let isMainScrollView = (scrollView == mainScrollView)
        let indicatorState = calculateScrollIndicatorState(activeScrollView: isMainScrollView ? .main : .page)
        updateScrollIndicatorsIfNeeded(indicatorState)
    }
    func updateScrollIndicatorsForStateChange() {
        let indicatorState = calculateScrollIndicatorState(activeScrollView: .none)
        updateScrollIndicatorsIfNeeded(indicatorState)
    }
    func handleContentScrollViewScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.width
        let progress: CGFloat = width > 0 ? scrollView.contentOffset.x / width : 0
        delegate?.pageView(self, contentScrollViewDidScroll: scrollView, progress: progress)
    }
    func handleMainScrollViewScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.height > 0 else { return }
        if isHeaderHeightPendingForStickyInset {
            isSwipeEnabled = true
            visiblePage?.isSwipeEnabled = false
            updateScrollIndicatorsForStateChange()
            updateVisiblePageScrollInsetForClipping()
            lastMainScrollOffsetY = scrollView.contentOffset.y
            return
        }
        let maxOffset = pinActivationOffsetY
        let offsetY = scrollView.contentOffset.y
        let isScrollingDown = offsetY < lastMainScrollOffsetY
        let isPageScrollAtTop = visiblePage?.scrollView.contentOffset.y ?? 0 <= 0
        if !isSwipeEnabled {
            if !canPageScrollWithoutMainScroll && isScrollingDown && isPageScrollAtTop {
                isSwipeEnabled = true
                visiblePage?.isSwipeEnabled = false
                updateScrollIndicatorsForStateChange()
            } else {
                scrollView.contentOffset.y = maxOffset
                visiblePage?.isSwipeEnabled = true
                updateScrollIndicatorsForStateChange()
            }
        } else if offsetY >= maxOffset {
            scrollView.contentOffset.y = maxOffset
            isSwipeEnabled = false
            visiblePage?.isSwipeEnabled = true
            updateScrollIndicatorsForStateChange()
        } else {
            visiblePage?.isSwipeEnabled = false
            updateScrollIndicatorsForStateChange()
        }
        updateVisiblePageScrollInsetForClipping()
        lastMainScrollOffsetY = scrollView.contentOffset.y
    }
}

// MARK: - 滚动条显示工具
private extension CLStickyPageView {
    func setScrollIndicator(for scrollView: UIScrollView?, show: Bool) {
        scrollView?.showsVerticalScrollIndicator = show
        scrollView?.showsHorizontalScrollIndicator = show
    }
    func updateScrollIndicatorDisplay() {
        setScrollIndicator(for: mainScrollView, show: showIndicator)
        setScrollIndicator(for: contentScrollView, show: showIndicator)
        setScrollIndicator(for: visiblePage?.scrollView, show: showIndicator)
    }
}

// MARK: - 多手势滚动视图（内部）
fileprivate class CLStickyPagerGestureScrollView: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLStickyPagerGestureScrollView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - 内容尺寸监听滚动视图（内部）
fileprivate class CLStickyPagerSizeObservingScrollView: UIScrollView, UIGestureRecognizerDelegate {
    var contentSizeChangedHandler: ((CGSize) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        panGestureRecognizer.delegate = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var contentSize: CGSize {
        didSet {
            guard oldValue != contentSize else { return }
            contentSizeChangedHandler?(contentSize)
        }
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard !isPanBack(gestureRecognizer) else { return false }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }

    private func isPanBack(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == panGestureRecognizer else { return false }
        let velocity = panGestureRecognizer.velocity(in: self)
        let translation = panGestureRecognizer.translation(in: self)
        return contentOffset.x <= 0 && (velocity.x > 0 || translation.x > 0)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        isPanBack(gestureRecognizer)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == panGestureRecognizer else { return false }
        guard !isPanBack(gestureRecognizer) else { return false }
        guard let otherView = otherGestureRecognizer.view, !otherView.isDescendant(of: self) else { return false }
        return true
    }
}
