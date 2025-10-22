# CLTableViewManger

CLTableViewManger 是一个轻量的数据驱动 UITableView 管理器，目标是把 UITableView 的数据源与代理逻辑抽象为`Item 驱动`模型，方便维护与复用。

#### 核心设计

- CLTableViewManager：基类，封装了 UITableViewDataSource / UITableViewDelegate 的常用实现，并能把部分 delegate 调用转发给外部代理（通过构造器注入或将来对外暴露的 delegate 属性）。
- 两种使用模式：
  - CLTableViewRowManager：基于“行列表”的单 section 模式（dataSource 为 [CLRowItemProtocol]）
  - CLTableViewSectionManager：基于“分区列表”的多 section 模式（dataSource 为 [CLSectionItemProtocol]）
- 数据模型与视图绑定：
  - Row 模型需要遵守 `CLRowItemProtocol`（必须提供 cellType；默认 cellHeight = UITableView.automaticDimension），并可通过闭包回调实现点击、willDisplay、cellForRow 等行为。
  - Section 模型遵守 `CLSectionItemProtocol`（可选择提供 header/footer 类型、rows 列表、回调等）。
  - Cell/Header/Footer 可以遵守对应协议以便自动 set 数据：`CLRowCellBaseProtocol` / `CLRowCellProtocol` / `CLSectionHeaderFooterProtocol`（内部提供 set(item:indexPath:) / set(item:section:) 辅助）。



#### 安装

##### Cocoapods

```
pod 'CLTableViewManager'
```

##### Swift Package Manager

在 Xcode 中，选择 `File` > `Add Packages...`，然后输入包的 URL:

```
https://github.com/JmoVxia/CLTableViewManager.git
```

或者在你的 `Package.swift` 文件中添加依赖：

```
dependencies: [
    .package(url: "https://github.com/JmoVxia/CLTableViewManager.git", from: "0.0.1")
]
```


#### 快速开始

- Row 模式（单 section，dataSource 为行数组）

```swift
// 创建 manager
let manager = CLTableViewRowManager()
// 设置为 tableView 的 dataSource & delegate，这里使用预估高度，对应RowItem有默认cellHeight，不需要重写，如果需要自己处理高度，需要重写
private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.dataSource = tableViewManager
        view.delegate = tableViewManager
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.estimatedRowHeight = 500
        view.estimatedSectionHeaderHeight = 0
        view.estimatedSectionFooterHeight = 0
        view.contentInset = .zero
        view.contentInsetAdjustmentBehavior = .never
        if #available(iOS 13.0, *) {
            view.automaticallyAdjustsScrollIndicatorInsets = false
        }
        if #available(iOS 15.0, *) {
            view.sectionHeaderTopPadding = 0
        }
        return view
 }()
// 创建 item
class MyRowItem: NSObject, CLRowItemProtocol {
  	//绑定Cell
    var cellType: UITableViewCell.Type { MyCell.self }
}

// cell赋值
class MyCell: UITableViewCell, CLRowCellProtocol {
  func setItem(_ item: MyRowItem, indexPath _: IndexPath) {
      titleLabel.text = item.title
      subtitleLabel.text = item.subtitle
  }
}
// 添加数据源，刷新
let item = MyRowItem()
manager.dataSource = [item, item]
tableView.reloadData()
```

- Section 模式（多 section）

```swift
// 创建 manager 
let manager = CLTableViewSectionManager()
// 设置为 tableView 的 dataSource & delegate，这里使用预估高度，对应SectionItem有默认headerHeight、footerHeight实现，不需要重写，如果需要自己处理高度，需要重写
private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.dataSource = tableViewManager
        view.delegate = tableViewManager
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.estimatedRowHeight = 80
        view.estimatedSectionHeaderHeight = 60
        view.estimatedSectionFooterHeight = 60
        view.contentInset = .zero
        view.contentInsetAdjustmentBehavior = .never
        if #available(iOS 13.0, *) {
            view.automaticallyAdjustsScrollIndicatorInsets = false
        }
        if #available(iOS 15.0, *) {
            view.sectionHeaderTopPadding = 0
        }
        return view
}()

// 创建 item
class MySectionItem: NSObject, CLSectionItemProtocol {
		//绑定headView
    var headerViewType: UITableViewHeaderFooterView.Type? { MySectionHeadView.self }
  	//绑定footerView
    var footerViewType: UITableViewHeaderFooterView.Type? { MySectionFooterView.self }
  	// 高度可选，默认约束撑开
    var headerHeight: CGFloat { 100.0 }
    var footerHeight: CGFloat { 100.0 }
}
// head赋值
class MySectionHeadView: UITableViewHeaderFooterView, CLSectionHeaderFooterProtocol {
  func setItem(_ item: MySectionItem, indexPath _: IndexPath) {
  }
}
// footer赋值
class MySectionFooterView: UITableViewHeaderFooterView, CLSectionHeaderFooterProtocol {
  func setItem(_ item: MySectionItem, indexPath _: IndexPath) {
  }
}
// 添加数据源，刷新
let section = MySectionItem()
let row = MyRowItem()
section.rows = [row]
manager.dataSource = [section]
tableView.reloadData()
```
