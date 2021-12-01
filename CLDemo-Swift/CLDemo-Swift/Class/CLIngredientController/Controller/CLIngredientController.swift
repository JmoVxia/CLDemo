//
//  CLLinkageController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/12/1.
//

import SwiftyJSON
import UIKit
import SnapKit

// MARK: - JmoVxia---类-属性

class CLIngredientController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {}
    
    private lazy var leftTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.scrollsToTop = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = .white
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.estimatedRowHeight = .zero
        view.estimatedSectionFooterHeight = .zero
        view.estimatedSectionHeaderHeight = .zero
        view.sectionFooterHeight = .leastNormalMagnitude
        view.register(CLIngredientLeftTitleHead.classForCoder(), forHeaderFooterViewReuseIdentifier: "CLIngredientLeftTitleHead")
        view.register(CLIngredientLeftTitleCell.classForCoder(), forCellReuseIdentifier: "CLIngredientLeftTitleCell")
        view.keyboardDismissMode = .onDrag
        if #available(iOS 13.0, *) {
            view.automaticallyAdjustsScrollIndicatorInsets = false
        }
        if #available(iOS 15.0, *) {
            view.sectionHeaderTopPadding = 0
        }
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()

    private lazy var rightTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.scrollsToTop = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.estimatedSectionFooterHeight = .zero
        view.estimatedSectionHeaderHeight = .zero
        view.sectionFooterHeight = .leastNormalMagnitude
        view.register(CLIngredientRightTitleHead.classForCoder(), forHeaderFooterViewReuseIdentifier: "CLIngredientRightTitleHead")
        view.register(CLIngredientRightTitleCell.classForCoder(), forCellReuseIdentifier: "CLIngredientRightTitleCell")
        view.keyboardDismissMode = .onDrag
        if #available(iOS 13.0, *) {
            view.automaticallyAdjustsScrollIndicatorInsets = false
        }
        if #available(iOS 15.0, *) {
            view.sectionHeaderTopPadding = 0
        }
        return view
    }()

    private lazy var searchTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.scrollsToTop = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.estimatedRowHeight = 50
        view.estimatedSectionFooterHeight = .zero
        view.estimatedSectionHeaderHeight = .zero
        view.sectionHeaderHeight = .leastNormalMagnitude
        view.sectionFooterHeight = .leastNormalMagnitude
        view.register(CLIngredientSearchCell.classForCoder(), forCellReuseIdentifier: "CLIngredientSearchCell")
        view.keyboardDismissMode = .onDrag
        if #available(iOS 13.0, *) {
            view.automaticallyAdjustsScrollIndicatorInsets = false
        }
        if #available(iOS 15.0, *) {
            view.sectionHeaderTopPadding = 0
        }
        return view
    }()

    private lazy var searchView: CLIngredientSearchView = {
        let view = CLIngredientSearchView()
        view.textChangeCallback = { [weak self] value in
            guard let self = self else { return }
            self.search(text: value)
        }
        return view
    }()

    private var dataSource = [CLIngredients]()

    private var leftDataSource = [[[CLIngredients]]]()

    private var rightDataSource = [[CLIngredients]]()

    private var searchDataSource = [CLIngredients]()

    private var seletedIndexPath: IndexPath = .init(row: 0, section: 0)

    private var rightIndexPath: IndexPath = .init(row: 0, section: 0) {
        didSet {
            guard rightIndexPath.section != oldValue.section else { return }
            guard let item = rightDataSource[safe: rightIndexPath.section]?[safe: rightIndexPath.row] else { return }
            var leftIndexPath = IndexPath(row: 0, section: 0)
            for (section, array) in leftDataSource.enumerated() {
                if let row = array.firstIndex(where: { $0.contains(where: { $0.sortedSecondary == item.sortedSecondary }) }) {
                    leftIndexPath = .init(row: row, section: section)
                    break
                }
            }
            guard seletedIndexPath != leftIndexPath else { return }
            seletedIndexPath = leftIndexPath
            UIView.transition(with: leftTableView, duration: 0.25, options: .transitionCrossDissolve) {
                self.leftTableView.reloadData()
            } completion: { _ in
                self.leftTableView.scrollToRow(at: self.seletedIndexPath, at: .none, animated: false)
            }
        }
    }

    private var leftIndexPath: IndexPath = .init(row: 0, section: 0) {
        didSet {
            guard leftIndexPath != oldValue else { return }
            seletedIndexPath = leftIndexPath
            UIView.transition(with: leftTableView, duration: 0.25, options: .transitionCrossDissolve) {
                self.leftTableView.reloadData()
            }
            guard let item = leftDataSource[safe: leftIndexPath.section]?[safe: leftIndexPath.row]?.first else { return }
            guard let section = rightDataSource.firstIndex(where: { $0.contains(where: { $0.sortedSecondary == item.sortedSecondary }) }) else { return }
            rightTableView.scrollToRow(at: .init(row: 0, section: section), at: .top, animated: true)
        }
    }

    private var isShowSearch: Bool = false {
        didSet {
            guard isShowSearch != oldValue else { return }
            isShowSearch ? showSearchAnimation() : hiddenSearchAnimation()
            leftTableView.reloadData()
        }
    }

    private var searchResultAttributedString = NSMutableAttributedString()

    var clickCallback: ((_ id: String, _ name: String) -> Void)?
}

