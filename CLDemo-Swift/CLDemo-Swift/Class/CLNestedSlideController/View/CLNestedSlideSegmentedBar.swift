import SnapKit
import UIKit

final class CLNestedSlideSegmentedBar: UIView {
    var onSelect: ((Int) -> Void)?
    var normalColor: UIColor = .label
    var activeColor: UIColor = .systemOrange
    var scaleFactor: CGFloat = 1.125

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let indicatorView = UIView()
    private var titleLabels: [UILabel] = []
    private var titles: [String] = []
    private(set) var selectedIndex: Int = 0
    private var pendingTransitionTargetIndex: Int?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setTitles(_ titles: [String]) {
        self.titles = titles
        setupLabels()
    }

    func setSelectedIndex(_ index: Int, animated: Bool = true) {
        guard index < titleLabels.count else { return }
        selectedIndex = index
        pendingTransitionTargetIndex = nil
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
        let overallProgress = CGFloat(baseIndex) + offset
        if let pendingTransitionTargetIndex,
           pendingTransitionTargetIndex != selectedIndex,
           titleLabels.indices.contains(pendingTransitionTargetIndex)
        {
            updateTitleColorForPendingTransition(progress: overallProgress, targetIndex: pendingTransitionTargetIndex)
            return
        }

        let targetIndex = offset > 0 ? baseIndex + 1 : (offset < 0 ? baseIndex - 1 : baseIndex)
        updateTitleAppearance(from: baseIndex, to: targetIndex, progress: abs(offset))
    }
}

private extension CLNestedSlideSegmentedBar {
    func setupUI() {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        blur.layer.cornerRadius = 16
        blur.clipsToBounds = true
        insertSubview(blur, at: 0)
        blur.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        layer.cornerRadius = 16
        layer.masksToBounds = true

        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.black.withAlphaComponent(0.08)
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }

        addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }

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
        indicatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-2)
            make.height.equalTo(6)
            make.width.equalTo(60)
        }
    }

    func setupLabels() {
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

        stackView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
        }

        DispatchQueue.main.async {
            self.updateIndicatorPosition(for: 0, animated: false)
        }
    }

    @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel else { return }
        prepareTransition(to: label.tag)
        onSelect?(label.tag)
    }

    func prepareTransition(to index: Int) {
        guard titleLabels.indices.contains(index), index != selectedIndex else {
            pendingTransitionTargetIndex = nil
            return
        }
        pendingTransitionTargetIndex = index
    }

    func updateAppearance(for index: Int) {
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

    func updateTitleColorForPendingTransition(progress overallProgress: CGFloat, targetIndex: Int) {
        let startIndex = selectedIndex
        let distance = CGFloat(targetIndex - startIndex)
        guard distance != 0 else {
            updateAppearance(for: startIndex)
            return
        }

        let transitionProgress = min(max((overallProgress - CGFloat(startIndex)) / distance, 0), 1)
        updateTitleAppearance(from: startIndex, to: targetIndex, progress: transitionProgress)
    }

    func updateTitleAppearance(from sourceIndex: Int, to targetIndex: Int, progress: CGFloat) {
        let clampedProgress = min(max(progress, 0), 1)

        for (i, label) in titleLabels.enumerated() {
            if i == sourceIndex {
                let sourceProgress = 1 - clampedProgress
                label.textColor = interpolateColor(from: normalColor, to: activeColor, progress: sourceProgress)
                let scale = 1 + (scaleFactor - 1) * sourceProgress
                label.transform = CGAffineTransform(scaleX: scale, y: scale)
            } else if i == targetIndex, sourceIndex != targetIndex {
                label.textColor = interpolateColor(from: normalColor, to: activeColor, progress: clampedProgress)
                let scale = 1 + (scaleFactor - 1) * clampedProgress
                label.transform = CGAffineTransform(scaleX: scale, y: scale)
            } else {
                label.textColor = normalColor
                label.transform = .identity
            }
        }
    }

    func updateIndicatorPosition(for index: Int, animated: Bool = true) {
        guard index < titleLabels.count else { return }
        let targetLabel = titleLabels[index]
        indicatorView.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().offset(-2)
            make.height.equalTo(6)
            make.width.equalTo(60)
            make.centerX.equalTo(targetLabel)
        }

        if animated {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.5,
                options: [.curveEaseInOut],
                animations: {
                    self.layoutIfNeeded()
                }
            )
        } else {
            layoutIfNeeded()
        }

        if let gradient = indicatorView.layer.sublayers?.first as? CAGradientLayer {
            gradient.frame = indicatorView.bounds
            gradient.cornerRadius = indicatorView.bounds.height / 2
        }
        indicatorView.layer.cornerRadius = indicatorView.bounds.height / 2
    }

    func interpolateColor(from startColor: UIColor, to endColor: UIColor, progress: CGFloat) -> UIColor {
        guard progress > 0 else { return startColor }
        guard progress < 1 else { return endColor }

        var startRed: CGFloat = 0
        var startGreen: CGFloat = 0
        var startBlue: CGFloat = 0
        var startAlpha: CGFloat = 0
        var endRed: CGFloat = 0
        var endGreen: CGFloat = 0
        var endBlue: CGFloat = 0
        var endAlpha: CGFloat = 0

        startColor.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
        endColor.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)

        let red = startRed + (endRed - startRed) * progress
        let green = startGreen + (endGreen - startGreen) * progress
        let blue = startBlue + (endBlue - startBlue) * progress
        let alpha = startAlpha + (endAlpha - startAlpha) * progress

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
