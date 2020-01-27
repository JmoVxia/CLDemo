//
//  CLChatEmojiItemProtocol.swift
//  Potato
//
//  Created by AUG on 2019/10/30.
//

import Foundation

protocol CLChatEmojiItemProtocol:class {
    ///创建cell
    func dequeueReusableCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    ///cell类型
    func reuseIdentifier() -> String
}
extension CLChatEmojiItemProtocol {
    func dequeueReusableCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier(), for: indexPath)
        if let collectionViewCell = cell as? CLChatEmojiCellProtocol {
            collectionViewCell.updateItem(item: self)
        }
        return cell
    }
}
