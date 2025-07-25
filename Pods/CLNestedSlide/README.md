# CLNestedSlide

一个强大的 iOS 嵌套滑动框架，提供头部视图、悬停视图和分页内容之间的无缝滚动协调。

## 🌟 特性

- **🔄 嵌套滚动协调**: 主滚动视图与子滚动视图之间的丝滑协调
- **📱 头部和悬停视图**: 支持可滚动消失的头部视图和始终可见的悬停视图
- **📄 水平分页**: 水平分页滚动，支持懒加载和非懒加载模式
- **🎯 自动代理拦截**: 零配置的滚动视图代理转发
- **⚡ 高性能**: 支持懒加载模式，内存友好
- **🔧 灵活布局**: 完全自定义的布局控制和边距设置
- **🎨 现代架构**: 基于协议的设计，易于集成和扩展
- **🔄 横竖屏支持**: 内置横竖屏旋转支持，自动适配布局
- **📦 多种滚动视图**: 只要页面视图实现 CLNestedSlideViewPage 协议（如 UITableView、UICollectionView、UIScrollView 等），即可集成，框架本身不内置特殊适配
- **🎯 零侵入**: 框架不会影响原有滚动视图的代理方法实现

## 📋 系统要求

- iOS 13.0+
- Swift 5.0+

## 📦 安装

### CocoaPods

```ruby
pod 'CLNestedSlide'
```

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/JmoVxia/CLNestedSlide.git", from: "1.0.2")
]
```

## 🚀 快速开始

### 第一步：创建 CLNestedSlideView

```swift
import CLNestedSlide

class ViewController: UIViewController {
    // 推荐：懒加载模式（默认）
    private lazy var nestedSlideView: CLNestedSlideView = {
        let view = CLNestedSlideView() // 默认启用懒加载
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNestedSlideView()
    }
    
    private func setupNestedSlideView() {
        view.addSubview(nestedSlideView)
        nestedSlideView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 配置头部和悬停视图（可选）
        nestedSlideView.headerView = createHeaderView()
        nestedSlideView.hoverView = createHoverView()
        
        // 🔑 关键步骤：调用 reload() 创建页面
        nestedSlideView.reload()
    }
}
```

### 第二步：实现数据源协议 （必需）

```swift
// 🔑 关键：必须实现 CLNestedSlideViewDataSource 协议
extension ViewController: CLNestedSlideViewDataSource {
    // 🔑 关键：返回页面总数
    func numberOfPages(in nestedSlideView: CLNestedSlideView) -> Int {
        return pageData.count // 你的页面数量
    }
    
    // 🔑 关键：为每个索引创建页面视图
    // 返回的视图必须遵循 CLNestedSlideViewPage 协议
    func nestedSlideView(_ nestedSlideView: CLNestedSlideView, pageFor index: Int) -> CLNestedSlideViewPage {
        let data = pageData[index]
        return CLDemoPageView(title: data.0, content: data.1, bgColor: data.2)
    }
}
```

### 第三步：创建页面视图 （关键）

页面视图需实现 `CLNestedSlideViewPage` 协议，并在内部通过 AutoLayout 约束撑开 `scrollView`，如：

- 继承自 UIView
- 实现 `var scrollView: UIScrollView { get }`

只要满足上述要求，无论是 UITableView、UICollectionView 还是自定义 UIScrollView 页面，都可无缝集成。

### 第四步：实现代理方法 （可选）

```swift
extension ViewController: CLNestedSlideViewDelegate {
    func contentScrollViewDidScroll(_ nestedSlideView: CLNestedSlideView, scrollView: UIScrollView, progress: CGFloat) {
        // 水平分页滚动时调用，progress 为滚动进度（0.0 到 页面数-1）
        print("页面切换进度: \(progress)")
    }
    
    func contentScrollViewDidScrollToPage(at index: Int) {
        // 滚动到指定页面时调用
        print("切换到第 \(index + 1) 页")
    }
}
```

### 第五步：创建头部和悬停视图 （可选）

推荐做法：在自定义 headerView/hoverView 内部，通过子视图（如 label）用约束撑开父 view，无需在外部设置高度。例如：

```swift
class CustomHeaderView: UIView {
    private let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.text = "这是头部视图"
        label.textAlignment = .center
        label.textColor = .white
        addSubview(label)
        // 关键：label 约束撑开父 view（使用 SnapKit）
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backgroundColor = .systemBlue
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
```

同理，hoverView 也推荐用 SnapKit 让内部控件撑开父 view。

### 页面视图要求详解

#### CLNestedSlideViewPage 协议要求

```swift
protocol CLNestedSlideViewPage: AnyObject where Self: UIView {
    // 🔑 必需实现：提供内部的滚动视图
    var scrollView: UIScrollView { get }
}
```

#### 支持的滚动视图类型

- ✅ **UITableView**：最常用，支持各种 delegate 方法
- ✅ **UICollectionView**：支持网格布局和自定义布局
- ✅ **UIScrollView**：支持自定义滚动内容
- ✅ **WKWebView**：web 内容滚动（需要返回 scrollView 属性）

#### 示例：不同类型的页面视图

```swift
// UICollectionView 页面
class CollectionPageView: UIView, CLNestedSlideViewPage {
    private let collectionView: UICollectionView
    
