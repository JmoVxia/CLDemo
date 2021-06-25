//
//  CLRecordVernierCaliperItem.swift
//  CL
//
//  Created by JmoVxia on 2020/5/9.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLRecordVernierCaliperItem: NSObject {
    ///指标类型
    enum physicalType {
        case unKnown
        case sbp
        case dbp
        case glucose
        case height
        case weight
        case pulse
        case heartRate
        case temperature
        case urine
        case respirationRate
    }
    ///指标标准类型
    var type: physicalType = .unKnown
    ///标题
    var title: String = ""
    ///单位
    var unit: String = ""
    ///是否小写单位
    var isSmallUnit: Bool = true
    ///默认值
    var value: CGFloat = 0.0
    ///间隔值，每两条相隔多少值
    var gap: Int = 12
    ///最小值
    var minValue: CGFloat = 0.0
    ///最大值
    var maxValue: CGFloat = 100.0
    ///最小单位
    var minimumUnit: CGFloat = 1
    ///单位间隔
    var unitInterval: Int = 10
    ///数值背景大小
    var valueBackgroundViewSize: CGSize = CGSize(width: 110, height: 40)
    var valueChangeCallback: ((String) -> ())?
}
extension CLRecordVernierCaliperItem: CLCellItemProtocol {
    func bindCell() -> UITableViewCell.Type {
        return CLRecordVernierCaliperCell.self
    }
}
