import Foundation
import UIKit

// MARK: - 滚动代理转发器（内部使用）
fileprivate class CLScrollViewDelegateProxy: NSObject, UIScrollViewDelegate {
    weak var externalDelegate: UIScrollViewDelegate?
    weak var nestedTarget: CLNestedSlideViewPage?
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if super.responds(to: aSelector) {
            return self
        } else if let externalDelegate = externalDelegate, externalDelegate.responds(to: aSelector) {
            return externalDelegate
        }
        return self
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        if let externalDelegate = externalDelegate {
            return super.responds(to: aSelector) || externalDelegate.responds(to: aSelector)
        }
        return super.responds(to: aSelector)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        nestedTarget?.handleScrollViewDidScroll(scrollView)
        externalDelegate?.scrollViewDidScroll?(scrollView)
    }
}

// MARK: - 滚动视图包装器（内部使用）
fileprivate class CLScrollViewWrapper: NSObject {
    weak var scrollView: UIScrollView?
    weak var nestedTarget: CLNestedSlideViewPage?
    private var proxy: CLScrollViewDelegateProxy?
    
    init(scrollView: UIScrollView, nestedTarget: CLNestedSlideViewPage) {
        self.scrollView = scrollView
        self.nestedTarget = nestedTarget
        super.init()
        
        scrollView.addObserver(self, forKeyPath: "delegate", options: [.new], context: nil)
        handleDelegateChange(scrollView.delegate)
    }
    
    deinit {
        scrollView?.removeObserver(self, forKeyPath: "delegate")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "delegate", let newDelegate = change?[.newKey] as? UIScrollViewDelegate {
            handleDelegateChange(newDelegate)
        }
    }
    
    private func handleDelegateChange(_ newDelegate: UIScrollViewDelegate?) {
        guard let scrollView = scrollView, let nestedTarget = nestedTarget else { return }
        
        if newDelegate is CLScrollViewDelegateProxy { return }
        
        if proxy == nil {
            proxy = CLScrollViewDelegateProxy()
            proxy?.nestedTarget = nestedTarget
        }
        
        proxy?.externalDelegate = newDelegate
        scrollView.delegate = proxy
    }
}

fileprivate struct AssociatedKeys {
    static var isSwipeEnabledKey: Void?
    static var superScrollEnabledHandlerKey: Void?
    static var scrollViewWrapperKey: Void?
}

// MARK: - 页面协议
public protocol CLNestedSlideViewPage: AnyObject where Self: UIView {
    /// 必须实现：返回内部滚动视图
    var scrollView: UIScrollView { get }
}

// MARK: - 页面协议扩展（框架自动处理）
extension CLNestedSlideViewPage {
    /// 是否允许滑动（由框架自动管理）
    public var isSwipeEnabled: Bool {
        get { 
            objc_getAssociatedObject(self, &AssociatedKeys.isSwipeEnabledKey) as? Bool ?? false 
        }
        set { 
            objc_setAssociatedObject(self, &AssociatedKeys.isSwipeEnabledKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) 
        }
    }
    /// 父级滑动状态回调（由框架自动管理）
    public var superScrollEnabledHandler: ((Bool) -> Bool)? {
        get { 
            objc_getAssociatedObject(self, &AssociatedKeys.superScrollEnabledHandlerKey) as? ((Bool) -> Bool) 
        }
        set { 
            objc_setAssociatedObject(self, &AssociatedKeys.superScrollEnabledHandlerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) 
        }
    }
    /// 设置滚动代理（由框架自动调用）
    public func setupScrollViewDelegateIfNeeded() {
        guard objc_getAssociatedObject(self, &AssociatedKeys.scrollViewWrapperKey) == nil else { return }
        
        let wrapper = CLScrollViewWrapper(scrollView: scrollView, nestedTarget: self)
        objc_setAssociatedObject(self, &AssociatedKeys.scrollViewWrapperKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

// MARK: - 内部滚动协调实现
fileprivate extension CLNestedSlideViewPage {
    /// 内部滚动事件处理（框架自动调用）
    func handleScrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isSwipeEnabled else {
            scrollView.contentOffset.y = 0
            return
        }
        
        guard scrollView.contentOffset.y <= 0 else { return }
        guard let superScrollEnabledHandler = superScrollEnabledHandler, 
              !superScrollEnabledHandler(true) else { return }
        
        isSwipeEnabled = false
    }
}
