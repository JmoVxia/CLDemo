//
//  CLCalendarDelegateFlowLayout.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2022/10/19.
//

import UIKit

protocol CLCalendarDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, textColorForSectionAt section: Int) -> UIColor
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, textForSectionAt section: Int) -> String
}

extension CLCalendarDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, textColorForSectionAt section: Int) -> UIColor {
        return .white
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, textForSectionAt section: Int) -> String {
        return ""
    }
}
