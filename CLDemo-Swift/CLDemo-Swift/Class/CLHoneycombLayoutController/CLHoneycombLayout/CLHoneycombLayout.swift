//
//  CLHoneycombLayout.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/8/13.
//

import UIKit

class CLHoneycombLayout: UICollectionViewFlowLayout {
    var itemsPerRow: Int = 4
    private var itemWidth: CGFloat = .zero
    private var itemHeight: CGFloat = .zero
    private var itemSideLength: CGFloat = .zero
    private var itemsPerGroup: Int = .zero
    private var heightOfGroup: CGFloat = .zero
    private var contentSize: CGSize = .zero
    private var items: Int = 0
    private var attributesArray: [UICollectionViewLayoutAttributes]?
}
extension CLHoneycombLayout {
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        scrollDirection = .vertical
        attributesArray = nil

        itemWidth = (collectionView.bounds.width - minimumInteritemSpacing * CGFloat(itemsPerRow - 1) - collectionView.contentInset.left - collectionView.contentInset.right) / CGFloat(itemsPerRow)
        itemSideLength = itemWidth / sqrt(3)
        itemHeight = itemSideLength * 2
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        heightOfGroup = itemSideLength + itemSize.height + 2 * minimumLineSpacing
        itemsPerGroup = itemsPerRow + itemsPerRow - 1
        
        items = collectionView.numberOfItems(inSection: 0)
        
        contentSize = {
            let group = CGFloat(items / itemsPerGroup)
            let groupModulo = items % itemsPerGroup
            let residualRow = (groupModulo <= (itemsPerRow - 1)) ? 1 : 2
            let residualHeight: CGFloat = {
                if groupModulo == 0 {
                    return itemHeight * 0.25
                }else if residualRow == 2 {
                    return heightOfGroup + itemHeight * 0.25
                }else {
                    return itemHeight
                }
            }()
            return CGSize(width: collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right, height: group * heightOfGroup + residualHeight)
        }()
    }
}
extension CLHoneycombLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attributesArray = attributesArray {
            return attributesArray
        }else {
            attributesArray = Array(0..<items).compactMap({layoutAttributesForItem(at: IndexPath(item: $0, section: 0))})
            return attributesArray
        }
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let groupIndex: Int = indexPath.row / itemsPerGroup
        let indexInGroup: Int = indexPath.row % itemsPerGroup
        let isFirstLine: Bool = indexInGroup < Int(itemsPerGroup / 2)
        let indexInLine: Int = isFirstLine ? indexInGroup : indexInGroup - Int(itemsPerGroup / 2)
        
        let x = (itemSize.width) * (CGFloat(indexInLine) + (isFirstLine ? 0.5 : 0)) + CGFloat(indexInLine) * minimumInteritemSpacing + (isFirstLine ? minimumInteritemSpacing * 0.5 : 0)
        let y = (itemSize.height) * (isFirstLine ? 0 : 0.75) + heightOfGroup * CGFloat(groupIndex) + (isFirstLine ? 0 : minimumLineSpacing)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
        return attributes
    }
}
extension CLHoneycombLayout {
    override var itemSize: CGSize {
        get {
            return CGSize(width: itemWidth, height: itemHeight)
        }
        set {
            super.itemSize = newValue
        }
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
}
