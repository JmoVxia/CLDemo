//
//  CLChatEmojiFlowLayout.swift
//  Potato
//
//  Created by AUG on 2019/10/31.
//

import UIKit

class CLChatEmojiFlowLayout: UICollectionViewFlowLayout {
    ///每行个数
    var rowCount: (() -> (Int))!
    ///每列个数
    var itemCountPerRow: (() -> (Int))!
    ///缓存布局
    private var attributesArray = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        attributesArray = [UICollectionViewLayoutAttributes]()
        let sections =  collectionView?.numberOfSections ?? 0
        for section in 0..<sections {
            let items = collectionView?.numberOfItems(inSection: section) ?? 0
            for item in 0..<items {
                let indexPath = IndexPath.init(row: item, section: section)
                let attributes = layoutAttributesForItem(at: indexPath)
                if attributes != nil {
                    attributesArray.append(attributes!)
                }
            }
        }
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let theNewIndexPath = IndexPath(item: calculatePositionWithItem(indexPath.item), section: indexPath.section)
        let layoutAttribute = super.layoutAttributesForItem(at: theNewIndexPath)
        layoutAttribute?.indexPath = indexPath
        return layoutAttribute
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray
    }
}
extension CLChatEmojiFlowLayout {
    private func calculatePositionWithItem(_ item: Int) -> Int {
        let itemCountPerRow = self.itemCountPerRow()
        let rowCount = self.rowCount()
        let page = item / (itemCountPerRow * rowCount)
        let x = item % itemCountPerRow + page * itemCountPerRow
        let y = item / itemCountPerRow - page * rowCount
        let indexItem = x * rowCount + y
        return indexItem
    }
}
