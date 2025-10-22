//
//  CLPlayVideoitem.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/4/28.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import AVFoundation
import UIKit

class CLPlayVideoitem: NSObject {
    let path: String!
    private(set) var size: CGSize = .zero
    init(path: String) {
        self.path = path

        let asset = AVURLAsset(url: URL(fileURLWithPath: path), options: nil)
        let generate = AVAssetImageGenerator(asset: asset)
        generate.appliesPreferredTrackTransform = true
        guard let oneRef = try? generate.copyCGImage(at: CMTimeMake(value: 1, timescale: 2), actualTime: nil) else { return }
        size = calculateScaleSize(size: CGSize(width: oneRef.width, height: oneRef.height))
    }
}

extension CLPlayVideoitem: CLRowItemProtocol {
    var cellType: UITableViewCell.Type {
        CLPlayVideoCell.self
    }

    var cellHeight: CGFloat {
        size.height + 60
    }
}
