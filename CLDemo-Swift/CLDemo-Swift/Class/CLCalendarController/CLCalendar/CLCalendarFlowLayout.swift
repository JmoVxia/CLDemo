//
//  CLCalendarFlowLayout.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2022/10/19.
//

import UIKit

class CLCalendarFlowLayout: UICollectionViewFlowLayout {
    private var decorationViewAttributes: [UICollectionViewLayoutAttributes] = []

    override init() {
        super.init()
        configUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension CLCalendarFlowLayout {
    func configUI() {
        sectionInset = .zero
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        register(CLCalendarSectionBackgroundView.classForCoder(), forDecorationViewOfKind: CLCalendarSectionBackgroundView.reuseIdentifier)
    }
}

extension CLCalendarFlowLayout {
    override func prepare() {
        super.prepare()
        guard let collectionView else { return }
        guard let delegate = collectionView.delegate as? CLCalendarDelegateFlowLayout else { return }

        decorationViewAttributes.removeAll()

        for section in 0 ..< collectionView.numberOfSections {
            let numberOfItems = collectionView.numberOfItems(inSection: section)

            guard numberOfItems > 0 else { continue }
            guard let firstItem = layoutAttributesForItem(at: IndexPath(item: 0, section: section)) else { continue }
            guard let lastItem = layoutAttributesForItem(at: IndexPath(item: numberOfItems - 1, section: section)) else { continue }

            let sectionInset = delegate.collectionView?(collectionView, layout: self, insetForSectionAt: section) ?? sectionInset

            let sectionFrame: CGRect = {
                let frame = firstItem.frame.union(lastItem.frame)
                let origin = frame.origin
                let size = frame.size
                return .init(origin: .init(x: .zero, y: origin.y - sectionInset.top),
                             size: scrollDirection == .horizontal
                                 ? CGSize(width: sectionInset.left + sectionInset.right + size.width, height: collectionView.frame.height)
                                 : CGSize(width: collectionView.frame.width, height: sectionInset.top + sectionInset.bottom + size.height))
            }()

            let attributes = CLCalendarLayoutAttributes(forDecorationViewOfKind: CLCalendarSectionBackgroundView.reuseIdentifier, with: IndexPath(item: 0, section: section))
            attributes.frame = sectionFrame
            attributes.zIndex = -1
            attributes.month = delegate.collectionView(collectionView, layout: self, textForSectionAt: section)
            attributes.textColor = delegate.collectionView(collectionView, layout: self, textColorForSectionAt: section)
            decorationViewAttributes.append(attributes)
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = super.layoutAttributesForElements(in: rect)
        attributes?.append(contentsOf: decorationViewAttributes.filter { rect.intersects($0.frame) })
        return attributes
    }

    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard elementKind != CLCalendarSectionBackgroundView.reuseIdentifier else { return decorationViewAttributes[indexPath.section] }
        return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
    }
}
