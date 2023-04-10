//
//  CLMultiModel.swift
//  CLDemo-Swift
//
//  Created by JmoVxia on 2023/3/28.
//

import SwiftyJSON
import UIKit

struct CLMultiModel {
    var name: String
    var children: [CLMultiModel]
    init(json: JSON) {
        name = json["name"].stringValue
        children = json["children"].arrayValue.compactMap { .init(json: $0) }
    }
}
