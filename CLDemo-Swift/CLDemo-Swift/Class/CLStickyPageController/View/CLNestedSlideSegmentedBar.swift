import SnapKit
import UIKit

// MARK: - JmoVxia---顶部导航栏组件 (CLStickyPageSegmentedBar)

/// 顶部导航栏分段器组件
public class CLStickyPageSegmentedBar: UIView {
    /// 未选中时的普通文字颜色
    public var normalColor: UIColor = .init(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
    /// 选中时的强调文字颜色
    public var activeColor: UIColor = .init(red: 0.0, green: 0.65, blue: 0.33, alpha: 1.0)

    /// 未选中时的普通字体
    public var normalFont: UIFont = .systemFont(ofSize: 16, weight: .medium)
    /// 选中时的强调字体
    public var activeFont: UIFont = .systemFont(ofSize: 18, weight: .bold)

    /// 底部指示器的高度
    public var indicatorHeight: CGFloat = 6.0
    /// 底部指示器的宽度
    public var indicatorWidth: CGFloat = 60.0
    /// 指示器的底部偏移量 (负数表示向上偏移)
    public var indicatorBottomOffset: CGFloat = -2.0
    /// 指示器的圆角半径
    public var indicatorCornerRadius: CGFloat = 3.0
    /// 指示器的渐变色数组配置
    public var indicatorColors: [UIColor]?

    /// 标签组排列分布方式
    public var itemDistribution: UIStackView.Distribution = .fillEqually {
        didSet { stackView.distribution = itemDistribution }
    }

    /// 标签之间的额外间距
    public var itemSpacing: CGFloat = 0 {
        didSet { stackView.spacing = itemSpacing }
    }

    /// 导航栏整体是否允许超出横向滑动
    public var isScrollEnabled: Bool {
        get { scrollView.isScrollEnabled }
        set { scrollView.isScrollEnabled = newValue }
    }

    /// 底部分割线颜色
    public var bottomLineColor: UIColor = .black.withAlphaComponent(0.08)

    /// 切换状态的动画时长
    public var animationDuration: TimeInterval = 0.35
    /// 切换状态的弹簧阻尼
    public var springDamping: CGFloat = 0.7
    /// 切换状态的初始速度
    public var springVelocity: CGFloat = 0.5

    /// 标题标签点击的回调事件
    public var onSelect: ((Int) -> Void)?

    /// 当前处于选中状态的索引
    public private(set) var selectedIndex: Int = 0

    /// 横向滚动主视图
    private let scrollView = UIScrollView()
    /// 内容承载堆栈
    private let stackView = UIStackView()
    /// 动画滑动的指示器视图
    private let indicatorView = UIView()
    /// 高斯模糊背景（如有扩展需用到）
    private var blurView: UIVisualEffectView?
    /// 底部的固定分割线
    private let bottomLine = UIView()
    /// 保存所有创建的标签实例
    private var titleLabels: [UILabel] = []
    /// 外部传入的标题数据
    private var titles: [String] = []
    /// 记录一次跨页切换的起始索引
    private var transitionFromIndex: Int?
    /// 记录一次跨页切换的目标索引
    private var transitionToIndex: Int?
    /// 实时过渡中上一次参与插值的主索引
    private var progressPrimaryIndex: Int?
    /// 实时过渡中上一次参与插值的次索引
    private var progressSecondaryIndex: Int?
    /// 首次选中态是否已完成（用于抑制首次创建时的动画闪烁）
    private var hasCommittedInitialSelection = false

    /// 文字缩放系数缓存
    private var scaleFactor: CGFloat {
        activeFont.pointSize / normalFont.pointSize
    }

    /// 初始化方法
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    /// Coder 初始化方法
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

private extension CLStickyPageSegmentedBar {
    /// 构建导航栏基础 UI 层次
    func setupUI() {
        bottomLine.backgroundColor = bottomLineColor
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }

        addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.snp.makeConstraints { make in make.edges.equalToSuperview() }

        stackView.axis = .horizontal
        stackView.distribution = itemDistribution
        stackView.alignment = .fill
        stackView.spacing = itemSpacing
        scrollView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(self.snp.width).priority(.medium)
        }

        indicatorView.clipsToBounds = true
        scrollView.addSubview(indicatorView)

        indicatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(indicatorBottomOffset)
            make.height.equalTo(indicatorHeight)
            make.width.equalTo(indicatorWidth)
            make.left.equalToSuperview().priority(.low)
        }
    }

    /// 刷新渐变器及颜色等参数配置
    func refreshConfiguration() {
        bottomLine.backgroundColor = bottomLineColor
        indicatorView.layer.cornerRadius = indicatorCornerRadius
        let gradientColors = indicatorColors ?? [activeColor, activeColor.withAlphaComponent(0.6)]

        indicatorView.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        let gradient = CAGradientLayer()
        gradient.colors = gradientColors.map(\.cgColor)
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.frame = CGRect(x: 0, y: 0, width: indicatorWidth, height: indicatorHeight)
        gradient.cornerRadius = indicatorCornerRadius
        indicatorView.layer.insertSublayer(gradient, at: 0)
    }

    /// 重新载入并重绘所有标题标签
    func setupLabels() {
        refreshConfiguration()
        hasCommittedInitialSelection = false
        transitionFromIndex = nil
        transitionToIndex = nil
        progressPrimaryIndex = nil
        progressSecondaryIndex = nil
        titleLabels.forEach { $0.removeFromSuperview() }
        titleLabels.removeAll()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (index, title) in titles.enumerated() {
            let label = UILabel()
            label.font = normalFont
            label.text = title
            label.textAlignment = .center
            label.isUserInteractionEnabled = true

            if index == selectedIndex {
                label.textColor = activeColor
                label.font = activeFont
                label.transform = .identity
            } else {
                label.textColor = normalColor
                label.transform = .identity
            }

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
            label.addGestureRecognizer(tapGesture)
            label.tag = index
            stackView.addArrangedSubview(label)
            titleLabels.append(label)
        }

        DispatchQueue.main.async { self.updateIndicatorPosition(for: self.selectedIndex, animated: false) }
    }
}

