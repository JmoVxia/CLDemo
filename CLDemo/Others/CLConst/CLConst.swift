//
//  CLConst.swift
//  Potato
//
//  Created by AUG on 2018/12/19.
//

import UIKit

    ///屏幕宽
    func cl_screenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    ///屏幕高
    func cl_screenHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    ///状态栏高度
    func cl_statusBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
    ///按照iPhone6宽度等比例缩放
    func cl_scale_iphone6_width(_ width: CGFloat, pt:Bool = true) -> CGFloat {
        return width / 750 * cl_screenWidth() * (pt ? 2.0 : 1.0)
    }
    ///按照iPhone6高度等比例缩放
    func cl_scale_iphone6_height(_ height: CGFloat, pt:Bool = true) -> CGFloat {
        return height / 1334 * cl_screenHeight() * (pt ? 2.0 : 1.0)
    }
    ///安全区域
    func cl_safeAreaInsets() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets.zero
        }else {
            return UIEdgeInsets.zero
        }
    }
    ///是否是ipad
    let cl_iPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    ///判断iPhone4
    let cl_iPhone4 =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 640, height: 960).equalTo((UIScreen.main.currentMode?.size)!) : false)
    ///判断iPhone5系列
    let cl_iPhone5 =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 640, height: 1136).equalTo((UIScreen.main.currentMode?.size)!) : false)
    ///判断iPhone6系列
    let cl_iPhone6 =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 750, height: 1334).equalTo((UIScreen.main.currentMode?.size)!) : false)
    ///判断iPhone6Plus
    let cl_iPhone6Plus =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1242, height: 2208).equalTo((UIScreen.main.currentMode?.size)!) : false)
    ///判断iPhoneX
    let cl_iPhoneX =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1125, height: 2436).equalTo((UIScreen.main.currentMode?.size)!) : false)
    ///判断iPhoneXr
    let cl_iPhoneXr =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 828, height: 1792).equalTo((UIScreen.main.currentMode?.size)!) : false)
    ///判断iPhoneXs
    let cl_iPhoneXs =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1125, height: 2436).equalTo((UIScreen.main.currentMode?.size)!) : false)
    ///判断iPhoneXsMax
    let cl_iPhoneXsMax =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1242, height: 2688).equalTo((UIScreen.main.currentMode?.size)!) : false)
    ///判断iPhoneX系列
    func cl_iPhoneX_Xr_Xs_XsMax() -> Bool {
        return cl_iPhoneX || cl_iPhoneXr || cl_iPhoneXs || cl_iPhoneXsMax
    }

