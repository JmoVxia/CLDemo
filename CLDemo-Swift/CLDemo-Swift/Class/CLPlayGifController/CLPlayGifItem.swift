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
    private(set) var size: CGSize = .zero
    init(path: String) {
        self.path = path
        guard let data = NSData(contentsOfFile: path),
              let imageSource = CGImageSourceCreateWithData(data, nil),
              let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            return
        }
        size = calculateScaleSize(size: CGSize(width: image.width, height: image.height)).applying(.init(scaleX: 0.8, y: 0.8))
    }
}

extension CLPlayGifItem: CLRowItemProtocol {
    var cellType: UITableViewCell.Type {
        CLPlayGifCell.self
    }

    var cellHeight: CGFloat {
        size.height + 60
    }
}