public extension CLStickyPageSegmentedBar {
    /// 注入标题数据字典以执行重载
    func setTitles(_ titles: [String]) {
        self.titles = titles
        setupLabels()
    }

    /// 直接强制切换到目标 Index，更新全部外观
    func setSelectedIndex(_ index: Int, animated: Bool = true) {
        guard index < titleLabels.count else { return }
        let shouldAnimate = hasCommittedInitialSelection ? animated : false
        hasCommittedInitialSelection = true

        let previousSelectedIndex = selectedIndex
        let isTransitionCommitting = transitionFromIndex != nil && transitionToIndex == index && transitionFromIndex != index
        transitionFromIndex = nil
        if !isTransitionCommitting {
            transitionToIndex = nil
        }
        selectedIndex = index
        guard !isTransitionCommitting else {
            scrollLabelToVisible(at: index, animated: shouldAnimate)
            return
        }
        updateAppearance(for: index, previousIndex: previousSelectedIndex)
        updateIndicatorPosition(for: index, animated: shouldAnimate)
        scrollLabelToVisible(at: index, animated: shouldAnimate)
    }

    /// 依据手势偏移量实时更新指示器坐标进度
    func updateIndicatorWithOffset(baseIndex: Int, offset: CGFloat) {
        guard baseIndex < titleLabels.count else { return }

        let currentLabel = titleLabels[baseIndex]
        var targetCenterX = currentLabel.center.x

        let nextIndex = offset > 0 ? baseIndex + 1 : baseIndex - 1
        guard nextIndex >= 0, nextIndex < titleLabels.count, offset != 0 else {
            indicatorView.center.x = targetCenterX
            return
        }

        let targetLabel = titleLabels[nextIndex]
        targetCenterX += (targetLabel.center.x - currentLabel.center.x) * abs(offset)
        indicatorView.center.x = targetCenterX
    }

    /// 依据手势偏移量实时更新多段文字缩放与色相差
    func updateTitleColorWithProgress(baseIndex: Int, offset: CGFloat) {
        if let fromIndex = transitionFromIndex, let toIndex = transitionToIndex, fromIndex != toIndex {
            let progressIndex = CGFloat(baseIndex) + offset
            let distance = CGFloat(toIndex - fromIndex)
            let rawProgress = (progressIndex - CGFloat(fromIndex)) / distance
            let transitionProgress = max(0, min(1, rawProgress))

            trackProgressIndices(primary: fromIndex, secondary: toIndex)
            applyProgressAppearance(at: fromIndex, progress: 1.0 - transitionProgress)
            applyProgressAppearance(at: toIndex, progress: transitionProgress)

            if abs(progressIndex - CGFloat(toIndex)) <= 0.001 {
                transitionFromIndex = nil
                transitionToIndex = nil
                updateAppearance(for: toIndex, previousIndex: fromIndex)
            }
            return
        }

        // 无横向位移时保持标准选中态，避免首次创建时出现缩放闪烁。
        if abs(offset) <= 0.0001 {
            trackProgressIndices(primary: baseIndex, secondary: nil)
            applySelectedAppearance(at: baseIndex)
            return
        }

        let targetIndex = offset > 0 ? baseIndex + 1 : (offset < 0 ? baseIndex - 1 : baseIndex)
        if baseIndex != targetIndex {
            trackProgressIndices(primary: baseIndex, secondary: targetIndex)
            applyProgressAppearance(at: baseIndex, progress: 1.0 - abs(offset))
            applyProgressAppearance(at: targetIndex, progress: abs(offset))
        } else {
            trackProgressIndices(primary: baseIndex, secondary: nil)
            applyProgressAppearance(at: baseIndex, progress: 1.0)
        }
    }
}

