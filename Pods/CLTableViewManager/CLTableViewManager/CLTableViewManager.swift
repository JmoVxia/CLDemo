//
//  CLTableViewManager.swift
//  CLTableViewManager
//
//  Created by JmoVxia on 2025/10/16.
//

import UIKit

public class CLTableViewManager: NSObject {
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
        guard let item = sectionItem(for: gestureRecognizer) else { return }
        item.0.didSelectHeader?(item.1)
    }

    func didSelectFooterView(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let item = sectionItem(for: gestureRecognizer) else { return }
        item.0.didSelectFooter?(item.1)
    }
}

private extension CLTableViewManager {
    func sectionItem(for gestureRecognizer: UITapGestureRecognizer) -> (CLSectionItemProtocol, Int)? {
        guard let view = gestureRecognizer.view as? UITableViewHeaderFooterView else { return nil }
        guard let item = sectionItem(for: view.tag) else { return nil }
        return (item, view.tag)
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
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
            if let view {
                return view
            } else {
                let view = viewClass.init(reuseIdentifier: identifier)
                view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
                view.isUserInteractionEnabled = true
                return view
            }
        }()

        headerFooterView.tag = section
        (headerFooterView as? CLSectionHeaderFooterBaseProtocol)?.set(item: item, section: section)
        return headerFooterView
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
