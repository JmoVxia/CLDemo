import Foundation
import UIKit

// MARK: - 统一页面协议
public protocol CLStickyPage: AnyObject {
    /// 页面内部用于纵向滚动的主滚动视图。
    var scrollView: UIScrollView { get }
}

// MARK: - View 页面协议
public protocol CLStickyViewPage: CLStickyPage where Self: UIView {}

// MARK: - 页面协议扩展（框架自动处理）
public extension CLStickyViewPage {
    /// 页面是否允许继续向上滚动，由框架自动维护。
    var isSwipeEnabled: Bool {
        get { objc_getAssociatedObject(self, &AssociatedKeys.isSwipeEnabled) as? Bool ?? false }
        set { objc_setAssociatedObject(self, &AssociatedKeys.isSwipeEnabled, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// 父级是否可滚动的联动回调，由框架自动维护。
    var superScrollEnabledHandler: ((Bool) -> Bool)? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.superScrollEnabledHandler) as? ((Bool) -> Bool) }
        set { objc_setAssociatedObject(self, &AssociatedKeys.superScrollEnabledHandler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// 安装滚动代理桥接器。通常无需手动调用。
    func setupScrollViewDelegateIfNeeded() {
        guard objc_getAssociatedObject(self, &AssociatedKeys.scrollBridge) == nil else { return }

        let bridge = CLStickyPageScrollBridge(scrollView: scrollView, page: self)
        objc_setAssociatedObject(self, &AssociatedKeys.scrollBridge, bridge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

// MARK: - 内部滚动协调实现
fileprivate extension CLStickyViewPage {
    func handleScrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isSwipeEnabled else {
            scrollView.contentOffset.y = 0
            return
        }

        guard scrollView.contentOffset.y <= 0 else { return }
        guard let superScrollEnabledHandler, !superScrollEnabledHandler(true) else { return }

        isSwipeEnabled = false
    }
}

// MARK: - 滚动代理转发（内部）
fileprivate final class CLStickyPageScrollProxy: NSObject, UIScrollViewDelegate {
    weak var externalDelegate: UIScrollViewDelegate?
    weak var page: CLStickyViewPage?

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if super.responds(to: aSelector) {
            return self
        }
        if let externalDelegate, externalDelegate.responds(to: aSelector) {
            return externalDelegate
        }
        return self
    }

    override func responds(to aSelector: Selector!) -> Bool {
        if let externalDelegate {
            return super.responds(to: aSelector) || externalDelegate.responds(to: aSelector)
        }
        return super.responds(to: aSelector)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        page?.handleScrollViewDidScroll(scrollView)
        externalDelegate?.scrollViewDidScroll?(scrollView)
    }
}

// MARK: - 滚动代理桥接器（内部）
fileprivate final class CLStickyPageScrollBridge: NSObject {
    weak var scrollView: UIScrollView?
    weak var page: CLStickyViewPage?

    private var proxy: CLStickyPageScrollProxy?

    init(scrollView: UIScrollView, page: CLStickyViewPage) {
        self.scrollView = scrollView
        self.page = page
        super.init()

        scrollView.addObserver(self, forKeyPath: "delegate", options: [.new], context: nil)
        updateDelegate(scrollView.delegate)
    }

    deinit {
        scrollView?.removeObserver(self, forKeyPath: "delegate")
    }

    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard keyPath == "delegate" else { return }
        updateDelegate(scrollView?.delegate)
    }

    private func updateDelegate(_ delegate: UIScrollViewDelegate?) {
        guard let scrollView, let page else { return }
        guard !(delegate is CLStickyPageScrollProxy) else { return }

        if proxy == nil {
            proxy = CLStickyPageScrollProxy()
            proxy?.page = page
        }

        proxy?.externalDelegate = delegate
        scrollView.delegate = proxy
    }
}

fileprivate struct AssociatedKeys {
    static var isSwipeEnabled: Void?
    static var superScrollEnabledHandler: Void?
    static var scrollBridge: Void?
}
