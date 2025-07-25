import UIKit
import SnapKit

// MARK: - 多手势滚动视图（内部使用）
fileprivate class CLMultiGestureScrollView: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLMultiGestureScrollView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - 可监听 contentSize 的滚动视图（内部使用）
fileprivate class CLObservingScrollView: UIScrollView {
    var contentSizeChangedHandler: ((CGSize) -> Void)?
    override var contentSize: CGSize {
        didSet {
            guard oldValue != contentSize else { return }
            contentSizeChangedHandler?(contentSize)
        }
    }
}

// MARK: - 数据源协议
public protocol CLNestedSlideViewDataSource: AnyObject {
    /// 返回页面数量
    func numberOfPages(in nestedSlideView: CLNestedSlideView) -> Int
    /// 返回指定索引的页面视图
    func nestedSlideView(_ nestedSlideView: CLNestedSlideView, pageFor index: Int) -> CLNestedSlideViewPage
}

// MARK: - 代理协议
public protocol CLNestedSlideViewDelegate: AnyObject {
    /// 水平分页滚动时回调，progress 为进度
    func contentScrollViewDidScroll(_ nestedSlideView: CLNestedSlideView, scrollView: UIScrollView, progress: CGFloat)
    /// 滚动到指定页面时回调
    func contentScrollViewDidScrollToPage(at index: Int)
}
public extension CLNestedSlideViewDelegate {
    func contentScrollViewDidScroll(_ nestedSlideView: CLNestedSlideView, scrollView: UIScrollView, progress: CGFloat) {}
    func contentScrollViewDidScrollToPage(at index: Int) {}
}

