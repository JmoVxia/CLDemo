//
//  NSAttributedString+Extension.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2022/7/15.
//

import Foundation

extension NSAttributedString {
    /// 快捷初始化
    convenience init(_ text: String, attributes: ((_ item: AttributesItem) -> Void)? = nil) {
        let item = AttributesItem()
        attributes?(item)
        self.init(string: text, attributes: item.attributes)
    }

    /// 快捷初始化
    convenience init(_ image: UIImage, _ bounds: CGRect) {
        let attch = NSTextAttachment()
        attch.image = image
        attch.bounds = bounds
        self.init(attachment: attch)
    }
}

extension NSAttributedString {
    class AttributesItem {
        private(set) var attributes = [NSAttributedString.Key: Any]()
        private(set) lazy var paragraphStyle = NSMutableParagraphStyle()
        /// 字体
        @discardableResult
        func font(_ value: UIFont) -> AttributesItem {
            attributes[.font] = value
            return self
        }

        /// 字体颜色
        @discardableResult
        func foregroundColor(_ value: UIColor) -> AttributesItem {
            attributes[.foregroundColor] = value
            return self
        }

        /// 斜体
        @discardableResult
        func oblique(_ value: CGFloat) -> AttributesItem {
            attributes[.obliqueness] = value
            return self
        }

        /// 文本横向拉伸属性，正值横向拉伸文本，负值横向压缩文本
        @discardableResult
        func expansion(_ value: CGFloat) -> AttributesItem {
            attributes[.expansion] = value
            return self
        }

        /// 字间距
        @discardableResult
        func kern(_ value: CGFloat) -> AttributesItem {
            attributes[.kern] = value
            return self
        }

        /// 删除线
        @discardableResult
        func strikeStyle(_ value: NSUnderlineStyle) -> AttributesItem {
            attributes[.strikethroughStyle] = value.rawValue
            return self
        }

        /// 删除线颜色
        @discardableResult
        func strikeColor(_ value: UIColor) -> AttributesItem {
            attributes[.strikethroughColor] = value
            return self
        }

        /// 下划线
        @discardableResult
        func underlineStyle(_ value: NSUnderlineStyle) -> AttributesItem {
            attributes[.underlineStyle] = value.rawValue
            return self
        }

        /// 下划线颜色
        @discardableResult
        func underlineColor(_ value: UIColor) -> AttributesItem {
            attributes[.underlineColor] = value
            return self
        }

        /// 设置基线偏移值，正值上偏，负值下偏
        @discardableResult
        func baselineOffset(_ value: CGFloat) -> AttributesItem {
            attributes[.baselineOffset] = value
            return self
        }

        /// 居中方式
        @discardableResult
        func alignment(_ value: NSTextAlignment) -> AttributesItem {
            paragraphStyle.alignment = value
            attributes[.paragraphStyle] = paragraphStyle
            return self
        }

        /// 字符截断类型
        @discardableResult
        func lineBreakMode(_ value: NSLineBreakMode) -> AttributesItem {
            paragraphStyle.lineBreakMode = value
            attributes[.paragraphStyle] = paragraphStyle
            return self
        }

        /// 行间距
        @discardableResult
        func lineSpacing(_ value: CGFloat) -> AttributesItem {
            paragraphStyle.lineSpacing = value
            attributes[.paragraphStyle] = paragraphStyle
            return self
        }

        /// 最小行高
        @discardableResult
        func minimumLineHeight(_ value: CGFloat) -> AttributesItem {
            paragraphStyle.minimumLineHeight = value
            attributes[.paragraphStyle] = paragraphStyle
            return self
        }

        /// 最大行高
        @discardableResult
        func maximumLineHeight(_ value: CGFloat) -> AttributesItem {
            paragraphStyle.maximumLineHeight = value
            attributes[.paragraphStyle] = paragraphStyle
            return self
        }

        /// 段落间距
        @discardableResult
        func paragraphSpacing(_ value: CGFloat) -> AttributesItem {
            paragraphStyle.paragraphSpacing = value
            attributes[.paragraphStyle] = paragraphStyle
            return self
        }

        /// 首行缩进
        @discardableResult
        func firstLineHeadIndent(_ value: CGFloat) -> AttributesItem {
            paragraphStyle.firstLineHeadIndent = value
            attributes[.paragraphStyle] = paragraphStyle
            return self
        }
    }
}

extension NSAttributedString {
    /// 计算行数
    func calculateLines(_ width: CGFloat) -> Int {
        lines(width).count
    }

    /// 根据字体和每一行宽度切割字符串
    func separatedLines(_ width: CGFloat) -> [NSAttributedString] {
        let lines = lines(width)
        var linesArray = [NSAttributedString]()
        for line in lines {
            let lineRange: CFRange = CTLineGetStringRange(line)
            let range = NSRange(location: lineRange.location, length: lineRange.length)
            linesArray.append(attributedSubstring(from: range))
        }
        return linesArray
    }

    /// ctLines array
    func lines(_ width: CGFloat) -> [CTLine] {
        let framesetter = CTFramesetterCreateWithAttributedString(self)
        let path = CGMutablePath(rect: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude), transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        return CTFrameGetLines(frame) as? [CTLine] ?? []
    }
}
