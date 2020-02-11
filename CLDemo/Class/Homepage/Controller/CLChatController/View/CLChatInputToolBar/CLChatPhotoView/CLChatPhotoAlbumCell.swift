//
//  CLChatPhotoAlbumCell.swift
//  CLDemo
//
//  Created by Emma on 2020/2/11.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

enum CLChatPhotoMoveDirection {
    case none
    case up
    case down
    case right
    case left
}
class CLChatPhotoAlbumCell: UICollectionViewCell {
    var lockScollViewCallBack: ((Bool) -> ())?
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    private var endPoint: CGPoint = .zero {
        didSet {
            canSend = endPoint.y < -40
        }
    }
    private var canSend: Bool = false
    private var direction: CLChatPhotoMoveDirection = .none
    private var isOnWindow: Bool = false
    private var gestureMinimumTranslation: CGFloat = 10.0
    private lazy var tipsBackgroundView: UIView = {
        let tipsBackgroundView = UIView()
        tipsBackgroundView.backgroundColor = hexColor("0x323232", alpha: 0.45)
        tipsBackgroundView.isHidden = true
        tipsBackgroundView.clipsToBounds = true
        return tipsBackgroundView
    }()
    private lazy var tipsLabel: UILabel = {
        let tipsLabel = UILabel()
        tipsLabel.textAlignment = .center
        tipsLabel.backgroundColor = UIColor.clear
        tipsLabel.textColor = UIColor.white
        tipsLabel.font = UIFont.systemFont(ofSize: 15)
        tipsLabel.text = "松手发送"
        return tipsLabel
    }()
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
        addPanGestureRecognizer()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        tipsBackgroundView.layer.cornerRadius = tipsBackgroundView.bounds.height * 0.5
    }
}
extension CLChatPhotoAlbumCell {
    private func initUI() {
        contentView.addSubview(imageView)
        imageView.addSubview(tipsBackgroundView)
        tipsBackgroundView.addSubview(tipsLabel)
    }
    private func makeConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.center.width.height.equalToSuperview()
        }
        tipsBackgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.centerX.equalToSuperview()
        }
        tipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.right.equalTo(-8)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
        }
    }
    private func addPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handGesture(recognizer:)))
        panGestureRecognizer.delegate = self
        imageView.addGestureRecognizer(panGestureRecognizer)
    }
}
extension CLChatPhotoAlbumCell: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    if (gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) ) {
           return true
       }
       return false
    }
}
extension CLChatPhotoAlbumCell {
    @objc func handGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: contentView)
        if recognizer.state == .began {
            direction = .none
        } else if recognizer.state == .changed && direction == .none {
            direction = determinePictureDirectionIfNeeded(translation)
        }
        if (direction == .up || direction == .down) && recognizer.state == .changed {
            verticalAction(with: recognizer)
            lockScollViewCallBack?(!isOnWindow)
        }
        if recognizer.state == .ended || recognizer.state == .cancelled {
            if direction == .up || direction == .down {
                if canSend && isOnWindow {
                    sendImageRecognizer(recognizer)
                } else {
                    backImageRecognizer(recognizer)
                }
            }
            isOnWindow = false
            lockScollViewCallBack?(!isOnWindow)
        }
    }
}
extension CLChatPhotoAlbumCell {
    func determinePictureDirectionIfNeeded(_ translation: CGPoint) -> CLChatPhotoMoveDirection {
        let absX = CGFloat(abs(Float(translation.x)))
        let absY = CGFloat(abs(Float(translation.y)))
        if max(absX, absY) < gestureMinimumTranslation {
            return .none
        }
        if absX > absY {
            if translation.x < 0 {
                return.left
            } else {
                return.right
            }
        } else if absY > absX {
            if translation.y < 0 {
                return .up
            } else {
                return.down
            }
        }
        return .none
    }
    func verticalAction(with recognizer: UIPanGestureRecognizer) {
        guard let keyWindow = UIApplication.shared.keyWindow, let view = recognizer.view, let superview = view.superview else {
            return
        }
        let translation = recognizer.translation(in: keyWindow)
        let centerInKeyWindow = superview.convert(view.center, to: keyWindow)
        if !isOnWindow {
            keyWindow.addSubview(view)
        }
        endPoint = contentView.convert(centerInKeyWindow, from: keyWindow)
        if canSend && isOnWindow {
            tipsBackgroundView.isHidden = false
        } else {
            tipsBackgroundView.isHidden = true
        }
        let toCenter = CGPoint(x: centerInKeyWindow.x, y: (translation.y) + (centerInKeyWindow.y))
        view.snp.remakeConstraints { (make) in
            make.width.height.equalTo(bounds.size)
            make.center.equalTo(toCenter)
        }
        keyWindow.setNeedsLayout()
        keyWindow.layoutIfNeeded()
        isOnWindow = true
        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: keyWindow)
    }
    func sendImageRecognizer(_ recognizer: UIPanGestureRecognizer) {
        guard let view = recognizer.view else {
            return
        }
        tipsBackgroundView.isHidden = true
        contentView.addSubview(view)
        view.snp.remakeConstraints { (make) in
            make.width.height.equalTo(0)
            make.center.equalToSuperview()
        }
        setNeedsLayout()
        layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            view.snp.remakeConstraints { (make) in
                make.width.height.equalToSuperview()
                make.center.equalToSuperview()
            }
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    func backImageRecognizer(_ recognizer: UIPanGestureRecognizer) {
        guard let view = recognizer.view else {
            return
        }
        let orginalCenter = contentView.convert(contentView.center, to: view.superview)
        tipsBackgroundView.isHidden = true
        UIView.animate(withDuration: 0.25, animations: {
            view.snp.remakeConstraints { (make) in
                make.width.height.equalTo(self.bounds.size)
                make.center.equalTo(orginalCenter)
            }
            view.superview?.setNeedsLayout()
            view.superview?.layoutIfNeeded()
        }) { _ in
            self.contentView.addSubview(view)
            view.snp.remakeConstraints { (make) in
                make.width.height.equalToSuperview()
                make.center.equalToSuperview()
            }
        }
    }
}
