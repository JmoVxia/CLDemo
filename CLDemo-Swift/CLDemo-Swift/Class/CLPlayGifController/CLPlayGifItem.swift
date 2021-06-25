//
//  CLPlayGifItem.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/5/31.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

class CLPlayGifItem: NSObject {
    let path: String!
    private (set) var size: CGSize = .zero
    init(path: String) {
        self.path = path
        guard let data = NSData(contentsOfFile: path),
              let imageSource = CGImageSourceCreateWithData(data, nil),
              let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            return
        }
        size = calculateScaleSize(imageSize: CGSize(width: image.width, height: image.height))
    }
}
extension CLPlayGifItem: CLCellItemProtocol {
    func bindCell() -> UITableViewCell.Type {
        return CLPlayGifCell.self
    }
    func cellHeight() -> CGFloat {
        return size.height + 60
    }
}
