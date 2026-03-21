//
//  CLTableViewManager.swift
//  CLTableViewManager
//
//  Created by JmoVxia on 2025/10/16.
//

import UIKit

private var tapGestureKey: UInt8 = 0

private extension UITableViewHeaderFooterView {
    var sectionTap: CLSectionTapGestureRecognizer? {
        get { objc_getAssociatedObject(self, &tapGestureKey) as? CLSectionTapGestureRecognizer }
        set { objc_setAssociatedObject(self, &tapGestureKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

private class CLSectionTapGestureRecognizer: UITapGestureRecognizer {
    var session: Int = 0
}

public class CLTableViewManager: NSObject {
    private var lastTapHeaderTime: CFAbsoluteTime = 0
    
    private var lastTapFooterTime: CFAbsoluteTime = 0

    private weak var delegate: UITableViewDelegate?

    typealias dataSource = [CLDataSourceItemProtocol]

    public init(delegate: UITableViewDelegate? = nil) {
        self.delegate = delegate
        super.init()
    }

    func sectionItem(for section: Int) -> CLSectionItemProtocol? {
        nil
    }

    func itemForIndexPath(_ indexPath: IndexPath) -> CLRowItemProtocol? {
        nil
    }
}

extension CLTableViewManager: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:didSelectRowAt:))) {
            delegate.tableView?(tableView, didSelectRowAt: indexPath)
        }
        itemForIndexPath(indexPath)?.didSelect?(indexPath)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:heightForRowAt:))) {
            return delegate.tableView?(tableView, heightForRowAt: indexPath) ?? UITableView.automaticDimension
        } else {
            return itemForIndexPath(indexPath)?.cellHeight ?? .zero
        }
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:willDisplay:forRowAt:))) {
            delegate.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
        }
        itemForIndexPath(indexPath)?.willDisplay?(indexPath)
    }

    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:didEndDisplaying:forRowAt:))) {
            delegate.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
        }
        itemForIndexPath(indexPath)?.didEndDisplaying?(indexPath)
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:heightForHeaderInSection:))) {
            return delegate.tableView?(tableView, heightForHeaderInSection: section) ?? UITableView.automaticDimension
        } else {
            return sectionItem(for: section)?.headerHeight ?? .zero
        }
    }

    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:willDisplayHeaderView:forSection:))) {
            delegate.tableView?(tableView, willDisplayHeaderView: view, forSection: section)
        }
        sectionItem(for: section)?.willDisplayHeader?(section)
    }

    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:didEndDisplayingHeaderView:forSection:))) {
            delegate.tableView?(tableView, didEndDisplayingHeaderView: view, forSection: section)
        }
        sectionItem(for: section)?.didEndDisplayingHeader?(section)
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:heightForFooterInSection:))) {
            return delegate.tableView?(tableView, heightForFooterInSection: section) ?? UITableView.automaticDimension
        } else {
            return sectionItem(for: section)?.footerHeight ?? .zero
        }
    }

    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:willDisplayFooterView:forSection:))) {
            delegate.tableView?(tableView, willDisplayFooterView: view, forSection: section)
        }
        sectionItem(for: section)?.willDisplayFooter?(section)
    }

    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:didEndDisplayingFooterView:forSection:))) {
            delegate.tableView?(tableView, didEndDisplayingFooterView: view, forSection: section)
        }
        sectionItem(for: section)?.didEndDisplayingFooter?(section)
    }
}

extension CLTableViewManager: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        .zero
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = itemForIndexPath(indexPath) else { return UITableViewCell() }
        item.cellForRow?(indexPath)
        let cellClass = item.cellType
        let identifier = "\(cellClass)"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? cellClass.init(style: .default, reuseIdentifier: identifier)
        (cell as? CLRowCellBaseProtocol)?.set(item: item, indexPath: indexPath)
        return cell
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        .zero
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        dequeueReusableHeaderFooterView(for: section, in: tableView, isHeader: true)
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        dequeueReusableHeaderFooterView(for: section, in: tableView, isHeader: false)
    }
}

@objc extension CLTableViewManager {
    func didSelectHeaderView(_ gestureRecognizer: UITapGestureRecognizer) {
        let now = CFAbsoluteTimeGetCurrent()
        guard now - lastTapHeaderTime > 0.5 else { return }
        lastTapHeaderTime = now
        guard let item = sectionItem(for: gestureRecognizer) else { return }
        item.0.didSelectHeader?(item.1)
    }

    func didSelectFooterView(_ gestureRecognizer: UITapGestureRecognizer) {
        let now = CFAbsoluteTimeGetCurrent()
        guard now - lastTapFooterTime > 0.5 else { return }
        lastTapFooterTime = now

        guard let item = sectionItem(for: gestureRecognizer) else { return }
        item.0.didSelectFooter?(item.1)
    }
}

private extension CLTableViewManager {
    func sectionItem(for gestureRecognizer: UITapGestureRecognizer) -> (CLSectionItemProtocol, Int)? {
        guard let tap = gestureRecognizer as? CLSectionTapGestureRecognizer else { return nil }
        guard let item = sectionItem(for: tap.session) else { return nil }
        return (item, tap.session)
    }

    func dequeueReusableHeaderFooterView(for section: Int, in tableView: UITableView, isHeader: Bool) -> UIView? {
        guard let item = sectionItem(for: section) else { return nil }

        let viewType = isHeader ? item.headerViewType : item.footerViewType
        let action = isHeader ? item.viewForHeader : item.viewForFooter
        let selector = isHeader ? #selector(didSelectHeaderView(_:)) : #selector(didSelectFooterView(_:))

        guard let viewClass = viewType else { return nil }

        action?(section)

        let identifier = "\(viewClass)"

        let headerFooterView = {
            if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) {
                return view
            } else {
                let tap = CLSectionTapGestureRecognizer(target: self, action: selector)
                tap.numberOfTapsRequired = 1
                tap.cancelsTouchesInView = false
                tap.delegate = self
                let view = viewClass.init(reuseIdentifier: identifier)
                view.isUserInteractionEnabled = true
                view.contentView.addGestureRecognizer(tap)
                view.sectionTap = tap
                return view
            }
        }()
        headerFooterView.sectionTap?.session = section
        (headerFooterView as? CLSectionHeaderFooterBaseProtocol)?.set(item: item, section: section)
        return headerFooterView
    }
}
extension CLTableViewManager: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let tap = gestureRecognizer as? CLSectionTapGestureRecognizer else { return true }
        guard tap.numberOfTapsRequired == 1 else { return true }
        
        var view: UIView? = touch.view
        while let current = view {
            guard current != gestureRecognizer.view else { return true }
            
            if let control = current as? UIControl, control.isUserInteractionEnabled && control.isEnabled {
                return false
            }
            
            if current.gestureRecognizers?.contains(where: { ($0 as? UITapGestureRecognizer)?.numberOfTapsRequired == 1 }) == true {
                return false
            }

            view = current.superview
        }
        
        return true
    }
}

public extension CLTableViewManager {
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if super.responds(to: aSelector) {
            return self
        } else if let delegate = delegate, delegate.responds(to: aSelector) {
            return delegate
        }
        return self
    }

    override func responds(to aSelector: Selector!) -> Bool {
        if let delegate = delegate {
            return super.responds(to: aSelector) || delegate.responds(to: aSelector)
        }
        return super.responds(to: aSelector)
    }
}

public extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
