//
//  CLTagsCell.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/5.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLTagsCell: UITableViewCell {
    private var viewArray: [CLTagsView] = [CLTagsView]()
    var tagsItem: CLTagsItem? {
        didSet {
            reSetTags()
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.layer.borderColor = UIColor.red.cgColor
        contentView.layer.borderWidth = 1
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLTagsCell {
        func reSetTags() {
            guard let tagsItem = tagsItem else {
                return
            }
            let count = max(tagsItem.tags.count, viewArray.count)
            for i in 0..<count {
                var tagView: CLTagsView!
                if i < viewArray.count {
                    tagView = viewArray[i]
                }else {
                    tagView = CLTagsView()
                    tagView.label.font = tagsItem.font
                    contentView.addSubview(tagView)
                    viewArray.append(tagView)
                }
                if i < tagsItem.tags.count {
                    tagView.isHidden = false
                    tagView.tagsMinPadding = tagsItem.tagsMinPadding
                    tagView.label.text = tagsItem.tags[i]
                    tagView.frame = tagsItem.tagsFrames[i]
                }else {
                    tagView.isHidden = true
                }
            }
        }
}


