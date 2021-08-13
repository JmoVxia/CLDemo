//
//  HexagonalViewItemAppearance.swift
//  Hexacon
//
//  Created by Gautier Gdx on 05/03/16.
//  Copyright © 2016 Gautier. All rights reserved.
//

import UIKit

public enum HexagonalAnimationType { case Spiral, Circle, None }

public struct HexagonalItemViewAppearance {
    
    //item appearance
    public let needToConfigureItem: Bool
    public let itemSize: CGFloat
    public let itemSpacing: CGFloat
    public let itemBorderWidth: CGFloat
    public let itemBorderColor: UIColor
    
    //animation
    public let animationType: HexagonalAnimationType
    public let animationDuration: TimeInterval
    
    public init(needToConfigureItem: Bool,
            itemSize: CGFloat,
            itemSpacing: CGFloat,
            itemBorderWidth: CGFloat,
            itemBorderColor: UIColor,
            animationType: HexagonalAnimationType,
            animationDuration: TimeInterval) {
        
        self.needToConfigureItem = needToConfigureItem
        self.itemSize = itemSize
        self.itemSpacing = itemSpacing
        self.itemBorderWidth = itemBorderWidth
        self.itemBorderColor = itemBorderColor
        self.animationType = animationType
        self.animationDuration = animationDuration
    }
    
    static func defaultAppearance() -> HexagonalItemViewAppearance {
        return HexagonalItemViewAppearance(needToConfigureItem: true,
            itemSize: 50,
            itemSpacing: 0,
            itemBorderWidth: 0,
            itemBorderColor: .red,
            animationType: .Circle,
            animationDuration: 0.2)
    }
}