// MARK: - JmoVxia---生命周期

extension CLIngredientController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        initData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - JmoVxia---布局

private extension CLIngredientController {
    func initUI() {
        updateTitleLabel { $0.text = "选择食材" }
        view.addSubview(searchView)
        view.addSubview(leftTableView)
        view.addSubview(rightTableView)
        view.addSubview(searchTableView)
    }

    func makeConstraints() {
        searchView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom).offset(10)
            }
        }
        leftTableView.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom).offset(10)
            make.width.equalTo(140)
        }
        rightTableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(10)
            make.left.equalTo(leftTableView.snp.right)
            make.right.bottom.equalToSuperview()
        }
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(10)
            make.width.equalTo(rightTableView)
            make.bottom.equalToSuperview()
            make.left.equalTo(screenWidth)
        }
    }
}

// MARK: - JmoVxia---数据

private extension CLIngredientController {
    func initData() {
        showProgress()
        DispatchQueue.global().async {
            guard let path = Bundle.main.path(forResource: "CLIngredients", ofType: "json"),
                  let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
                  let json = try? JSON(data: data)
            else {
                return
            }
            self.dataSource = json.arrayValue.map({.init(json: $0)})
            self.leftDataSource = Dictionary(grouping: self.dataSource, by: { $0.sortedPrimary }).sorted(by: { NSDecimalNumber(string: $0.key).lessThan(NSDecimalNumber(string: $1.key)) }).map { Dictionary(grouping: $0.value, by: { $0.sortedSecondary }).sorted(by: { NSDecimalNumber(string: $0.key).lessThan(NSDecimalNumber(string: $1.key)) }).map { $0.value } }
            self.rightDataSource = Dictionary(grouping: self.dataSource, by: { $0.sortedSecondary }).sorted(by: { NSDecimalNumber(string: $0.key).lessThan(NSDecimalNumber(string: $1.key)) }).map { $0.value }
            DispatchQueue.main.async {
                self.leftTableView.reloadData()
                self.rightTableView.reloadData()
                self.hiddenProgress()
            }
        }
    }
}

// MARK: - JmoVxia---override

extension CLIngredientController {}

// MARK: - JmoVxia---objc

@objc private extension CLIngredientController {}

// MARK: - JmoVxia---私有方法

private extension CLIngredientController {
    func search(text: String?) {
        func search(needle: String, haystack: String) -> (Bool, Int) {
            let words = haystack.components(separatedBy: "+")
            for word in words {
                let item = word.fuzzySearch(needle: needle)
                if item.0 {
                    return item
                }
            }
            return (false, -1)
        }

        isShowSearch = !(text?.isEmpty ?? true)
        guard let text = text else { return }
        let start = milliStamp

        let searchResult: [(item: CLIngredients, similarity: Int)] = dataSource.compactMap { item in
            let result = search(needle: text, haystack: item.searchName)
            guard result.0 else { return nil }
            return (item, result.1)
        }
        searchDataSource = searchResult.sorted(by: { $0.similarity > $1.similarity }).map { $0.0 }
        let end = milliStamp
        CLLog("耗时：\(CGFloat(end - start) / 1000)，数组个数：\(dataSource.count)，筛选后个数：\(searchDataSource.count)")

        let fail = NSMutableAttributedString("未找到关于“\(text)”相关信息", attributes: { $0
                .font(PingFangSCBold(16))
                .alignment(.left)
                .foregroundColor(.red)
                .lineSpacing(8)
        })

        let success = NSMutableAttributedString("与", attributes: { $0
                .font(PingFangSCBold(16))
                .alignment(.left)
                .foregroundColor(.hex("#333333"))
                .lineSpacing(8)
        }).addText("“\(text)”", attributes: { $0
                .font(PingFangSCBold(16))
                .alignment(.left)
                .foregroundColor(.hex("#24C065"))
                .lineSpacing(8)
        }).addText("相关", attributes: { $0
                .font(PingFangSCBold(16))
                .alignment(.left)
                .foregroundColor(.hex("#333333"))
                .lineSpacing(8)
        })
        searchResultAttributedString = searchDataSource.isEmpty ? fail : success
        searchTableView.reloadData()
    }

