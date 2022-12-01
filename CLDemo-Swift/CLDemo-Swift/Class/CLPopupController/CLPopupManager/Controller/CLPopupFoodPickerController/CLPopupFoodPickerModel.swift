//
//  CLPopupFoodPickerModel.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/13.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import SwiftyJSON

struct CLPopupFoodPickerModel  {
    var baseGroup = [CLPopupFoodPickerBaseGroup]()
    init(json: JSON) {
        baseGroup = json["baseGroup"].arrayValue.compactMap({ CLPopupFoodPickerBaseGroup(json: $0)})
    }
}

struct CLPopupFoodPickerNutrients {
    ///蛋氨酸（毫克）
    var Met: String
    ///色氨酸（毫克）
    var Trp: String
    ///亮氨酸（毫克）
    var Lle: String
    ///蛋白质（克）
    var Protein: String
    ///多不饱和MUFA（克）
    var PUFA: String
    ///碳水化合物（克）
    var CHO: String
    ///脯氨酸（毫克）
    var Pro: String
    ///天冬氨酸（毫克）
    var Asp: String
    ///钾（毫克）
    var K: String
    ///食物纤维（克）
    var Dietaryfiber: String
    ///钙（毫克）
    var Ca: String
    ///可食部（%）
    var Edible: String
    ///单不饱和MUFA（克）
    var MUFA: String
    ///丝氨酸（毫克）
    var Ser: String
    ///苯丙氨酸（毫克）
    var Phe: String
    ///饱和SFA（克）
    var SFA: String
    ///水
    var Water: String
    ///苏丙氨酸（毫克）
    var Thr: String
    ///甘氨酸（毫克）
    var Gly: String
    ///异亮氨酸（毫克）
    var leu: String
    ///精氨酸（毫克）
    var Arg: String
    ///脂肪（克）
    var Fat: String
    ///胱氨酸（毫克）
    var Cys: String
    ///磷（毫克）
    var P: String
    ///谷氨酸（毫克）
    var Glu: String
    ///铁（毫克）
    var Fe: String
    ///热量（千卡）
    var Energy: String
    ///丙氨酸（毫克）
    var Ala: String
    ///缬氨酸（毫克）
    var Val: String
    ///镁（毫克）
    var Mg: String
    ///组氨酸（毫克）
    var His: String
    ///赖氨酸（毫克）
    var lys: String
    ///酪氨酸（毫克）
    var Tyr: String
    ///钠（毫克）
    var Na: String

    init(json: JSON) {
        Lle = json["Lle"].stringValue
        MUFA = json["MUFA"].stringValue
        Thr = json["Thr"].stringValue
        Fat = json["Fat"].stringValue
        lys = json["lys"].stringValue
        Cys = json["Cys"].stringValue
        Edible = json["Edible"].stringValue
        Energy = json["Energy"].stringValue
        Arg = json["Arg"].stringValue
        Met = json["Met"].stringValue
        Pro = json["Pro"].stringValue
        Gly = json["Gly"].stringValue
        Tyr = json["Tyr"].stringValue
        Glu = json["Glu"].stringValue
        Water = json["Water"].stringValue
        Ser = json["Ser"].stringValue
        His = json["His"].stringValue
        Dietaryfiber = json["Dietaryfiber"].stringValue
        leu = json["leu"].stringValue
        P = json["P"].stringValue
        Protein = json["Protein"].stringValue
        PUFA = json["PUFA"].stringValue
        Ala = json["Ala"].stringValue
        CHO = json["CHO"].stringValue
        Trp = json["Trp"].stringValue
        SFA = json["SFA"].stringValue
        Asp = json["Asp"].stringValue
        Val = json["Val"].stringValue
        Na = json["Na"].stringValue
        Fe = json["Fe"].stringValue
        Phe = json["Phe"].stringValue
        K = json["K"].stringValue
        Mg = json["Mg"].stringValue
        Ca = json["Ca"].stringValue
    }
}

struct CLPopupFoodPickerFoods {
    var foodName: String
    var nutrients: CLPopupFoodPickerNutrients
    var foodId: String

    init(json: JSON) {
        foodName = json["foodName"].stringValue
        nutrients = CLPopupFoodPickerNutrients(json: json["nutrients"])
        foodId = json["foodId"].stringValue
    }
}

struct CLPopupFoodPickerGroup {
    var foodGroupId: String
    var foodGroupName: String
    var foods = [CLPopupFoodPickerFoods]()

    init(json: JSON) {
        foodGroupId = json["foodGroupId"].stringValue
        foodGroupName = json["foodGroupName"].stringValue
        foods = json["foods"].arrayValue.compactMap({ CLPopupFoodPickerFoods(json: $0)})
    }
}

struct CLPopupFoodPickerBaseGroup {
    var foodBaseGroupName: String
    var group = [CLPopupFoodPickerGroup]()

    init(json: JSON) {
        foodBaseGroupName = json["foodBaseGroupName"].stringValue
        group = json["group"].arrayValue.compactMap({ CLPopupFoodPickerGroup(json: $0)})
    }
}
