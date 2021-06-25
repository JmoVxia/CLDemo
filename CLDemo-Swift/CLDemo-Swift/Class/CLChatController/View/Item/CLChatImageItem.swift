//
//  CLChatImageItem.swift
//  Potato
//
//  Created by AUG on 2019/10/14.
//

import UIKit

class CLChatImageItem: CLChatItem {
    ///图片原始大小
    var imageOriginalSize = CGSize.zero {
        didSet {
            let width = screenWidth * 0.45
            size = calculateScaleFrame(imageSize: imageOriginalSize, maxSize: CGSize(width: width, height: width), minSize: CGSize(width: width * 0.75, height: width * 0.75))
        }
    }
    ///图片缩放后大小
    private (set) var size = CGSize.zero
    ///图片本地地址
    var imagePath: String?
    ///文件id
    var fid: String = ""
    ///文件大小
    var fileSize: Int32 = 0
}
extension CLChatImageItem: CLCellItemProtocol {
    func bindCell() -> UITableViewCell.Type {
        return CLChatImageCell.self
    }
}
extension CLChatImageItem {
    private func calculateScaleFrame(imageSize: CGSize, maxSize: CGSize, minSize: CGSize) -> CGSize {
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0
        
        let maxWidth = maxSize.width
        let maxHeight = maxSize.height
        let minWidth = minSize.width
        let minHeight = minSize.height
        
        let imageWidth = imageSize.width
        let imageHeight = imageSize.height
        
        let widthSatisfy: Bool = minWidth <= imageWidth && imageWidth <= maxWidth
        let heightSatisfy: Bool = minHeight <= imageHeight && imageHeight <= maxHeight

        if widthSatisfy && heightSatisfy {
            return imageSize
        }
        
        let widthSpace = fabsf(Float(maxWidth - imageWidth))
        let heightSpace = fabsf(Float(maxHeight - imageHeight))
        
        if (widthSpace >= heightSpace) {
            if (maxWidth > imageWidth) {
                width = imageWidth * (maxHeight / imageHeight)
                height = imageHeight * (maxHeight / imageHeight)
            }else {
                width = imageWidth / (imageWidth / maxWidth)
                height = imageHeight / (imageWidth / maxWidth)
            }
        }else {
            if (maxHeight > imageHeight) {
                width = imageWidth * (maxWidth / imageWidth)
                height = imageHeight * (maxWidth / imageWidth)
            }else {
                width = imageWidth / (imageHeight / maxHeight)
                height = imageHeight / (imageHeight / maxHeight)
            }
        }
        
        var size = CGSize(width: width, height: height)
        if ((maxWidth - width) * 0.5 < 0 || (maxHeight - height) * 0.5 < 0) {
            size = calculateScaleFrame(imageSize: CGSize(width: width, height: height), maxSize: maxSize, minSize: minSize)
        }
        return size
    }
}

