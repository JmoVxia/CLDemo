//
//  CLIngredients.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/12/1.
//

import SwiftyJSON
import UIKit

/// 食材
struct CLIngredients {
    /// 食材编号
    var code: String
    /// 一级id
    var primaryId: Int
    /// 一级名称
    var primaryName: String
    /// 二级id
    var secondaryId: Int
    /// 二级名称
    var secondaryName: String
    /// 三级id，全局唯一
    var tertiaryId: Int
    /// 三级名称
    var tertiaryName: String

    /// 搜索名称
    var searchName: String
    /// 排序一级id
    var sortedPrimary: String
    /// 排序二级级id
    var sortedSecondary: String
    /// 排序三级级id
    var sortedTertiary: String

    init(json: JSON) {
        code = json["code"].stringValue
        primaryId = json["root_category_id"].intValue
        primaryName = json["root_category_name"].stringValue
        secondaryId = json["sub_category_id"].intValue
        secondaryName = json["sub_category_name"].stringValue
        tertiaryId = json["id"].intValue
        tertiaryName = json["name"].stringValue

        let level3Pinyin = CLHanziToPinyin.stringToPinyin(string: tertiaryName, separator: "").long
        let level2Pinyin = CLHanziToPinyin.stringToPinyin(string: secondaryName, separator: "").long
        let primaryPinyin = CLHanziToPinyin.stringToPinyin(string: primaryName, separator: "").long

        searchName = "\(level3Pinyin)+\(tertiaryName)+\(level2Pinyin)+\(secondaryName)+\(primaryPinyin)+\(primaryName)"

        sortedPrimary = "\(primaryId)"
        sortedSecondary = "\(primaryId).\(secondaryId)"
        sortedTertiary = "\(primaryId).\(secondaryId)\(tertiaryId)"
    }

    init(code: String,
         primaryId: Int,
         primaryName: String,
         secondaryId: Int,
         secondaryName: String,
         tertiaryId: Int,
         tertiaryName: String,
         searchName: String,
         sortedPrimary: String,
         sortedSecondary: String,
         sortedTertiary: String)
    {
        self.code = code
        self.primaryId = primaryId
        self.primaryName = primaryName
        self.secondaryId = secondaryId
        self.secondaryName = secondaryName
        self.tertiaryId = tertiaryId
        self.tertiaryName = tertiaryName
        self.searchName = searchName
        self.sortedPrimary = sortedPrimary
        self.sortedSecondary = sortedSecondary
        self.sortedTertiary = sortedTertiary
    }
}