private extension CLStickyPageSegmentedBar {
    /// 标签原生手势点击拦截回调
    @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel else { return }
        if label.tag != selectedIndex {
            transitionFromIndex = selectedIndex
            transitionToIndex = label.tag
        }
        onSelect?(label.tag)
    }

    /// 强制刷新普通/选中的字体颜色与大小状态
    func updateAppearance(for index: Int, previousIndex: Int) {
        clearTrackedProgressAppearance(keeping: index)
        resetLabelAppearance(at: previousIndex)
        applySelectedAppearance(at: index)
    }

    /// 保证选中标签在超出屏幕时被自动滚动居中
    func scrollLabelToVisible(at index: Int, animated: Bool) {
        guard isScrollEnabled, index < titleLabels.count else { return }
        let label = titleLabels[index]
        var offsetX = label.center.x - scrollView.bounds.width * 0.5
        let maxOffsetX = scrollView.contentSize.width - scrollView.bounds.width
        offsetX = max(0, min(offsetX, maxOffsetX))
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
    }

    /// 修改指示器约束并执行位移弹簧动画
    func updateIndicatorPosition(for index: Int, animated: Bool = true) {
        guard index < titleLabels.count else { return }
        let targetLabel = titleLabels[index]

        indicatorView.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().offset(indicatorBottomOffset)
            make.height.equalTo(indicatorHeight)
            make.width.equalTo(indicatorWidth)
            make.centerX.equalTo(targetLabel)
        }

        guard animated else {
            layoutIfNeeded()
            return
        }

        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: [.curveEaseInOut], animations: {
            self.layoutIfNeeded()
        })
    }

    /// 通过起止点和进度平滑进行 RGBA 通道插值演算
    func interpolateColor(from startColor: UIColor, to endColor: UIColor, progress: CGFloat) -> UIColor {
        guard progress > 0 else { return startColor }
        guard progress < 1 else { return endColor }

        var startRed: CGFloat = 0, startGreen: CGFloat = 0, startBlue: CGFloat = 0, startAlpha: CGFloat = 0
        var endRed: CGFloat = 0, endGreen: CGFloat = 0, endBlue: CGFloat = 0, endAlpha: CGFloat = 0

        startColor.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
        endColor.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)

        let red = startRed + (endRed - startRed) * progress
        let green = startGreen + (endGreen - startGreen) * progress
        let blue = startBlue + (endBlue - startBlue) * progress
        let alpha = startAlpha + (endAlpha - startAlpha) * progress

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// 记录并清理实时过渡涉及的标签索引
    func trackProgressIndices(primary: Int, secondary: Int?) {
        let oldPrimary = progressPrimaryIndex
        let oldSecondary = progressSecondaryIndex
        progressPrimaryIndex = primary
        progressSecondaryIndex = secondary

        if let oldPrimary, oldPrimary != primary, oldPrimary != secondary {
            resetLabelAppearance(at: oldPrimary)
        }
        if let oldSecondary, oldSecondary != primary, oldSecondary != secondary {
            resetLabelAppearance(at: oldSecondary)
        }
    }

    /// 清理实时过渡的历史标签外观
    func clearTrackedProgressAppearance(keeping index: Int?) {
        let oldPrimary = progressPrimaryIndex
        let oldSecondary = progressSecondaryIndex
        progressPrimaryIndex = nil
        progressSecondaryIndex = nil

        if let oldPrimary, oldPrimary != index {
            resetLabelAppearance(at: oldPrimary)
        }
        if let oldSecondary, oldSecondary != index, oldSecondary != oldPrimary {
            resetLabelAppearance(at: oldSecondary)
        }
    }

    /// 将指定标签恢复为普通状态
    func resetLabelAppearance(at index: Int) {
        guard index >= 0, index < titleLabels.count else { return }
        let label = titleLabels[index]
        label.textColor = normalColor
        label.font = normalFont
        label.transform = .identity
    }

    /// 将指定标签设置为选中状态
    func applySelectedAppearance(at index: Int) {
        guard index >= 0, index < titleLabels.count else { return }
        let label = titleLabels[index]
        label.textColor = activeColor
        label.font = activeFont
        label.transform = .identity
    }

    /// 按进度更新指定标签颜色与缩放
    func applyProgressAppearance(at index: Int, progress: CGFloat) {
        guard index >= 0, index < titleLabels.count else { return }
        let label = titleLabels[index]
        let clampedProgress = max(0, min(1, progress))
        if label.font != normalFont {
            label.font = normalFont
        }
        label.textColor = interpolateColor(from: normalColor, to: activeColor, progress: clampedProgress)
        let scale = 1 + (scaleFactor - 1) * clampedProgress
        label.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}
