//
//  CLTableViewRowManager.swift
//  CLTableViewRowManager
//
//  Created by JmoVxia on 2025/10/16.
//

import UIKit

public class CLTableViewRowManager: CLTableViewManager {
    public var dataSource: [CLRowItemProtocol] = []
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.dataSource.count
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func itemForIndexPath(_ indexPath: IndexPath) -> CLRowItemProtocol? {
        self.dataSource[safe: indexPath.row]
    }
}