    var scrollView: UIScrollView { collectionView }
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: .zero)
        
        // 正常设置代理
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// 自定义 UIScrollView 页面
class ScrollPageView: UIView, CLNestedSlideViewPage {
    private let customScrollView = UIScrollView()
    
    var scrollView: UIScrollView { customScrollView }
    
    init() {
        super.init(frame: .zero)
        setupScrollView()
    }
    
    private func setupScrollView() {
        // 正常配置 scrollView
        customScrollView.delegate = self
        // 添加内容...
    }
}
```

### 常见问题

- **Q: headerView/hoverView 设置了但是看不到？**  
  A: 检查是否设置了高度约束或 intrinsicContentSize，没有高度的视图不会显示。

- **Q: 页面不能滚动或者滚动有问题？**  
  A: 确保页面视图遵循了 `CLNestedSlideViewPage` 协议，并正确实现了 `scrollView` 属性。

- **Q: 可以动态改变 headerView/hoverView 的高度吗？**  
  A: 可以，直接修改自定义 view 内部的高度约束即可，布局会自动更新。

- **Q: 如何禁用横向滑动？**  
  A: 设置 `nestedSlideView.isHorizontalScrollEnabled = false`

- **Q: 页面数量变化后怎么办？**  
  A: 更新数据源后调用 `nestedSlideView.reload()` 重新加载页面。

## 🔧 高级用法

### 代理方法

```swift
extension ViewController: CLNestedSlideViewDelegate {
    func contentScrollViewDidScroll(_ nestedSlideView: CLNestedSlideView, scrollView: UIScrollView, progress: CGFloat) {
        // 水平分页滚动时调用，progress 为滚动进度（0.0 到 页面数-1）
        print("页面切换进度: \(progress)")
    }
    
