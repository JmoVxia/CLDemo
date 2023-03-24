//
//  CLMultiController.swift
//  CLDemo-Swift
//
//  Created by JmoVxia on 2023/3/24.
//

import UIKit

class CLMultiController: CLController {
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var mainStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.insetsLayoutMarginsFromSafeArea = true
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .zero
        view.spacing = 0
        return view
    }()
    
    private lazy var topToolBar: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleScrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private lazy var titleStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.insetsLayoutMarginsFromSafeArea = false
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .zero
        view.spacing = menuItemSpaceX
        return view
    }()
    
    private lazy var tableViewScrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private lazy var tableViewStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.insetsLayoutMarginsFromSafeArea = false
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .zero
        view.spacing = 0
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "请选择所在地区"
        view.textColor = .black
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let view = UIButton()
        view.setTitle("取消", for: .normal)
        view.setTitleColor(.lightGray, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 16)
        view.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return view
    }()
    
    var topToolBarHeight = 50.0
    
    var titleViewHeight = 50.0
    
    var menuItemSpaceX = 20.0
    
    var viewHeight = screenHeight * 0.5
    
    weak var dataSource: CLMultiDataSource?
    
    private(set) var selectedIndexPath = [CLMultiIndexPath]()
    
    private var lastSelectedButton: UIButton?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLMultiController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        addPage()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { [weak self] _ in
            guard let self = self else { return }
            self.resetOffset()
        })
    }
}
extension CLMultiController {
    func initUI() {
        view.addSubview(contentView)
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(topToolBar)
        mainStackView.addArrangedSubview(titleScrollView)
        mainStackView.addArrangedSubview(tableViewScrollView)

        topToolBar.addSubview(titleLabel)
        topToolBar.addSubview(cancelButton)
        
        titleScrollView.addSubview(titleStackView)
        tableViewScrollView.addSubview(tableViewStackView)
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelAction))
//        view.addGestureRecognizer(tap)
    }
    func makeConstraints() {
        contentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(viewHeight)
            make.top.equalTo(view.snp.bottom).offset(0)
        }
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        topToolBar.snp.makeConstraints { make in
            make.height.equalTo(topToolBarHeight)
        }
        titleScrollView.snp.makeConstraints { make in
            make.height.equalTo(titleViewHeight)
        }
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
        }
        titleStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        tableViewStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    func showAnimation() {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        contentView.snp.updateConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(-viewHeight)
        }
        UIView.animate(withDuration: 0.35, delay: .zero, options: .curveEaseIn) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
}
private extension CLMultiController {
    func addPage() {
        let column = titleStackView.arrangedSubviews.count
        let titleButton = UIButton()
        titleButton.addTarget(self, action: #selector(clickTitleButton(_:)), for: .touchUpInside)
        titleButton.setTitle("请选择", for: .normal)
        titleButton.setTitleColor(.black, for: .normal)
        titleButton.setTitleColor(.red, for: .selected)
        titleButton.sizeToFit()
        titleStackView.addArrangedSubview(titleButton)
        titleButton.tag = column

        let tableView = UITableView()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .random
        tableViewStackView.addArrangedSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.width.equalTo(view)
        }
        clickTitleButton(titleButton)
    }
    func deletePageFromColumn(_ column: Int) {
        guard column < tableViewStackView.arrangedSubviews.count else { return }
        for (index, view) in tableViewStackView.arrangedSubviews.enumerated() where index >= column {
            let titleButton = titleStackView.arrangedSubviews[column]
            tableViewStackView.removeArrangedSubview(view)
            titleStackView.removeArrangedSubview(titleButton)
            view.removeFromSuperview()
            titleButton.removeFromSuperview()
        }
        column == 1 ? selectedIndexPath.removeAll() : selectedIndexPath.removeAll(where: { $0.column < column })
    }
    func resetOffset() {
        guard let button = lastSelectedButton else { return }
        titleScrollView.setNeedsLayout()
        titleScrollView.layoutIfNeeded()
        let visibleRect = CGRect(origin: .init(x: button.frame.minX, y: 0), size: titleScrollView.bounds.size)
        titleScrollView.scrollRectToVisible(visibleRect, animated: false)
        
        let index = CGFloat(button.tag)
        tableViewScrollView.setContentOffset(.init(x: view.bounds.width * index, y: .zero), animated: false)
        lastSelectedButton?.isSelected = false
        lastSelectedButton = button
        button.isSelected = true
    }
}
@objc extension CLMultiController {
     func cancelAction() {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        contentView.snp.updateConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(0)
        }
        UIView.animate(withDuration: 0.35, delay: .zero, options: .curveEaseOut) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false)
        }

    }
    func clickTitleButton(_ button: UIButton) {
        guard button != lastSelectedButton else { return }
        
        titleScrollView.setNeedsLayout()
        titleScrollView.layoutIfNeeded()
        let visibleRect = CGRect(origin: .init(x: button.frame.minX, y: 0), size: titleScrollView.bounds.size)
        titleScrollView.scrollRectToVisible(visibleRect, animated: true)
        
        let index = CGFloat(button.tag)
        tableViewScrollView.setContentOffset(.init(x: view.bounds.width * index, y: .zero), animated: true)
        lastSelectedButton?.isSelected = false
        lastSelectedButton = button
        button.isSelected = true
    }
}
extension CLMultiController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let index = tableViewStackView.arrangedSubviews.firstIndex(of: tableView) else { return .zero }
        return dataSource?.multiController(self, numberOfItemsInColumn: index) ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataSource = dataSource, let column = tableViewStackView.arrangedSubviews.firstIndex(of: tableView) else { return UITableViewCell() }
        let currentIndexPath = CLMultiIndexPath(indexPath: indexPath, column: column)
        return dataSource.multiController(self, tableView: tableView, cellForRowAt: currentIndexPath)
    }
}
extension CLMultiController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = dataSource, let column = tableViewStackView.arrangedSubviews.firstIndex(of: tableView) else { return }
        
        let currentIndexPath = CLMultiIndexPath(indexPath: indexPath, column: column)
            
        guard dataSource.multiController(self, isCompletedAt: currentIndexPath) else { return cancelAction() }
               
        let title = dataSource.multiController(self, didSelectRowAt: currentIndexPath)
        lastSelectedButton?.setTitle(title, for: .normal)
        if selectedIndexPath.contains(currentIndexPath),
           let button = titleStackView.arrangedSubviews[safe: column + 1] as? UIButton
        {
            selectedIndexPath.append(currentIndexPath)
            clickTitleButton(button)
        } else {
            deletePageFromColumn(column + 1)
            selectedIndexPath.append(currentIndexPath)
            addPage()
        }
    }
}
extension CLMultiController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == tableViewScrollView else { return }
        let index = Int(tableViewScrollView.contentOffset.x / tableViewScrollView.bounds.width);
        guard let button = titleStackView.arrangedSubviews[safe: index] as? UIButton else { return }
        clickTitleButton(button)
    }
}
