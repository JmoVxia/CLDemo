//
//  AutoScale+Extension.swift
//  CL
//
//  Created by JmoVxia on 2020/4/24.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

enum InchWidth: Double {
    case iPhone5 = 320
    case iPhone6 = 375
    static var iPhoneX: InchWidth {
        return .iPhone6
    }
}
enum InchHeight: Double {
    case iPhone5 = 568
    case iPhone6 = 667
    case iPhoneX = 812
}
extension Double {
    private func rounded(_ decimalPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(max(0, decimalPlaces)))
        return (self * divisor).rounded() / divisor
    }
    func autoWidth(_ inch: InchWidth = .iPhone6) -> Double {
        guard UIDevice.current.userInterfaceIdiom == .phone else {
            return self
        }
        let base = inch.rawValue
        let screenWidth = Double(UIScreen.main.bounds.width)
        let screenHeight = Double(UIScreen.main.bounds.height)
        let width = min(screenWidth, screenHeight) - Double(safeAreaEdgeInsets.left - safeAreaEdgeInsets.right)
        return (self * (width / base)).rounded(3)
    }
    func autoHeight(_ inch: InchHeight = .iPhone6) -> Double {
        guard UIDevice.current.userInterfaceIdiom == .phone else {
            return self
        }
        let base = inch.rawValue
        let screenWidth = Double(UIScreen.main.bounds.width)
        let screenHeight = Double(UIScreen.main.bounds.height)
        let height = max(screenWidth, screenHeight) - Double(safeAreaEdgeInsets.top - safeAreaEdgeInsets.bottom)
        return (self * (height / base)).rounded(3)
    }
}

extension BinaryInteger {
    func autoWidth(_ inch: InchWidth = .iPhone6) -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.autoWidth(inch)
    }
    func autoWidth<T: BinaryInteger>(_ inch: InchWidth = .iPhone6) -> T {
        let temp = Double("\(self)") ?? 0
        return T(temp.autoWidth(inch))
    }
    func autoWidth<T: BinaryFloatingPoint>(_ inch: InchWidth = .iPhone6) -> T {
        let temp = Double("\(self)") ?? 0
        return T(temp.autoWidth(inch))
    }
    func autoHeight(_ inch: InchHeight = .iPhone6) -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.autoHeight(inch)
    }
    func autoHeight<T: BinaryInteger>(_ inch: InchHeight = .iPhone6) -> T {
        let temp = Double("\(self)") ?? 0
        return T(temp.autoHeight(inch))
    }
    func autoHeight<T: BinaryFloatingPoint>(_ inch: InchHeight = .iPhone6) -> T {
        let temp = Double("\(self)") ?? 0
        return T(temp.autoHeight(inch))
    }
}

extension BinaryFloatingPoint {
    func autoWidth(_ inch: InchWidth = .iPhone6) -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.autoWidth(inch)
    }
    func autoWidth<T: BinaryInteger>(_ inch: InchWidth = .iPhone6) -> T {
        let temp = Double("\(self)") ?? 0
        return T(temp.autoWidth(inch))
    }
    func autoWidth<T: BinaryFloatingPoint>(_ inch: InchWidth = .iPhone6) -> T {
        let temp = Double("\(self)") ?? 0
        return T(temp.autoWidth(inch))
    }
    func autoHeight(_ inch: InchHeight = .iPhone6) -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.autoHeight(inch)
    }
    func autoHeight<T: BinaryInteger>(_ inch: InchHeight = .iPhone6) -> T {
        let temp = Double("\(self)") ?? 0
        return T(temp.autoHeight(inch))
    }
    func autoHeight<T: BinaryFloatingPoint>(_ inch: InchHeight = .iPhone6) -> T {
        let temp = Double("\(self)") ?? 0
        return T(temp.autoHeight(inch))
    }
}
extension CGSize {
    func autoWidth(_ inch: InchWidth = .iPhone6) -> CGSize {
        return CGSize(width: width.autoWidth(), height: height.autoWidth())
    }
    func autoHeight(_ inch: InchHeight = .iPhone6) -> CGSize {
        return CGSize(width: width.autoHeight(), height: height.autoHeight())
    }
}
