//
//  CLHoneycombContentView.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/8/16.
//

import SnapKit
import UIKit

// MARK: - JmoVxia---类-属性

class CLHoneycombContentView: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var layoutSubviewsCallback: (() -> Void)?
}

extension CLHoneycombContentView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutSubviewsCallback?()
    }
}

extension CLHoneycombContentView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        next?.touchesBegan(touches, with: event)
        super.touchesBegan(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        next?.touchesEnded(touches, with: event)
        super.touchesEnded(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        next?.touchesCancelled(touches, with: event)
        super.touchesCancelled(touches, with: event)
    }
}
