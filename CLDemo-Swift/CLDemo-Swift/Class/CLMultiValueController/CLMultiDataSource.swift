//
//  CLMultiDataSource.swift
//  CLDemo-Swift
//
//  Created by JmoVxia on 2023/3/25.
//

import Foundation

protocol CLMultiDataSource: AnyObject {
    func multiController(_ controller: CLMultiController, didSelectRowAt indexPath: CLMultiIndexPath) -> String
    func multiController(_ controller: CLMultiController, isCompletedAt indexPath: CLMultiIndexPath) -> Bool
    func multiController(_ controller: CLMultiController, numberOfItemsInColumn column: Int) -> Int
    func multiController(_ controller: CLMultiController, tableView: UITableView, cellForRowAt indexPath: CLMultiIndexPath) -> UITableViewCell
}
