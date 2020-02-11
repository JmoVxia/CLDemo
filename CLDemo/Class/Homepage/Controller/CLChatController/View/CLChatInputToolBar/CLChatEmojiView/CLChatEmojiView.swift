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
    var itemSize: CGSize = CGSize(width: 40, height: 40)
    ///行间隙
    var rowMargin: CGFloat = 15
    ///列间隙
    var columnMargin: CGFloat = 15
    ///顶部间距
    var topInset: CGFloat = 15
    ///底部间距
    var bottomInset: CGFloat = 15
    ///多少行
    var rowNumber: Int = 4
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
        "👢","👞","👟","🎩","🎩","👒","🎓","⛑","👑","👝","👛","👜","💼","🎒","👓","🕶","🌂"
    ]
    ///点击emoji回掉
    var didSelectEmojiCallBack: ((String) -> ())?
    ///删除回掉
    var didSelectDeleteCallBack: (() -> ())?

    ///控件高度
    var height: CGFloat {
        get {
            return CGFloat(rowNumber) * itemSize.height + CGFloat(rowNumber - 1) * rowMargin + topInset + bottomInset + 15 + cl_safeAreaInsets().bottom
        }
    }
    ///控件宽度
    private var emojiViewWidth: CGFloat {
        get {
            return cl_screenWidth()
        }
    }
    ///collectionView宽度
    private var collectionViewWidth: CGFloat {
        get {
            return (emojiViewWidth - cl_safeAreaInsets().left - cl_safeAreaInsets().right)
        }
    }
    ///多少列
    private var columnNumber: Int {
        get {
            return Int(collectionViewWidth / (itemSize.width + columnMargin))
        }
    }
    ///两边间隙
    private var sideMargin: CGFloat {
        get {
            return (collectionViewWidth - CGFloat(columnNumber) * itemSize.width - columnMargin * CGFloat(columnNumber - 1)) * 0.5
        }
    }
    ///数据
    private var emojiDataSource = [[CLChatEmojiItemProtocol]]()
    ///layout
    private lazy var layout: CLChatEmojiFlowLayout = {
        let layout = CLChatEmojiFlowLayout()
        layout.minimumLineSpacing = rowMargin
        layout.minimumInteritemSpacing = columnMargin
        layout.scrollDirection = .horizontal
        layout.itemCountPerRow = {[weak self] in
            guard let strongSelf = self else {
                return 0
            }
            return strongSelf.columnNumber
        }
        layout.rowCount = {[weak self] in
            guard let strongSelf = self else {
                return 0
            }
            return strongSelf.rowNumber
        }
        return layout
    }()
    ///collectionView
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(CLChatEmojiTextCell.classForCoder(), forCellWithReuseIdentifier: CLChatEmojiTextCell.cellReuseIdentifier())
        collectionView.register(CLChatEmojiDelegateCell.classForCoder(), forCellWithReuseIdentifier: CLChatEmojiDelegateCell.cellReuseIdentifier())
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        let longPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(handleLongPress(gesture:)))
        collectionView.addGestureRecognizer(longPressGestureRecognizer)
        return collectionView
    }()
    ///page
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = emojiDataSource.count
        pageControl.currentPage = 0;
        return pageControl
    }()
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
    ///控制器将要旋转
    func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.contentOffset = CGPoint.zero
        collectionView.alpha = 0.0
        coordinator.animate(alongsideTransition: nil) { (_) in
            self.collectionView.alpha = 1.0
            self.layout.invalidateLayout()
            self.initData()
            self.pageControl.numberOfPages = self.emojiDataSource.count
            self.collectionView.reloadData()
        }
    }
}
extension CLChatEmojiView {
    private func initUI() {
        addSubview(collectionView)
        addSubview(pageControl)
    }
    private func makeConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(self.snp.bottom).offset(-15 - cl_safeAreaInsets().bottom)
        }
        pageControl.snp.makeConstraints { (make) in
            make.left.right.equalTo(collectionView)
            make.top.equalTo(collectionView.snp.bottom)
            make.height.equalTo(15);
        }
    }
    private func initData() {
        emojiDataSource = splitArray(array: emojiArray, withSubSize: (rowNumber * columnNumber - 1))
    }
    private func splitArray( array: [String], withSubSize subSize: Int) -> [[CLChatEmojiItemProtocol]] {
        let itemArray = array.map { (emojiString) -> CLChatEmojTextItem in
            let item = CLChatEmojTextItem()
            item.emoji = emojiString
            return item
        }
        let count = array.count  % subSize == 0 ? (array.count  / subSize) : (array.count  / subSize + 1)
        var arr: [[CLChatEmojiItemProtocol]] = []
        for i in 0..<count {
            let index: Int = i * subSize
            var arr1: [CLChatEmojiItemProtocol] = []
            arr1.removeAll()
            var j: Int = index
            while j < subSize * (i + 1) && j < array.count  {
                arr1.append(itemArray[j])
                j += 1
            }
            arr.append(arr1)
        }
        if var last = arr.last {
            if last.count < subSize {
                for _ in 0 ..< subSize - last.count {
                    let item = CLChatEmojTextItem()
                    last.append(item)
                }
                arr[arr.count - 1] = last
            }
        }
        var dataSourceArray = [[CLChatEmojiItemProtocol]]()
        for var item in arr {
            item.append(CLChatEmojiDeleteItem())
            dataSourceArray.append(item)
        }
        return dataSourceArray
    }
    
    @objc private func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed {
            timer?.cancel()
        }else if (gesture.state == .began) {
            let point = gesture.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: point) {
                let array = emojiDataSource[indexPath.section]
                let item = array[indexPath.row]
                if let _ = item as? CLChatEmojiDeleteItem {
                    timer = CLGCDTimer.init(interval: 0.1, action: {[weak self] (_) in
                        DispatchQueue.main.async {
                            self?.didSelectDeleteCallBack?()
                        }
                    })
                    timer?.start()
                }
            }
        }
    }
}
extension CLChatEmojiView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let array = emojiDataSource[indexPath.section]
        let item = array[indexPath.row]
        if let emojiItem = item as? CLChatEmojTextItem {
            guard let emoji = emojiItem.emoji else {
                return
            }
            didSelectEmojiCallBack?(emoji)
        }else if let _ = item as? CLChatEmojiDeleteItem {
            didSelectDeleteCallBack?()
        }
    }
}
extension CLChatEmojiView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rowNumber * columnNumber
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emojiDataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let array = emojiDataSource[indexPath.section]
        let item = array[indexPath.row]
        return item.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
    }
}
extension CLChatEmojiView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: topInset, left: sideMargin + cl_safeAreaInsets().left, bottom: bottomInset, right: sideMargin + cl_safeAreaInsets().right)
    }

}
extension CLChatEmojiView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = floor((scrollView.contentOffset.x - scrollView.frame.width / 2) / scrollView.frame.width) + 1;
        pageControl.currentPage = Int(page);
    }
}
