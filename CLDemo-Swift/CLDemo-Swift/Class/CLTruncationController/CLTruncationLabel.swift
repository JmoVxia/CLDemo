//
//  CLTruncationLabel.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2022/7/15.
//

import SnapKit
import UIKit

public enum CLTruncationMode {
    /// 精准, 性能稍低
    case binarySearch
    /// 性能高, 可能不太准确
    case fast
}

// MARK: - JmoVxia---类-属性

class CLTruncationLabel: UIControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var mainStackView: UIStackView = {
        let view = UIStackView()
        view.isUserInteractionEnabled = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.insetsLayoutMarginsFromSafeArea = false
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .zero
        view.spacing = 0
        return view
    }()

    private lazy var textLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var displayAttributedText: NSAttributedString?

    var truncationToken: (open: NSAttributedString, close: NSAttributedString) = (NSAttributedString(" [展开]") { $0
            .foregroundColor("#1F70FF".uiColor)
    }, NSAttributedString(" [折叠]") { $0
        .foregroundColor("#1F70FF".uiColor)
    })
    var attributedText: NSMutableAttributedString? {
        didSet {
            guard attributedText != oldValue else { return }
            displayAttributedText = attributedText
        }
    }

    var isOpen = false

    var numberOfLines: Int = 3

    var truncationMode: CLTruncationMode = .binarySearch

    var contentEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            guard contentEdgeInsets != oldValue else { return }
            mainStackView.layoutMargins = contentEdgeInsets
        }
    }
}

// MARK: - JmoVxia---布局

private extension CLTruncationLabel {
    func initSubViews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(textLabel)
    }

    func makeConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - JmoVxia---公共方法

extension CLTruncationLabel {
    func reload() {
        guard let attributedText = attributedText?.addAttributes({ $0.font(textLabel.font) }) else { return }
        guard Thread.isMainThread else { return DispatchQueue.main.async { self.reload() } }

        setNeedsLayout()
        layoutIfNeeded()

        let width = textLabel.bounds.width
        let lines = attributedText.lines(width)

        guard numberOfLines > 0, lines.count >= numberOfLines else {
            textLabel.attributedText = attributedText
            return
        }

        let token = isOpen ? truncationToken.close : truncationToken.open
        let length = lines.prefix(numberOfLines).reduce(0) { $0 + CTLineGetStringRange($1).length }

        let maxLength: Int = {
            guard !isOpen else { return attributedText.length }
            switch truncationMode {
            case .binarySearch:
                var low = 0, high = length, result = 0
                while low <= high {
                    let mid = (low + high) / 2
                    let range = NSRange(location: 0, length: mid)
                    guard NSMaxRange(range) <= attributedText.length else {
                        high = mid - 1
                        continue
                    }

                    let testText = NSMutableAttributedString(attributedString: attributedText.attributedSubstring(from: range))
                    testText.append(token)

                    if testText.lines(width).count <= numberOfLines {
                        result = mid
                        low = mid + 1
                    } else {
                        high = mid - 1
                    }
                }
                return result
            case .fast:
                let truncationTokenWidth = token.size().width
                return min(CTLineGetStringIndexForPosition(lines[numberOfLines - 1], CGPoint(x: width - truncationTokenWidth, y: 0)), length) - 1
            }
        }()

        displayAttributedText = {
            let range = NSRange(location: 0, length: max(0, maxLength))
            let result = NSMutableAttributedString(attributedString: attributedText.attributedSubstring(from: range))
            result.append(token)
            return result
        }()

        textLabel.attributedText = displayAttributedText
    }
}
