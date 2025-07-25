import SnapKit
import UIKit

class CLSegmentedBar: UIView {
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let indicatorView = UIView()
    private var titleLabels: [UILabel] = []
    private var titles: [String] = []
    private(set) var selectedIndex: Int = 0
    var onSelect: ((Int) -> Void)?
    var normalColor: UIColor = .label
    var activeColor: UIColor = .systemOrange
    /// 选中标签放大倍数
    private let scaleFactor: CGFloat = 1.125 // 对应 16 -> 18
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { super.init(coder: coder); setupUI() }
    func setTitles(_ titles: [String]) {
        self.titles = titles
        setupLabels()
    }

    /// 外部在滑动/点击结束后调用，切换到最终状态
    func setSelectedIndex(_ index: Int, animated: Bool = true) {
        guard index < titleLabels.count else { return }
        selectedIndex = index
        updateAppearance(for: index)
        updateIndicatorPosition(for: index, animated: animated)
    }

    func updateIndicatorWithOffset(baseIndex: Int, offset: CGFloat) {
        guard baseIndex < titleLabels.count else { return }
        let currentLabel = titleLabels[baseIndex]
        var targetCenterX = currentLabel.center.x
        if offset > 0, baseIndex + 1 < titleLabels.count {
            let nextLabel = titleLabels[baseIndex + 1]
            targetCenterX = currentLabel.center.x + (nextLabel.center.x - currentLabel.center.x) * offset
        } else if offset < 0, baseIndex > 0 {
            let prevLabel = titleLabels[baseIndex - 1]
            targetCenterX = currentLabel.center.x + (prevLabel.center.x - currentLabel.center.x) * -offset
        }
        indicatorView.center.x = targetCenterX
    }

    func updateTitleColorWithProgress(baseIndex: Int, offset: CGFloat) {
        let targetIndex = offset > 0 ? baseIndex + 1 : (offset < 0 ? baseIndex - 1 : baseIndex)
        for (i, label) in titleLabels.enumerated() {
            if i == baseIndex {
                let progress = 1.0 - abs(offset)
                label.textColor = interpolateColor(from: normalColor, to: activeColor, progress: progress)
                let scale = 1 + (scaleFactor - 1) * progress
                label.transform = CGAffineTransform(scaleX: scale, y: scale)
            } else if i == targetIndex, baseIndex != targetIndex {
                let progress = abs(offset)
                label.textColor = interpolateColor(from: normalColor, to: activeColor, progress: progress)
                let scale = 1 + (scaleFactor - 1) * progress
                label.transform = CGAffineTransform(scaleX: scale, y: scale)
            } else {
                label.textColor = normalColor
                label.transform = .identity
            }
        }
    }

    private func setupUI() {
        // 毛玻璃背景
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        blur.layer.cornerRadius = 16
        blur.clipsToBounds = true
        insertSubview(blur, at: 0)
        blur.snp.makeConstraints { make in make.edges.equalToSuperview() }
        layer.cornerRadius = 16
        layer.masksToBounds = true
        // 底部分割线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.black.withAlphaComponent(0.08)
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in make.left.right.bottom.equalToSuperview(); make.height.equalTo(1) }
        // 内容
        addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.snp.makeConstraints { make in make.edges.equalToSuperview() }
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in make.edges.equalToSuperview(); make.height.equalToSuperview() }
        // 渐变圆角指示器
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemOrange.cgColor, UIColor.systemPurple.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 6
        indicatorView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        indicatorView.layer.insertSublayer(gradient, at: 0)
        indicatorView.layer.cornerRadius = 6
        indicatorView.clipsToBounds = true
        addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in make.bottom.equalToSuperview().offset(-2); make.height.equalTo(6); make.width.equalTo(60) }
    }

    private func setupLabels() {
        titleLabels.forEach { $0.removeFromSuperview() }
        titleLabels.removeAll()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            label.font = .systemFont(ofSize: 16, weight: .medium)
            if index == selectedIndex {
                label.textColor = activeColor
                label.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            } else {
                label.textColor = normalColor
                label.transform = .identity
            }
            label.text = title
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            label.highlightedTextColor = nil
            label.backgroundColor = .clear
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
            label.addGestureRecognizer(tapGesture)
            label.tag = index
            stackView.addArrangedSubview(label)
            titleLabels.append(label)
        }
        stackView.snp.makeConstraints { make in make.width.equalTo(UIScreen.main.bounds.width) }
        DispatchQueue.main.async { self.updateIndicatorPosition(for: 0, animated: false) }
    }

    @objc private func labelTapped(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel else { return }
        // 点击时只触发外部滚动，不立即更新外观，避免先变黑再过渡
        onSelect?(label.tag)
    }

    private func updateAppearance(for index: Int) {
        for (i, label) in titleLabels.enumerated() {
            if i == index {
                label.textColor = activeColor
                label.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            } else {
                label.textColor = normalColor
                label.transform = .identity
            }
        }
    }

    private func updateIndicatorPosition(for index: Int, animated: Bool = true) {
        guard index < titleLabels.count else { return }
        let targetLabel = titleLabels[index]
        indicatorView.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().offset(-2)
            make.height.equalTo(6)
            make.width.equalTo(60)
            make.centerX.equalTo(targetLabel)
        }
        if animated {
            UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
                self.layoutIfNeeded()
            })
        } else {
            layoutIfNeeded()
        }
        // 渐变指示器自适应宽度和圆角
        if let gradient = indicatorView.layer.sublayers?.first as? CAGradientLayer {
            gradient.frame = indicatorView.bounds
            gradient.cornerRadius = indicatorView.bounds.height / 2
        }
        indicatorView.layer.cornerRadius = indicatorView.bounds.height / 2
    }

    private func interpolateColor(from startColor: UIColor, to endColor: UIColor, progress: CGFloat) -> UIColor {
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
}
