//
//  CLPlayVideoitem.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/4/28.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit
import AVFoundation

class CLPlayVideoitem: NSObject {
    let path: String!
    private (set) var size: CGSize = .zero
    init(path: String) {
        self.path = path
        
        let asset: AVURLAsset = AVURLAsset(url: URL(fileURLWithPath: path), options: nil)
        let generate = AVAssetImageGenerator(asset: asset)
        generate.appliesPreferredTrackTransform = true
        guard let oneRef = try? generate.copyCGImage(at: CMTimeMake(value: 1, timescale: 2), actualTime: nil) else { return }
        size = calculateScaleSize(imageSize: CGSize(width: oneRef.width, height: oneRef.height))
    }
}
extension CLPlayVideoitem: CLCellItemProtocol {
    func bindCell() -> UITableViewCell.Type {
        return CLPlayVideoCell.self
    }
    func cellHeight() -> CGFloat {
        return size.height + 60
    }
}
