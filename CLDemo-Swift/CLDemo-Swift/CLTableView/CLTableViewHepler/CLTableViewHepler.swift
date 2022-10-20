//
//  CKDTableViewHepler.swift
//  CL
//
//  Created by Chen JmoVxia on 2020/9/17.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

extension CLTableViewHepler {
    enum CLDataMode {
        case section
        case row
    }
}

class CLTableViewHepler: NSObject {
    var sections = [CLSectionItemProtocol]()

    var rows = [CLRowItemProtocol]()

    private weak var delegate: UITableViewDelegate?

    var mode: CLDataMode = .row

    init(mode: CLDataMode = .row, delegate: UITableViewDelegate? = nil) {
        self.mode = mode
        self.delegate = delegate
        super.init()
    }

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

// MARK: - JmoVxia---UITableViewDelegate

extension CLTableViewHepler: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:didSelectRowAt:))) {
            delegate.tableView?(tableView, didSelectRowAt: indexPath)
        }
        itemForIndexPath(indexPath)?.didSelectCellCallback?(indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:heightForRowAt:))) {
            return delegate.tableView?(tableView, heightForRowAt: indexPath) ?? UITableView.automaticDimension
        } else {
            return itemForIndexPath(indexPath)?.cellHeight() ?? .zero
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:willDisplay:forRowAt:))) {
            delegate.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
        }
        itemForIndexPath(indexPath)?.willDisplayCallback?(indexPath)
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:didEndDisplaying:forRowAt:))) {
            delegate.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
        }
        itemForIndexPath(indexPath)?.didEndDisplayingCallback?(indexPath)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:heightForHeaderInSection:))) {
            return delegate.tableView?(tableView, heightForHeaderInSection: section) ?? UITableView.automaticDimension
        } else {
            return sections[safe: section]?.headerHeight() ?? .zero
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:willDisplayHeaderView:forSection:))) {
            delegate.tableView?(tableView, willDisplayHeaderView: view, forSection: section)
        }
        sections[safe: section]?.willDisplayHeaderViewCallback?(section)
    }

    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:didEndDisplayingHeaderView:forSection:))) {
            delegate.tableView?(tableView, didEndDisplayingHeaderView: view, forSection: section)
        }
        sections[safe: section]?.didEndDisplayingHeaderViewCallback?(section)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:heightForFooterInSection:))) {
            return delegate.tableView?(tableView, heightForFooterInSection: section) ?? UITableView.automaticDimension
        } else {
            return sections[safe: section]?.footerHeight() ?? .zero
        }
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:willDisplayHeaderView:forSection:))) {
            delegate.tableView?(tableView, willDisplayHeaderView: view, forSection: section)
        }
        sections[safe: section]?.willDisplayFooterViewCallback?(section)
    }

    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:didEndDisplayingFooterView:forSection:))) {
            delegate.tableView?(tableView, didEndDisplayingFooterView: view, forSection: section)
        }
        sections[safe: section]?.didEndDisplayingFooterViewCallback?(section)
    }
}

// MARK: - JmoVxia---UITableViewDataSource

extension CLTableViewHepler: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mode {
        case .section:
            return sections[safe: section]?.rows.count ?? .zero
        case .row:
            return rows.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = itemForIndexPath(indexPath) else { return UITableViewCell() }
        item.cellForRowCallback?(indexPath)
        let cellClass = item.cellClass()
        let identifier = "\(cellClass)"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? cellClass.init(style: .default, reuseIdentifier: identifier)
        (cell as? CLCellBaseProtocol)?.set(item: item, indexPath: indexPath)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        switch mode {
        case .section:
            return sections.count
        case .row:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = sections[safe: section] else { return nil }
        guard let viewClass = item.headerClass() else { return nil }
        item.viewForHeaderInSectionCallback?(section)
        let identifier = "\(viewClass)"
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) ?? viewClass.init(reuseIdentifier: identifier)
        view.tag = section
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectHeaderView(_:))))
        view.isUserInteractionEnabled = true
        (view as? CLSectionBaseProtocol)?.set(item: item, section: section)
        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let item = sections[safe: section] else { return nil }
        guard let viewClass = item.footerClass() else { return nil }
        item.viewForFooterInSectionCallback?(section)
        let identifier = "\(viewClass)"
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) ?? viewClass.init(reuseIdentifier: identifier)
        view.tag = section
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectFooterView(_:))))
        view.isUserInteractionEnabled = true
        (view as? CLSectionBaseProtocol)?.set(item: item, section: section)
        return view
    }
}

@objc private extension CLTableViewHepler {
    func didSelectHeaderView(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let view = gestureRecognizer.view as? UITableViewHeaderFooterView else { return }
        guard let item = sections[safe: view.tag] else { return }
        item.didSelectHeaderViewCallback?(view.tag)
    }

    func didSelectFooterView(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let view = gestureRecognizer.view as? UITableViewHeaderFooterView else { return }
        guard let item = sections[safe: view.tag] else { return }
        item.didSelectFooterViewCallback?(view.tag)
    }
}

private extension CLTableViewHepler {
    func itemForIndexPath(_ indexPath: IndexPath) -> CLRowItemProtocol? {
        switch mode {
        case .section:
            return sections[safe: indexPath.section]?.rows[safe: indexPath.row]
        case .row:
            return rows[safe: indexPath.row]
        }
    }
}
