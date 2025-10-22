//
//  CLTableViewSectionManager.swift
//  CLTableViewSectionManager
//
//  Created by JmoVxia on 2025/10/16.
//

import UIKit

public class CLTableViewSectionManager: CLTableViewManager {
    public var dataSource: [CLSectionItemProtocol] = []
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.dataSource[safe: section]?.rows.count ?? .zero
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        self.dataSource.count
    }

    override func sectionItem(for section: Int) -> CLSectionItemProtocol? {
        return self.dataSource[safe: section]
    }

    override func itemForIndexPath(_ indexPath: IndexPath) -> CLRowItemProtocol? {
        self.dataSource[safe: indexPath.section]?.rows[safe: indexPath.row]
    }
}
