# iOS开发之弹窗管理

## 前言

“千淘万漉虽辛苦，吹尽狂沙始到金。”在这快速变化的互联网行业，身边的朋友有的选择了勇敢创业，有的则在技术的海洋中默默耕耘。时常在深夜反思，作为一个开发者，我们的价值何在？答案或许就在那行代码中，润物细无声。以下是我在日常开发中封装的一个弹窗管理工具——[CLPopoverManager](https://github.com/JmoVxia/CLPopoverManager)，希望能为大家提供一些灵感和帮助。

## 概述

在移动应用开发中，弹窗作为一种重要的用户交互方式，使用频率非常高。无论是提示信息、广告展示，还是操作确认，弹窗都扮演着重要角色。然而，如果弹窗的显示逻辑缺乏合理控制，可能会出现弹窗重叠、顺序混乱等问题，极大影响用户体验。因此，我开发了[CLPopoverManager](https://github.com/JmoVxia/CLPopoverManager)，旨在为弹窗显示提供一个统一、可控的管理方案。

## 核心特性

- **丰富的显示模式**: 提供七种精心设计的显示模式 (`queue`, `interrupt`,`suspend`,`replaceInheritSuspend`,`replaceClearSuspend`, `replaceAll`, `unique`)，灵活应对各种复杂的弹窗场景。
- **优先级队列**: 支持为弹窗设置优先级，确保重要信息（如强制更新、系统警报）能够优先展示。
- **防止重复弹出**: 可为弹窗设置唯一标识符 `identifier`，自动阻止相同弹窗的重复显示或入队。
- **事件穿透**: 允许弹窗下的 UI 元素继续响应用户操作，并可配置在穿透时自动隐藏弹窗。
- **全面的 UI 控制**: 独立于项目主体，轻松管理每个弹窗的屏幕方向、状态栏样式及可见性。
- **实现方式灵活**: 通过继承 `CLPopoverController` 快速实现、或者遵守 `CLPopoverProtocol`协议完全自定义实现。

## 工作原理

`CLPopoverManager` 采用一个全局单例来统一管理所有弹窗的生命周期。每个弹窗都由一个独立的 `UIWindow` 承载，并由一个自定义的 `UIViewController` 子类来管理其内容和行为。

- **显示逻辑**: 当调用 `CLPopoverManager.show()` 时，管理器会根据弹窗配置的 `displayMode` 和 `priority` 来决定是立即显示、加入等待队列，还是替换现有弹窗。
- **等待队列**: 未能立即显示的弹窗会进入一个内部的等待队列。当一个弹窗关闭后，管理器会自动从队列中取出优先级最高的下一个弹窗进行显示。
- **独立 Window**: 使用独立的 `UIWindow` 可以确保弹窗的 UI 层级高于应用主界面，并且可以独立控制其旋转、状态栏等，而不会干扰应用的 `keyWindow`。

## 如何使用

#### 方式一

继承`CLPopoverController`，重写`showAnimation`和`dismissAnimation`方法，快速实现

```swift
import UIKit

class MyCustomPopupController: CLPopoverController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 在这里构建你的弹窗 UI
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        view.addSubview(contentView)
        
        // 使用 SnapKit 或 AutoLayout 进行布局
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.widthAnchor.constraint(equalToConstant: 280),
            contentView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    // 实现自定义的显示动画
    override func showAnimation(completion: (() -> Void)?) {
        view.alpha = 0
        transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.alpha = 1
            self.transform = .identity
        }, completion: { _ in
            completion?()
        })
    }

    // 实现自定义的隐藏动画
    override func dismissAnimation(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 0
        }, completion: { _ in
            completion?()
        })
    }
}
```

#### 方式二

准守`CLPopoverProtocol`协议，完全自定义，这会导致`config`配置中的部分属性失效，需要自己处理

```swift
/// 是否自动旋转屏幕，继承CLPopoverController才生效
public var shouldAutorotate = false
/// 是否隐藏状态栏，继承CLPopoverController才生效
public var prefersStatusBarHidden = false
/// 状态栏样式，继承CLPopoverController才生效
public var preferredStatusBarStyle = UIStatusBarStyle.lightContent
/// 支持的界面方向，继承CLPopoverController才生效
public var supportedInterfaceOrientations = UIInterfaceOrientationMask.portrait
/// 用户界面样式，包括夜间模式，继承CLPopoverController才生效
public var userInterfaceStyleOverride = CLUserInterfaceStyle.light
```



### 显示与隐藏弹窗

```swift
// 创建弹窗实例
let popup = MyCustomPopupController()

// --- 配置弹窗行为 ---
// 设置为排队模式
popup.config.popoverMode = .queue 
// 设置优先级
popup.config.popoverPriority = .medium
// 设置唯一标识符以防止重复
popup.config.identifier = "my-unique-popup"

// 显示弹窗
CLPopoverManager.show(popup) {
    print("弹窗已显示")
}

// 隐藏指定弹窗 (需要使用 show 方法返回的 key)
// let key = CLPopoverManager.show(popup)
// CLPopoverManager.dismiss(key)

// 隐藏所有弹窗
CLPopoverManager.dismissAll()
```

## 配置选项详解

通过修改 `CLPopoverController` 的 `config` 属性，可以精细化控制弹窗的行为。

### 显示模式 (`CLDisplayMode`)

这是 `CLPopoverManager` 的核心功能，用于处理复杂的弹窗冲突场景。

- `.queue` (默认)
  - **行为**: 如果当前没有弹窗，则立即显示。否则，加入等待队列。当一个弹窗关闭后，管理器会从队列中选择优先级最高的下一个弹窗显示。
  - **适用场景**: 普通的、非紧急的提示，如“操作成功”、“消息已发送”等。
- `.interrupt`
  - **行为**: 无视当前是否有弹窗正在显示或排队，立即在最顶层显示。这可能导致多个弹窗重叠。
  - **适用场景**: 需要立即引起用户注意，但又不希望打断其他流程的临时信息，例如顶部滑入的即时消息通知。
- `.suspend`
  - **行为**：替换当正在显示的弹窗，将正在显示的弹窗隐藏并且提交到挂起队列，不会移除被挂起的弹窗，也不会移除等待中的弹窗
  
  - **适用场景**: 需要立即引起用户注意并且只显示自己，但又不希望中断其他流程的临时信息。
- `.replaceInheritSuspend`
  - **行为**: 强制关闭并移除所有当前正在显示的弹窗，然后立即显示自己。此操作会接管被替换弹窗的挂起队列，不会影响等待队列中的弹窗。
  - **适用场景**: 需要替换当前内容的弹窗并且不影响前面的挂起逻辑，例如在一个信息确认弹窗上，点击“查看详情”后，用详情弹窗替换掉确认弹窗。
- `.replaceClearSuspend`
  - **行为**: 强制关闭并移除所有当前正在显示的弹窗，然后立即显示自己。此操作会清空被替换弹窗的挂起队列，不会影响等待队列中的弹窗。
  - **适用场景**: 需要替换当前内容的弹窗并且清除前面的挂起逻辑，例如一个信息确认弹窗挂起了其他弹窗，点击“查看详情”后，用详情弹窗替换掉掉前面所有弹窗。

- `.replaceAll`
  - **行为**: 强制关闭并移除所有当前正在显示的弹窗，并清空整个等待队列，然后立即显示自己。
  - **适用场景**: 关键的流程切换，例如用户被强制下线或需要重新登录时，使用此模式可以清理掉所有旧的弹窗，只显示登录提示。
- `.unique`
  - **行为**: 与 `.replaceAll` 类似，会清空所有已显示和等待中的弹窗。此外，只要这个 `unique` 弹窗还在显示，后续**所有**新的弹窗（无论何种模式）都将被忽略，无法显示。
  - **适用场景**: 绝对独占的、模态的场景，例如新手引导流程、或需要用户完成特定任务才能继续的界面。

### 优先级 (`CLPopoverPriority`)

- **行为**: 当多个弹窗在等待队列中时，优先级最高的会被优先选中显示。如果优先级相同，则遵循“先进先出”（FIFO）原则。
- **级别**: `.low`, `.mediumLow`, `.medium`, `.mediumHigh`, `.high`, 或 `.customValue(Int)`。
- **注意**: 优先级只对处于 `.queue` 模式并进入等待队列的弹窗有效。

### 其他重要配置

- `config.identifier: String?`: 设置唯一标识符，`CLPopoverManager` 会阻止 `identifier` 相同的弹窗重复显示或入队。
- `config.allowsEventPenetration: Bool`: 是否允许点击事件穿透弹窗背景，传递给下方的 UI。默认为 `false`。
- `config.autoHideWhenPenetrated: Bool`: 当事件穿透发生时，是否自动隐藏该弹窗。仅在 `allowsEventPenetration` 为 `true` 时生效。

## 常见问题解答（QA）

### 为什么使用 `UIViewController` 而不是 `UIView`？

`UIViewController` 相比 `UIView` 能够提供完整的生命周期方法（`viewDidLoad`, `viewWillAppear` 等），使得管理复杂的弹窗状态和逻辑变得更加清晰和可靠。

### 为什么每个弹窗都使用独立的 `UIWindow`？

使用独立的 `UIWindow` 可以将弹窗的 UI 层级置于应用主窗口之上，从而避免被项目中的其他视图意外遮挡。同时，它允许我们为每个弹窗独立控制屏幕方向、状态栏样式等，而不影响应用本身。

### 为什么有了优先级还需要这么多显示模式？

优先级解决了“**谁先显示**”的问题，而显示模式解决了“**何时以及如何显示**”的问题。例如，一个高优先级的弹窗也可能需要排队（`.queue`），或者需要替换掉当前所有内容（`.replaceAll`）。两者结合，为处理各种复杂的弹窗需求提供了极大的灵活性。

### 如何支持弹窗基础上`push`？

准守`CLPopoverProtocol`协议，完全自己实现，这里你可以是一个`UINavigationController`控制器。

## 结语

通过封装 [CLPopoverManager](https://github.com/JmoVxia/CLPopoverManager)，我们能够更好地管理 iOS 应用中的弹窗显示逻辑，提升用户体验，保障应用的稳定性。希望这个工具能够帮助到大家，同时也欢迎各位提出宝贵的意见和建议。

开发是一种艺术，不仅需要技术的积累，更需要灵感和创造力。愿我们在追逐技术之巅的路上，能够彼此激励，共同成长。愿所有的开发者都能在自己的代码世界中找到那一片属于自己的净土。

**PS**:心中感慨良多，奈何腹中无墨，一个字总结——懒。

## 安装

### Cocoapods

```ruby
pod 'CLPopoverManager'
```
### Swift Package Manager

在 Xcode 中，选择 `File` > `Add Packages...`，然后输入包的 URL:

```
https://github.com/JmoVxia/CLPopoverManager.git
```
或者在你的 `Package.swift` 文件中添加依赖：

```swift
dependencies: [
    .package(url: "https://github.com/JmoVxia/CLPopoverManager.git", from: "0.0.5")
]
```