    func contentScrollViewDidScrollToPage(at index: Int) {
        // 滚动到指定页面时调用
        print("切换到第 \(index + 1) 页")
    }
}
```

### 编程式页面导航

```swift
// 导航到指定页面
nestedSlideView.scrollToPage(at: 1, animated: true)

// 获取当前页面索引
let currentIndex = nestedSlideView.currentPageIndex

// 设置当前页面索引
nestedSlideView.currentPageIndex = 2

// 获取当前可见页面
if let currentPage = nestedSlideView.currentPage {
    // 操作当前页面
}

// 获取指定索引的页面
if let page = nestedSlideView.page(at: 1) {
    // 操作指定页面
}

// 重新加载所有页面
nestedSlideView.reload()
```

### 加载模式

框架支持两种加载策略：

#### 懒加载模式（默认，推荐）
```swift
let nestedSlideView = CLNestedSlideView() // 默认懒加载
// 或者显式指定
let nestedSlideView = CLNestedSlideView(isLazyLoading: true)
```
- **优点**: 页面按需创建，内存友好，适合大量页面
- **缺点**: 首次访问页面时有轻微延迟
- **适用场景**: 页面数量较多（> 5 页）或页面内容复杂

#### 非懒加载模式
```swift
let nestedSlideView = CLNestedSlideView(isLazyLoading: false)
```
- **优点**: 所有页面在 `reload()` 时创建，访问速度快
- **缺点**: 内存占用较高
- **适用场景**: 页面数量较少（< 5 页）且需要快速切换

**注意**: 加载模式必须在初始化时设置，之后无法更改。

## 📚 公共属性和方法

### 页面管理
```swift
// 当前页面索引（支持 get/set）
var currentPageIndex: Int

// 总页数（只读）
var numberOfPages: Int

// 当前可见页面（只读）
var currentPage: CLNestedSlideViewPage?

// 是否启用懒加载模式（只读）
var isLazyLoadingEnabled: Bool

// 获取指定索引的页面（懒加载模式下可能返回 nil）
func page(at index: Int) -> CLNestedSlideViewPage?

// 滚动到指定页面
func scrollToPage(at index: Int, animated: Bool)

// 重新加载所有页面
func reload()
```

### 视图配置
```swift
// 顶部头部视图
var headerView: UIView?

// 滚动时保持可见的悬停视图
var hoverView: UIView?

// 是否允许横向滑动
var isHorizontalScrollEnabled: Bool

// 是否显示所有滚动条，默认 true
var showIndicator: Bool
```

#### 示例：关闭所有滚动条
```swift
nestedSlideView.showIndicator = false // 全部隐藏主/子滚动条
```

## 🏗 架构设计

### 核心组件

#### 1. CLNestedSlideView
主容器视图，管理整体滚动行为和页面协调。

#### 2. CLMultiGestureScrollView  
支持多手势同时识别的专用滚动视图，确保手势不冲突。

#### 3. CLObservingScrollView
支持 contentSize 变化监听的滚动视图，自动处理横竖屏切换时的内容偏移修正。

#### 4. CLNestedSlideViewPage 协议
定义参与嵌套滚动的页面视图要求。

### 协议要求

#### CLNestedSlideViewDataSource
```swift
protocol CLNestedSlideViewDataSource: AnyObject {
    func numberOfPages(in nestedSlideView: CLNestedSlideView) -> Int
    func nestedSlideView(_ nestedSlideView: CLNestedSlideView, pageFor index: Int) -> CLNestedSlideViewPage
}
```

#### CLNestedSlideViewDelegate
```swift
protocol CLNestedSlideViewDelegate: AnyObject {
    func contentScrollViewDidScroll(_ nestedSlideView: CLNestedSlideView, scrollView: UIScrollView, progress: CGFloat)
    func contentScrollViewDidScrollToPage(at index: Int)
}
```

#### CLNestedSlideViewPage
```swift
protocol CLNestedSlideViewPage: AnyObject where Self: UIView {
    var scrollView: UIScrollView { get }
    // 框架会自动设置以下属性和方法，你无需实现
    var isSwipeEnabled: Bool { get set }
    var superScrollEnabledHandler: ((Bool) -> Bool)? { get set }
    func setupScrollViewDelegateIfNeeded()
}
```

就这么简单！框架会在内部处理所有复杂的滚动协调。

## ✨ 核心特性

### 🔄 自动代理转发
框架自动拦截滚动视图代理方法并转发到你的实现。你可以正常使用 `scrollView.delegate = self`，无需额外设置。

### 📱 无缝嵌套滚动
框架协调主滚动视图和子滚动视图之间的滚动，提供流畅的过渡效果，防止滚动冲突。

### 🎯 零配置
页面只需实现 `CLNestedSlideViewPage` 协议的单个 `scrollView` 属性。所有滚动协调都自动处理。

### ⚡ 灵活的加载模式
- **懒加载（默认）**: 按需创建页面，节省内存，适合大量页面
- **非懒加载**: 预先创建所有页面，适合少量页面，性能更好

### 🔧 灵活的架构
- 支持任何类型的滚动视图（UITableView、UICollectionView、UIScrollView）
- 可自定义头部和悬停视图
- 基于页面的水平滚动
- 可配置的布局间距和边距
- 可选择懒加载或非懒加载策略

### 📐 旋转适配
内置横竖屏切换支持，自动修正内容偏移，确保页面对齐无偏移。

## 🎯 最佳实践

1. **内存管理**: 框架会缓存已创建的页面以提升性能，但**不会自动清理或释放页面**。如果页面内容较重或有特殊内存需求，请在你的页面视图中自行实现资源释放或清理逻辑（如在页面被移除时手动释放大对象等）。

2. **滚动视图设置**: 确保你的滚动视图具有适当的内容大小和约束，以获得最佳滚动行为。

3. **代理实现**: 你可以正常实现滚动视图代理方法 - 框架确保你的代码和协调逻辑都能正确执行。

4. **布局更新**: 在重要的数据更改后调用 `nestedSlideView.reload()` 以刷新页面数量和布局。

5. **加载模式选择**: 
   - 页面数量 ≤ 5：建议使用非懒加载模式
   - 页面数量 > 5：建议使用懒加载模式

## 🔧 安全区域处理

所有内部堆栈视图都设置了 `insetsLayoutMarginsFromSafeArea = false` ，让你完全控制布局。如果需要，你可以手动处理安全区域。

## 📱 Demo 项目

查看包含的演示项目，了解完整的实现示例：
- 自定义头部和悬停视图  
- 多种页面类型（基于 UIScrollView）
- 代理方法实现
- 编程式导航
- 布局控制示例

## 📄 许可证

本项目基于 MIT 许可证开源。详见 [LICENSE](LICENSE) 文件。

## 👨‍💻 作者

Chen JmoVxia - [GitHub](https://github.com/JmoVxia)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

**如果这个库对你有帮助，请给个 ⭐️ 支持一下！** 
