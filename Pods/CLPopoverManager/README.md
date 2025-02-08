# iOS开发之弹窗管理

## 前言

“千淘万漉虽辛苦，吹尽狂沙始到金。”在这快速变化的互联网行业，身边的朋友有的选择了勇敢创业，有的则在技术的海洋中默默耕耘。时常在深夜反思，作为一个开发者，我们的价值何在？答案或许就在那行代码中，润物细无声。以下是我在日常开发中封装的一个弹窗管理工具——[CLPopoverManager](https://github.com/JmoVxia/CLPopoverManager)，希望能为大家提供一些灵感和帮助。

## 概述

在移动应用开发中，弹窗作为一种重要的用户交互方式，使用频率非常高。无论是提示信息、广告展示，还是操作确认，弹窗都扮演着重要角色。然而，如果弹窗的显示逻辑缺乏合理控制，可能会出现弹窗重叠、顺序混乱等问题，极大影响用户体验。因此，我开发了[CLPopoverManager](https://github.com/JmoVxia/CLPopoverManager)，旨在为弹窗显示提供一个统一、可控的管理方案。

## 功能

-  支持`排队`、`插队`、`替换`、`唯一`模式
-  支持优先级设置
-  支持去重标记
-  支持手势穿透
-  支持手势穿透时自动隐藏
-  支持自动旋转
-  支持隐藏状态栏
-  支持状态栏样式
-  支持设置界面方向
-  支持夜间模式

## 原理

弹窗采用伪单例模式管理`UIWindow`，内部采用自定义队列控制显示顺序，对外使用`UIViewController`。

## 使用

自定义`UIViewController`继承`CLPopoverController`并且遵守`CLPopoverProtocol`协议即可，内部你可以自行实现弹窗相关动画和UI。

### 示例代码

```swift
Swift
Copy code
class CustomPopoverController: CLPopoverController, CLPopoverProtocol {
    // 实现弹窗相关逻辑
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        // 配置弹窗UI
    }
    
    func showAnimation(completion: (() -> Void)? = nil) {
        // 显示动画
    }
    
    func dismissAnimation(completion: (() -> Void)? = nil) {
        // 隐藏动画
    }
}

/// 弹出
let popover = CustomPopoverController()
popover.config.popoverMode = .queue
let key = CLPopoverManager.show(popover: popover)

/// 隐藏单个弹窗
CLPopoverManager.dismiss(key)
/// 隐藏所有弹窗
CLPopoverManager.dismissAll()
```

## 模式和优先级

### 模式

1. **排队模式**：如果当前没有弹窗显示，则立即显示；如果有弹窗正在显示，会进入到等待队列，后续按照优先级显示。
2. **插队模式**：无视当前显示的弹窗，立即显示，会多个弹窗重叠。
3. **替换模式**：替换当前显示的弹窗，立即显示，会隐藏之前的所有弹窗。
4. **唯一模式**：替换当前显示的弹窗，独占显示，会隐藏之前的所有弹窗并且阻止后续所有弹窗。

### 优先级

弹窗可以设置优先级，高优先级的弹窗将优先显示。只对进入到等待队列中的弹窗生效，前面弹窗消失后，会在等待队列中查找优先级高的弹窗优先显示。

## 常见问题解答（QA）

### 为什么使用 `UIViewController` 而不是 `UIView`？

`UIViewController` 相比 `UIView` 能够提供生命周期相关方法，管理起来更加方便。

### 为什么使用 `UIWindow`？

`UIWindow` 可以不入侵项目 `UI`，保障不扰乱当前项目的同时，可以实现横竖屏切换、状态栏样式等。

### 为什么是伪单例模式？

弹窗管理在所有弹窗都销毁后，会自动销毁管理者的单例。

### 为什么有优先级的情况还需要这么多模式？

需求多种多样，为保障灵活性的同时，还能够保障弹窗的顺序。

## 结语

通过封装 [CLPopoverManager](https://github.com/JmoVxia/CLPopoverManager)，我们能够更好地管理 iOS 应用中的弹窗显示逻辑，提升用户体验，保障应用的稳定性。希望这个工具能够帮助到大家，同时也欢迎各位提出宝贵的意见和建议。

开发是一种艺术，不仅需要技术的积累，更需要灵感和创造力。愿我们在追逐技术之巅的路上，能够彼此激励，共同成长。愿所有的开发者都能在自己的代码世界中找到那一片属于自己的净土。

**PS**:心中感慨良多，奈何腹中无墨，一个字总结——懒。

## cocoapods

```swift
pod ' CLPopoverManager'
```

