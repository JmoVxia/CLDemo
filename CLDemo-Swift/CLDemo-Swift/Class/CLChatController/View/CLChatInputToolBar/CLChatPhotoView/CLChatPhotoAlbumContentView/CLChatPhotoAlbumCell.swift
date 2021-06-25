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
    var sendImageCallBack: ((UIImage) -> ())?
    var seletedNumber: Int = 0 {
        didSet {
            let title = seletedNumber == 0 ? " " : "\(seletedNumber)"
            seletedNumberButton.setTitle(title, for: .normal)
            seletedNumberButton.setTitle(title, for: .selected)
            seletedNumberButton.setTitle(title, for: .highlighted)
            if seletedNumber > 0 {
                seletedNumberButton.isSelected = true
            }else {
                seletedNumberButton.isSelected = false
            }
        }
    }
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    private var endPoint: CGPoint = .zero {
        didSet {
            canSend = endPoint.y < 20
        }
    }
    private var canSend: Bool = false {
        didSet {
            
        }
    }
    private var direction: CLChatPhotoMoveDirection = .none
    private var isOnWindow: Bool = false {
        didSet {

        }
    }
    private var gestureMinimumTranslation: CGFloat = 10.0
    private lazy var tipsBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .hex("0x323232", alpha: 0.85)
        view.isHidden = true
        view.clipsToBounds = true
        return view
    }()
    private lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.backgroundColor = UIColor.clear
        view.textColor = UIColor.white
        view.font = PingFangSCMedium(15)
        view.text = "松手发送"
        return view
    }()
    private lazy var seletedNumberButton: UIButton = {
        let view = UIButton()
        view.isUserInteractionEnabled = false
        view.setBackgroundImage(UIImage(named: "advNsel"), for: .normal)
        view.setBackgroundImage(UIImage(named: "advSel"), for: .selected)
        view.setTitleColor(.white, for: .normal)
        view.setTitleColor(.white, for: .selected)
        view.setTitleColor(.white, for: .highlighted)
        view.titleLabel?.font = PingFangSCMedium(12)
        view.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom:5, right: 5)
        return view
    }()
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
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
        updateSeletedNumberOffset()
    }
}
extension CLChatPhotoAlbumCell {
    private func initUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(seletedNumberButton)
        imageView.addSubview(tipsBackgroundView)
        tipsBackgroundView.addSubview(tipsLabel)
    }
    private func makeConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.center.width.height.equalToSuperview()
        }
        seletedNumberButton.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(5)
            make.width.equalTo(seletedNumberButton.snp.height)
        }
        tipsBackgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.centerX.equalToSuperview()
        }
        tipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(8)
            make.bottom.equalTo(-8)
        }
    }
}
extension CLChatPhotoAlbumCell {
    func updateSeletedNumberOffset() {
        guard let supperView = superview else {
            return
        }
        var offset: CGFloat = 0
        let rect = supperView.convert(frame, to: supperView.superview)
        if rect.minX < 0 {
            offset = -rect.minX
        }else if rect.maxX > supperView.frame.width {
            offset = supperView.frame.width - rect.maxX
        }
        let left = max(5, min(bounds.width - seletedNumberButton.frame.width, bounds.width - seletedNumberButton.frame.width + offset) - 5);
        seletedNumberButton.snp.updateConstraints { (make) in
            make.left.equalTo(left)
        }
    }
}
extension CLChatPhotoAlbumCell {
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
    @objc private func handGesture(recognizer: UIPanGestureRecognizer) {
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
    private func determinePictureDirectionIfNeeded(_ translation: CGPoint) -> CLChatPhotoMoveDirection {
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
    private func verticalAction(with recognizer: UIPanGestureRecognizer) {
        guard let keyWindow = UIApplication.shared.keyWindow, let view = recognizer.view, let superview = view.superview else {
            return
        }
        let translation = recognizer.translation(in: keyWindow)
        let centerInKeyWindow = superview.convert(view.center, to: keyWindow)
        if !isOnWindow {
            seletedNumberButton.isHidden = true
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
    private func sendImageRecognizer(_ recognizer: UIPanGestureRecognizer) {
        guard let view = recognizer.view else {
            return
        }
        tipsBackgroundView.isHidden = true
        contentView.insertSubview(view, at: 0)
        view.snp.remakeConstraints { (make) in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (_) in
            self.seletedNumberButton.isHidden = false
        }
        guard let image = image else {
            return
        }
        sendImageCallBack?(image)
    }
    private func backImageRecognizer(_ recognizer: UIPanGestureRecognizer) {
        guard let view = recognizer.view else {
            return
        }
        let orginalCenter = contentView.convert(contentView.center, to: view.superview)
        tipsBackgroundView.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
            view.snp.remakeConstraints { (make) in
                make.width.height.equalTo(self.bounds.size)
                make.center.equalTo(orginalCenter)
            }
            view.superview?.setNeedsLayout()
            view.superview?.layoutIfNeeded()
        }) { _ in
            self.seletedNumberButton.isHidden = false
            self.contentView.insertSubview(view, at: 0)
            view.snp.remakeConstraints { (make) in
                make.width.height.equalToSuperview()
                make.center.equalToSuperview()
            }
        }
    }
}
