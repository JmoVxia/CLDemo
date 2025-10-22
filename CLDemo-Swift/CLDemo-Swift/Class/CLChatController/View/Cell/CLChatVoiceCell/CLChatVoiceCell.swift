//
//  CLChatVoiceCell.swift
//  Potato
//
//  Created by AUG on 2019/10/14.
//

import Lottie
import UIKit

class CLChatVoiceCell: CLChatCell {
    /// 背景气泡
    var bubbleImageView = UIImageView()
    /// 时间
    private lazy var durationLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        view.textColor = .white
        return view
    }()

    /// 左侧播放动画
    private lazy var leftPlayAnimation: LottieAnimationView = {
        let view = LottieAnimationView(animation: LottieAnimation.named("data-left"))
        view.loopMode = .loop
        view.backgroundBehavior = .pauseAndRestore
        return view
    }()

    /// 左侧播放动画
    private lazy var rightPlayAnimation: LottieAnimationView = {
        let view = LottieAnimationView(animation: LottieAnimation.named("data-right"))
        view.loopMode = .loop
        view.backgroundBehavior = .pauseAndRestore
        return view
    }()

    /// 左侧气泡
    private lazy var leftBubbleImage: UIImage = {
        var image = UIImage(named: "leftBg")!
        image = image.resizableImage(withCapInsets: UIEdgeInsets(top: image.size.height * 0.5, left: image.size.width * 0.5, bottom: image.size.height * 0.5, right: image.size.width * 0.5))
        return image
    }()

    /// 右侧气泡
    private lazy var rightBubbleImage: UIImage = {
        var image = UIImage(named: "rightBg")!
        image = image.resizableImage(withCapInsets: UIEdgeInsets(top: image.size.height * 0.5, left: image.size.width * 0.5, bottom: image.size.height * 0.5, right: image.size.width * 0.5))
        return image
    }()
}

extension CLChatVoiceCell {
    override func initUI() {
        super.initUI()
        contentView.addSubview(bubbleImageView)
        contentView.addSubview(leftPlayAnimation)
        contentView.addSubview(rightPlayAnimation)
        contentView.addSubview(durationLabel)
    }

    override func makeConstraints() {
        super.makeConstraints()
        leftPlayAnimation.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
            make.left.equalTo(bubbleImageView.snp.left).offset(10)
        }
        rightPlayAnimation.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
            make.right.equalTo(bubbleImageView.snp.right).offset(-10)
        }
    }
}

extension CLChatVoiceCell {
    private func remakeConstraints(isFromMyself: Bool) {
        bubbleImageView.snp.remakeConstraints { make in
            if isFromMyself {
                make.right.equalTo(contentView.snp.right).offset(-10)
            } else {
                make.left.equalTo(contentView.snp.left).offset(10)
            }
            make.height.equalTo(40)
            make.width.equalTo(0)
            make.centerY.equalToSuperview()
        }
        durationLabel.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            if isFromMyself {
                make.right.equalTo(contentView.snp.right).offset(-50)
            } else {
                make.left.equalTo(contentView.snp.left).offset(50)
            }
        }
        bottomContentView.snp.remakeConstraints { make in
            make.edges.equalTo(bubbleImageView)
        }
    }
}

extension CLChatVoiceCell: CLRowCellProtocol {
    func setItem(_ item: CLChatVoiceItem, indexPath: IndexPath) {
        leftPlayAnimation.isHidden = item.isFromMyself
        rightPlayAnimation.isHidden = !item.isFromMyself
        bubbleImageView.image = item.isFromMyself ? rightBubbleImage : leftBubbleImage
        remakeConstraints(isFromMyself: item.isFromMyself)
        let duration = CGFloat(floor(Double(item.duration)))
        durationLabel.text = "\(Int(duration))"
        durationLabel.textColor = item.isFromMyself ? .white : .black
        var width: CGFloat = 5
        width = duration * width + 65
        width = max(min(width, screenWidth * 0.45), 70)
        bubbleImageView.snp.updateConstraints { make in
            make.width.equalTo(width)
        }
    }
}
