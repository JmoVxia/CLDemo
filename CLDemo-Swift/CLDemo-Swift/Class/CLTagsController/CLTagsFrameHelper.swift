//
//  CLTagsFrame.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/2.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLTagsFrameConfigure: NSObject {
    /// 标签最大宽度
    var maxWidth: CGFloat = 0.0
    /// 单个标签高度
    var tagHeight: CGFloat = 30.0
    /// 标签间距
    var tagsMargin: CGFloat = 10.0
    /// 标签行间距
    var tagsLineSpacing: CGFloat = 10.0
    /// 标签最小内边距
    var tagsMinPadding: CGFloat = 10.0
    /// 标签内部字体大小
    var tagsTitleFont: UIFont = PingFangSCMedium(15)
    /// 是否对齐
    var isAlignment: Bool = true
    /// 默认配置
    class func defaultConfigure() -> CLTagsFrameConfigure {
        let configure = CLTagsFrameConfigure()
        return configure
    }
}

class CLTagsFrameHelper {
    
    /// 计算标签frame
    /// - Parameters:
    ///   - configure: 标签配置
    ///   - tagsArray: 标签数组
    /// - Returns: 计算后标签frame数组，总高度
    class func calculateTagsFrame(configure: ((CLTagsFrameConfigure) -> ()), tagsArray: [String]) -> (tagsFrames: [CGRect], tagsHeight: CGFloat) {
        let defaultConfigure = CLTagsFrameConfigure.defaultConfigure()
        configure(defaultConfigure)
        var tagsFrames: [CGRect] = [CGRect]()
        var tagsHeight: CGFloat = 0.0
        var textX = defaultConfigure.tagsMargin
        var textWidht: CGFloat = 0
        var nextWidth: CGFloat = 0
        var moreWidth: CGFloat = 0
        var lastIndexs: [Int] = []
        var moreWidths: [CGFloat] = []
        let attributedFont: [NSAttributedString.Key : Any] = [.font : defaultConfigure.tagsTitleFont]
        for i in 0..<tagsArray.count {
            textWidht = ceil((tagsArray[i] as NSString).size(withAttributes: attributedFont).width) + defaultConfigure.tagsMinPadding * 2
            if i < tagsArray.count - 1 {
                nextWidth = ceil((tagsArray[i + 1] as NSString).size(withAttributes: attributedFont).width) + defaultConfigure.tagsMinPadding * 2
            }
            let nextX: CGFloat = textX + textWidht + defaultConfigure.tagsMargin
            if (nextX + nextWidth) > (defaultConfigure.maxWidth - defaultConfigure.tagsMargin) {
                moreWidth = defaultConfigure.maxWidth - nextX
                lastIndexs.append(i)
                moreWidths.append(defaultConfigure.isAlignment ? moreWidth : 0)
                textX = defaultConfigure.tagsMargin
            } else {
                textX += textWidht + defaultConfigure.tagsMargin
            }
            if i == tagsArray.count - 1 {
                if !lastIndexs.contains(i) {
                    lastIndexs.append(i)
                    moreWidths.append(0)
                }
            }
        }
        var location = 0
        var length = 0
        var averageWidth: CGFloat = 0
        var tagWidth: CGFloat = 0
        for i in 0..<lastIndexs.count {
            let lastIndex = lastIndexs[i]
            length = i == 0 ? (lastIndex + 1) : (lastIndexs[i] - lastIndexs[i - 1])
            let rowArray = tagsArray[location..<(min(length + location, tagsArray.count))]
            location = lastIndex + 1
            averageWidth = moreWidths[i] / CGFloat(rowArray.count)
            var tagX = defaultConfigure.tagsMargin
            let tagY = CGFloat(defaultConfigure.tagsLineSpacing + (defaultConfigure.tagsLineSpacing + defaultConfigure.tagHeight) * CGFloat(i))
            for item in rowArray {
                tagWidth = ceil((item as NSString).size(withAttributes: attributedFont).width) + defaultConfigure.tagsMinPadding * 2 + averageWidth
                tagWidth = min(tagWidth, defaultConfigure.maxWidth - defaultConfigure.tagsMargin * 2)
                let frame = CGRect(x: tagX, y: tagY, width: tagWidth, height: defaultConfigure.tagHeight)
                tagsFrames.append(frame)
                tagX += tagWidth + defaultConfigure.tagsMargin
            }
        }
        tagsHeight = (defaultConfigure.tagHeight + defaultConfigure.tagsLineSpacing) * CGFloat(lastIndexs.count) + defaultConfigure.tagsLineSpacing
        return (tagsFrames, tagsHeight)
    }
}
