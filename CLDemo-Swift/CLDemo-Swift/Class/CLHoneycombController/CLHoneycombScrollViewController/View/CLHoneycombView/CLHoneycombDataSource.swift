//
//  CLHoneycombDataSource.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/8/16.
//

import Foundation

protocol CLHoneycombDataSource: AnyObject {
    func honeycombView(_ honeycombView: CLHoneycombView, cellForRowAtIndex index: Int) -> CLHoneycombCell

    func honeycombViewNumberOfItems(_ honeycombView: CLHoneycombView) -> Int

    func honeycombViewNumberOfItemsPerRow(_ honeycombView: CLHoneycombView) -> Int
}
