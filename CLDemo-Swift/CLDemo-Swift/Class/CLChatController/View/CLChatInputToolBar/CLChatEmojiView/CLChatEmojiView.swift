//
//  CLChatEmojiView.swift
//  Potato
//
//  Created by AUG on 2019/10/25.
//

import UIKit
import SnapKit

class CLChatEmojiView: UIView {
    ///item大小
    var itemSize: CGSize = CGSize(width: 45, height: 45)
    ///emoji数组
    var emojiArray: [String] = [
        "😀","😃","😄","😁","😆","😅","😂","🤣","☺️","😊","😇","🙂","🙃","😉","😌","😍","😘","😗","😙","😚","😋",
        "😛","😝","😜","🤓","😎","😏","😒","😞","😔","😟","😕","🙁","☹️","😣","😖","😫","😩","😢","😭","😤","😠",
        "😡","😳","😱","😨","😰","😥","😓","🤗","🤔","🤥","😶","😐","😑","😬","🙄","😯","😦","😧","😮","😲","😴",
        "🤤","😪","😵","🤐","🤢","🤧","😷","🤒","🤕","🤑","🤠","😈","👿","👹","👺","🤡","💩","👻","💀","☠️","👽",
        "👾","🤖","🎃","😺","😸","😹","😻","😼","😽","🙀","😿","😾","👐","🙌","👏","🤝","👍","👎","👊","✊️","🤛",
        "🤜","🤞","✌️","🤘","👌","👈","👉","👆","👇","☝️","✋️","🤚","🖐","🖖","👋","🤙","💪","🖕","✍️","🙏","💍",
        "💄","💋","👄","👅","👂","👃","👣","👁","👀","🗣","👤","👥","👶","👧","👦","👩","👨","👱‍♀️","👱‍♂","👵","👴",
        "👲","👳‍♀️","👳‍♂","👮‍♀️","👮‍♂","👷‍♀️","👷‍♂","💂‍♀️","💂‍♂","🕵️‍♀️","👩‍⚕️","👨‍⚕️","👩‍🌾","👨‍🌾","👩‍🍳","👨‍🍳","👩‍🎓","👨‍🎓","👩‍🎤","👨‍🎤","👩‍🏫",
        "👨‍🏫","👩‍🏭","👨‍🏭","👩‍💻","👨‍💻","👩‍💼","👨‍💼","👩‍🔧","👨‍🔧","👩‍🔬","👨‍🔬","👩‍🎨","👨‍🎨","👩‍🚒","👨‍🚒","👩‍✈️","👨‍✈️","👩‍🚀","👨‍🚀","👩‍⚖️","👨‍⚖️",
        "👰","🤵","👸","🤴","🤶","🎅","👼","🤰","🙇‍♀️","🙇‍♂","💁‍♀","💁‍♂️","🙅‍♀","🙅‍♂️","🙆‍♀","🙆‍♂️","🙋‍♀","🙋‍♂️","🤦‍♀️","🤦‍♂️","🤷‍♀️",
        "🤷‍♂️","🙎‍♀","🙎‍♂️","🙍‍♀","🙍‍♂️","💇‍♀","💇‍♂️","💆‍♀","💆‍♂️","💅","🤳","💃","🕺","👯‍♀","👯‍♂️","🕴","🚶‍♀️","🚶‍♂","🏃‍♀️","🏃‍♂","👫",
        "👭","👬","💑","👩‍❤️‍👩","👨‍❤️‍👨","💏","👩‍❤️‍💋‍👩","👨‍❤️‍💋‍👨","👪","👨‍👩‍👧","👨‍👩‍👧‍👦","👨‍👩‍👦‍👦","👨‍👩‍👧‍👧","👩‍👩‍👦","👩‍👩‍👧","👩‍👩‍👧‍👦","👩‍👩‍👦‍👦","👩‍👩‍👧‍👧","👨‍👨‍👦","👨‍👨‍👧","👨‍👨‍👧‍👦",
        "👨‍👨‍👦‍👦","👨‍👨‍👧‍👧","👩‍👦","👩‍👧","👩‍👧‍👦","👩‍👦‍👦","👩‍👧‍👧","👨‍👦","👨‍👧","👨‍👧‍👦","👨‍👦‍👦","👨‍👧‍👧","👚","👕","👖","👔","👗","👙","👘","👠","👡",
        "👢","👞","👟","🎩","👒","🎓","⛑","👑","👝","👛","👜","💼","🎒","👓","🕶"
    ]
    ///点击emoji回掉
    var didSelectEmojiCallBack: ((String) -> ())?
    ///删除回掉
    var didSelectDeleteCallBack: (() -> ())?
    ///发送回掉
    var didSelectSendCallBack: (() -> ())?
    ///间隙
    var columnMargin: CGFloat {
        get {
            let column = Int(collectionViewWidth / itemSize.width)
            return collectionViewWidth.truncatingRemainder(dividingBy: itemSize.width) / CGFloat(column + 1)
        }
    }
    ///控件高度
    var height: CGFloat {
        get {
            return 6 * itemSize.height + columnMargin * 5 + safeAreaEdgeInsets.bottom
        }
    }
    ///控件宽度
    private var emojiViewWidth: CGFloat {
        get {
            return screenWidth
        }
    }
    ///collectionView宽度
    private var collectionViewWidth: CGFloat {
        get {
            return (emojiViewWidth - safeAreaEdgeInsets.left - safeAreaEdgeInsets.right)
        }
    }
    ///数据
    private var emojiDataSource = [CLChatEmojTextItem]()
    ///layout
    private lazy var emojiLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = columnMargin
        layout.minimumInteritemSpacing = columnMargin * 0.5
        layout.sectionInset = UIEdgeInsets(top: 0, left: columnMargin, bottom: 44, right: columnMargin)
        layout.scrollDirection = .vertical
        return layout
    }()
    ///collectionView
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: emojiLayout)
        view.register(CLChatEmojiTextCell.classForCoder(), forCellWithReuseIdentifier: CLChatEmojiTextCell.cellReuseIdentifier())
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    ///删除按钮
    private lazy var deleteButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        view.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        let longPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(handleLongPress(gesture:)))
        view.addGestureRecognizer(longPressGestureRecognizer)
        return view
    }()
    ///发送按钮
    private lazy var sendButton: UIButton = {
        let view = UIButton()
        view.setTitle("发送", for: .normal)
        view.setTitle("发送", for: .selected)
        view.setTitle("发送", for: .highlighted)
        view.titleLabel?.font = PingFangSCMedium(16)
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        view.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        return view
    }()
    ///背景
    private lazy var hiddenView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    ///底部安全区域
    private lazy var bottomSafeView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    ///是否可以删除
    var isCanDelete: Bool = true {
        didSet {
            if isCanDelete != oldValue {
                deleteButton.isUserInteractionEnabled = isCanDelete
                let image = isCanDelete ? UIImage(named: "deleteHIcon") : UIImage(named: "deleteIcon")
                deleteButton.setImage(image, for: .normal)
                deleteButton.setImage(image, for: .selected)
                deleteButton.setImage(image, for: .highlighted)
            }
        }
    }
    ///是否可以发送
    var isCanSend: Bool = true {
        didSet {
            if isCanSend != oldValue {
                let textColor: UIColor = isCanSend ? .white : .hex("#CCCCCC")
                let backgroundColor: UIColor = isCanSend ? .themeColor : .white
                sendButton.isUserInteractionEnabled = isCanSend
                sendButton.setTitleColor(textColor, for: .normal)
                sendButton.setTitleColor(textColor, for: .selected)
                sendButton.setTitleColor(textColor, for: .highlighted)
                sendButton.backgroundColor = backgroundColor
            }
        }
    }
    ///定时器
    private var timer: CLGCDTimer?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: emojiViewWidth, height: height)
        initData()
        initUI()
        makeConstraints()
        setNeedsLayout()
        layoutIfNeeded()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLChatEmojiView {
    private func initUI() {
        isCanDelete = false
        isCanSend = false
        addSubview(collectionView)
        addSubview(bottomSafeView)
        addSubview(hiddenView)
        addSubview(deleteButton)
        addSubview(sendButton)
    }
    private func makeConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(bottomSafeView.snp.top)
        }
        bottomSafeView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(safeAreaEdgeInsets.bottom)
        }
        deleteButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 55, height: 30))
            make.bottom.equalTo(collectionView.snp.bottom).offset(-7.5)
            make.right.equalTo(sendButton.snp.left).offset(-8)
        }
        sendButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 55, height: 30))
            make.bottom.equalTo(collectionView.snp.bottom).offset(-7.5)
            make.right.equalTo(-15)
        }
        hiddenView.snp.makeConstraints { (make) in
            make.top.left.equalTo(deleteButton)
            make.bottom.right.equalTo(sendButton)
        }
    }
    private func initData() {
        emojiDataSource.append(contentsOf: emojiArray.map({ (text) -> CLChatEmojTextItem in
            let item = CLChatEmojTextItem()
            item.emoji = text
            return item
        }))
    }
    
    @objc private func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed {
            timer?.cancel()
        }else if (gesture.state == .began) {
            timer = CLGCDTimer.init(interval: 0.1, action: {[weak self] (_) in
                DispatchQueue.main.async {
                    self?.didSelectDeleteCallBack?()
                }
            })
            timer?.start()
        }
    }
}
extension CLChatEmojiView {
    @objc private func deleteButtonAction() {
        didSelectDeleteCallBack?()
    }
    @objc private func sendButtonAction() {
        didSelectSendCallBack?()
    }
}
extension CLChatEmojiView {
    ///恢复初始状态
    func restoreInitialState() {
        collectionView.setContentOffset(.zero, animated: false)
    }
}
extension CLChatEmojiView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let emoji = emojiDataSource[indexPath.row].emoji, let cell = collectionView.cellForItem(at: indexPath), cell.alpha == 1.0 else {
            return
        }
        didSelectEmojiCallBack?(emoji)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cellRect = cell.convert(cell.bounds, to: self)
        let hiddenRect = hiddenView.convert(hiddenView.bounds, to: self)
        cell.alpha = hiddenRect.intersects(cellRect) ? max(0, 1.0 - (cellRect.maxY - hiddenRect.minY) / (45 * 0.45)) : 1.0
    }
}
extension CLChatEmojiView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiDataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return emojiDataSource[indexPath.row].dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
    }
}
extension CLChatEmojiView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
}
extension CLChatEmojiView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            let cellRect = cell.convert(cell.bounds, to: self)
            let hiddenRect = hiddenView.convert(hiddenView.bounds, to: self)
            cell.alpha = hiddenRect.intersects(cellRect) ? max(0, 1.0 - (cellRect.maxY - hiddenRect.minY) / (45 * 0.45)) : 1.0
        }
    }
}