// MARK: - 嵌套滑动主视图主体（公开属性/方法、初始化）
public class CLNestedSlideView: UIView {
    /// 是否显示所有滚动条，默认 true
    public var showIndicator: Bool = true {
        didSet { updateScrollIndicatorDisplay() }
    }
    /// 头部视图（可选）
    public var headerView: UIView? {
        didSet { guard headerView != oldValue else { return }
        updateStackView(mainStackView, with: headerView, oldValue: oldValue, at: 0) }
    }
    /// 悬停视图（可选）
    public var hoverView: UIView? {
        didSet { guard hoverView != oldValue else { return }
        updateStackView(bodyStackView, with: hoverView, oldValue: oldValue, at: 0) }
    }
    /// 数据源
    public weak var dataSource: CLNestedSlideViewDataSource?
    /// 代理
    public weak var delegate: CLNestedSlideViewDelegate?
    /// 是否启用懒加载模式（只读）
    public var isLazyLoadingEnabled: Bool { isLazyLoading }
    /// 页面总数（只读）
    public var numberOfPages: Int { pageCount }
    /// 当前可见页面（只读）
    public var currentPage: CLNestedSlideViewPage? { visiblePage }
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
    private var currentIndex = 0 {
        didSet {
            guard currentIndex != oldValue else { return }
            loadPage(at: currentIndex)
            delegate?.contentScrollViewDidScrollToPage(at: currentIndex)
        }
    }
    private var visiblePage: CLNestedSlideViewPage?
    private var pageCache = [Int: CLNestedSlideViewPage]()
    private var placeholderViews = [UIView]()
    private var pageCount = 0
    private var isSwipeEnabled = true
    private var lastMainScrollOffsetY: CGFloat = 0
    private var lastScrollIndicatorState: (main: Bool, page: Bool) = (true, false)
    private lazy var mainScrollView: CLMultiGestureScrollView = {
        let scrollView = CLMultiGestureScrollView()
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    private lazy var contentScrollView: CLObservingScrollView = {
        let scrollView = CLObservingScrollView()
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
}

// MARK: - 公共方法
public extension CLNestedSlideView {
    /// 重新加载所有页面
    func reload() {
        guard let dataSource = dataSource else { return }
        guard pageCount != dataSource.numberOfPages(in: self) || pageCache.isEmpty else { return }
        pageCount = dataSource.numberOfPages(in: self)
        if !isLazyLoading { pageCache.removeAll() }
        setupPlaceholderViews()
        guard pageCount > 0 else { return }
        currentIndex = min(currentIndex, pageCount - 1)
        loadPage(at: currentIndex)
    }
    /// 滚动到指定页面
    func scrollToPage(at index: Int, animated: Bool) {
        let targetIndex = clampIndex(index)
        guard targetIndex < placeholderViews.count else { return }
        if isLazyLoading { loadPage(at: targetIndex) }
        let targetOffset = CGPoint(x: CGFloat(targetIndex) * bounds.width, y: 0)
        contentScrollView.setContentOffset(targetOffset, animated: animated)
    }
    /// 获取指定索引的页面（懒加载模式下可能返回 nil）
    func page(at index: Int) -> CLNestedSlideViewPage? {
        guard isValidIndex(index) else { return nil }
        return isLazyLoading ? pageCache[index] : (placeholderViews[index] as? CLNestedSlideViewPage)
    }
}

// MARK: - UI 构建相关
private extension CLNestedSlideView {
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
private extension CLNestedSlideView {
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
private extension CLNestedSlideView {
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
            placeholder.translatesAutoresizingMaskIntoConstraints = false
            placeholder.backgroundColor = .clear
            pageStackView.addArrangedSubview(placeholder)
            placeholderViews.append(placeholder)
            placeholder.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        }
    }
    func setupEagerLoadingViews(dataSource: CLNestedSlideViewDataSource) {
        for index in 0..<pageCount {
            let page = dataSource.nestedSlideView(self, pageFor: index)
            configurePage(page)
            pageStackView.addArrangedSubview(page)
            placeholderViews.append(page)
            pageCache[index] = page
            page.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        }
        guard pageCount > 0 else { return }
        visiblePage = pageCache[min(currentIndex, pageCount - 1)]
    }
    func loadPage(at index: Int) {
        guard let dataSource = dataSource, isValidIndex(index) else { return }
        currentIndex = index
        isLazyLoading ? loadPageLazily(at: index, dataSource: dataSource) : loadPageEagerly(at: index)
    }
    func loadPageLazily(at index: Int, dataSource: CLNestedSlideViewDataSource) {
        guard !(placeholderViews[index] is CLNestedSlideViewPage) else {
            visiblePage = placeholderViews[index] as? CLNestedSlideViewPage
            return
        }
        let page = pageCache[index] ?? dataSource.nestedSlideView(self, pageFor: index)
        configurePage(page)
        let placeholder = placeholderViews[index]
        pageStackView.removeArrangedSubview(placeholder)
        placeholder.removeFromSuperview()
        page.translatesAutoresizingMaskIntoConstraints = false
        pageStackView.insertArrangedSubview(page, at: index)
        page.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        placeholderViews[index] = page
        visiblePage = page
        pageCache[index] = page
    }
    func loadPageEagerly(at index: Int) {
        guard let page = placeholderViews[index] as? CLNestedSlideViewPage else { return }
        visiblePage = page
    }
    func configurePage(_ page: CLNestedSlideViewPage) {
        page.isSwipeEnabled = headerView == nil
        page.superScrollEnabledHandler = { [weak self] isEnabled in
            guard let self = self else { return true }
            self.isSwipeEnabled = isEnabled
            return self.headerView == nil
        }
        page.setupScrollViewDelegateIfNeeded()
        setScrollIndicator(for: page.scrollView, show: showIndicator)
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
    func updateCurrentPageIndex(for scrollView: UIScrollView) {
        guard scrollView == contentScrollView else { return }
        let width = scrollView.bounds.width
        guard width > 0 else { return }
        let newIndex = Int(round(scrollView.contentOffset.x / width))
        let clampedIndex = clampIndex(newIndex)
        guard clampedIndex != currentIndex else { return }
        currentIndex = clampedIndex
    }
    func clampIndex(_ index: Int) -> Int {
        return min(max(index, 0), pageCount - 1)
    }
    func isValidIndex(_ index: Int) -> Bool {
        return index >= 0 && index < pageCount && index < placeholderViews.count
    }
}

// MARK: - UIScrollViewDelegate 实现
extension CLNestedSlideView: UIScrollViewDelegate {
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
private extension CLNestedSlideView {
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
        delegate?.contentScrollViewDidScroll(self, scrollView: scrollView, progress: progress)
    }
    func handleMainScrollViewScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.height > 0 else { return }
        let maxOffset = headerView?.bounds.height ?? 0
        let offsetY = scrollView.contentOffset.y
        let isScrollingDown = offsetY < lastMainScrollOffsetY
        let isPageScrollAtTop = visiblePage?.scrollView.contentOffset.y ?? 0 <= 0
        if !isSwipeEnabled {
            if isScrollingDown && isPageScrollAtTop {
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
        lastMainScrollOffsetY = scrollView.contentOffset.y
    }
}

// MARK: - 滚动条显示工具
private extension CLNestedSlideView {
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
