//
//  CLPopupFoodPickerModel.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/13.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import HandyJSON

struct CLPopupFoodPickerModel: HandyJSON {
    var baseGroup = [CLPopupFoodPickerBaseGroup]()
}

struct CLPopupFoodPickerNutrients: HandyJSON {
    var Met: String?
    var Trp: String?
    var Lle: String?
    var Protein: String?
    var PUFA: String?
    var CHO: String?
    var Pro: String?
    var Asp: String?
    var K: String?
    var Dietaryfiber: String?
    var Ca: String?
    var Edible: String?
    var MUFA: String?
    var Ser: String?
    var Phe: String?
    var SFA: String?
    var Water: String?
    var Thr: String?
    var Gly: String?
    var leu: String?
    var Arg: String?
    var Fat: String?
    var Cys: String?
    var P: String?
    var Glu: String?
    var Fe: String?
    var Energy: String?
    var Ala: String?
    var Val: String?
    var Mg: String?
    var His: String?
    var lys: String?
    var Tyr: String?
    var Na: String?
}

struct CLPopupFoodPickerFoods: HandyJSON {
    var nutrients: CLPopupFoodPickerNutrients?
    var foodName: String?
    var foodId: String?
}

struct CLPopupFoodPickerGroup: HandyJSON {
    var foodGroupId: String?
    var foods = [CLPopupFoodPickerFoods]()
    var foodGroupName: String?
}

struct CLPopupFoodPickerBaseGroup: HandyJSON {
    var group = [CLPopupFoodPickerGroup]()
    var foodBaseGroupName: String?
}