    func showSearchAnimation() {
        searchTableView.snp.updateConstraints { make in
            make.left.equalTo(140)
        }
        UIView.animate(withDuration: 0.25) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }

    func hiddenSearchAnimation() {
        searchTableView.snp.updateConstraints { make in
            make.left.equalTo(screenWidth)
        }
        UIView.animate(withDuration: 0.25) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - JmoVxia---公共方法

extension CLIngredientController {}

extension CLIngredientController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == leftTableView {
            return (section == seletedIndexPath.section && !isShowSearch) ? 54 : 50
        } else if tableView == rightTableView {
            return 50
        } else {
            return .leastNormalMagnitude
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == leftTableView {
            return (indexPath.section == seletedIndexPath.section && !isShowSearch) ? (indexPath.row == leftDataSource[indexPath.section].count - 1 ? 44 : 40) : 0
        } else if tableView == rightTableView {
            return UITableView.automaticDimension
        } else {
            return UITableView.automaticDimension
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == leftTableView {
            return leftDataSource.count
        } else if tableView == rightTableView {
            return rightDataSource.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTableView {
            return leftDataSource[section].count
        } else if tableView == rightTableView {
            return rightDataSource[section].count
        } else {
            return searchDataSource.count + 1
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == leftTableView {
            let headView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CLIngredientLeftTitleHead") as? CLIngredientLeftTitleHead
            headView?.clickCallback = { [weak self] in
                self?.leftIndexPath = .init(row: 0, section: section)
                self?.isShowSearch = false
                self?.searchView.cancel()
            }
            headView?.isTop = (section == 0 && !isShowSearch)
            headView?.isOpen = (section == seletedIndexPath.section && !isShowSearch)
            headView?.titleLabel.text = leftDataSource[section].first?.first?.primaryName
            return headView
        } else if tableView == rightTableView {
            let headView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CLIngredientRightTitleHead") as? CLIngredientRightTitleHead
            headView?.titleLabel.text = rightDataSource[section].first?.secondaryName
            return headView
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leftTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CLIngredientLeftTitleCell", for: indexPath)
            guard let cell = cell as? CLIngredientLeftTitleCell else { return cell }
            cell.isSelected = indexPath == seletedIndexPath
            cell.isBottom = indexPath.row == leftDataSource[indexPath.section].count - 1
            cell.titleLabel.text = leftDataSource[indexPath.section][indexPath.row].first?.secondaryName
            cell.isHidden = (indexPath.section != seletedIndexPath.section || isShowSearch)
            return cell
        } else if tableView == rightTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CLIngredientRightTitleCell", for: indexPath)
            guard let cell = cell as? CLIngredientRightTitleCell else { return cell }
            cell.titleLabel.attributedText = NSMutableAttributedString(rightDataSource[indexPath.section][indexPath.row].tertiaryName, attributes: { $0
                    .font(PingFangSCMedium(14))
                    .alignment(.left)
                    .foregroundColor(.hex("#666666"))
                    .lineSpacing(8)
            })
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CLIngredientSearchCell", for: indexPath)
            guard let cell = cell as? CLIngredientSearchCell else { return cell }
            cell.titleLabel.attributedText = indexPath.row == 0 ? searchResultAttributedString : NSMutableAttributedString(searchDataSource[indexPath.row - 1].tertiaryName, attributes: { $0
                    .font(PingFangSCMedium(14))
                    .alignment(.left)
                    .foregroundColor(.hex("#666666"))
                    .lineSpacing(8)
            })
            cell.lineView.isHidden = indexPath.row != 0
            return cell
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isTracking || scrollView.isDecelerating else { return }
        guard scrollView == rightTableView else { return }
        guard let indexPath = rightTableView.indexPathsForVisibleRows?.first else { return }
        rightIndexPath = indexPath
    }
}

extension CLIngredientController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isShowSearch = false
        searchView.cancel()
        if tableView == leftTableView {
            leftIndexPath = indexPath
        } else if tableView == rightTableView {
            let data = rightDataSource[indexPath.section][indexPath.row]
            clickCallback?("\(data.tertiaryId)", data.tertiaryName)
            back()
        } else {
            let data = searchDataSource[indexPath.row - 1]
            clickCallback?("\(data.tertiaryId)", data.tertiaryName)
            back()
        }
    }
}
