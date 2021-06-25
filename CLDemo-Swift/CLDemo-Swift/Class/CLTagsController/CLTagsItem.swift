//
//  CLTagsItem.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/6.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLTagsItem: NSObject {
    private (set) var font: UIFont!
    private (set) var tags: [String]!
    private (set) var tagsMinPadding: CGFloat = 0.0
    
    private (set) var tagsFrames: [CGRect]!
    private (set) var tagsHeight: CGFloat = 0.0
    
    init(with tags: [String], maxWidth: CGFloat, font: UIFont = UIFont.systemFont(ofSize: 15), tagsMinPadding: CGFloat = 10.0, isAlignment: Bool = true) {
        super.init()
        self.tags = tags
        self.font = font
        self.tagsMinPadding = tagsMinPadding
        let tagsInfo = CLTagsFrameHelper.calculateTagsFrame(configure: { (configure) in
            configure.tagsMinPadding = tagsMinPadding
            configure.tagHeight = font.lineHeight + 10
            configure.tagsTitleFont = font
            configure.tagsMargin = 20
            configure.maxWidth = maxWidth
            configure.isAlignment = isAlignment
        }, tagsArray: tags)
        tagsFrames = tagsInfo.tagsFrames
        tagsHeight = tagsInfo.tagsHeight
    }
}
