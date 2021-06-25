//
//  CLTableViewHepler.swift
//  CKD
//
//  Created by Chen JmoVxia on 2020/9/17.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLTableViewHepler: NSObject {
    var dataSource = [CLCellItemProtocol]()
    private weak var delegate: UITableViewDelegate?
    init(delegate: UITableViewDelegate? = nil) {
        self.delegate = delegate
    }
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if super.responds(to: aSelector) {
            return self
        }else if let delegate = delegate, delegate.responds(to: aSelector) {
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
            delegate.tableView!(tableView, didSelectRowAt: indexPath)
        }else {
            dataSource[indexPath.row].didSelectCellCallback?(indexPath)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:heightForRowAt:))) {
            return delegate.tableView!(tableView, heightForRowAt: indexPath)
        }else {
            return dataSource[indexPath.row].cellHeight()
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let delegate = delegate, delegate.responds(to: #selector(tableView(_:willDisplay:forRowAt:))) {
            delegate.tableView!(tableView, willDisplay: cell, forRowAt: indexPath)
        }else {
            dataSource[indexPath.row].willDisplayCallback?(indexPath)
        }
    }
}
//MARK: - JmoVxia---UITableViewDataSource
extension CLTableViewHepler: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource[indexPath.row]
        item.cellForRowCallback?(indexPath)
        return item.dequeueReusableCell(tableView: tableView, indexPath: indexPath)
    }
}
