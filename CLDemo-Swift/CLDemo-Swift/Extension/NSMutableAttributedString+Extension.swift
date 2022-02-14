//
//  NSMutableAttributedString+Extension.swift
//  CKD
//
//  Created by Chen JmoVxia on 2021/3/26.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import Foundation


extension NSMutableAttributedString {
    /// 添加字符串并为此段添加对应的Attribute
    @discardableResult
    func addText(_ text: String, attributes: ((_ item: AttributesItem) -> Void)? = nil) -> NSMutableAttributedString {
        let item = AttributesItem()
        attributes?(item)
        append(NSMutableAttributedString(string: text, attributes: item.attributes))
        return self
    }

    /// 添加Attribute作用于当前字符串
    @discardableResult
    func addAttributes(_ attributes: (_ item: AttributesItem) -> Void, rang: NSRange? = nil, replace: Bool = false) -> NSMutableAttributedString {
        let item = AttributesItem()
        attributes(item)
        enumerateAttributes(in: rang ?? NSRange(string.startIndex ..< string.endIndex, in: string), options: .reverse) { oldAttribute, oldRange, _ in
            var newAtt = oldAttribute
            for attribute in item.attributes where replace ? true : !oldAttribute.keys.contains(attribute.key) {
                newAtt[attribute.key] = attribute.value
            }
            addAttributes(newAtt, range: oldRange)
        }
        return self
    }

    /// 添加图片
    @discardableResult
    func addImage(_ image: UIImage?, _ bounds: CGRect) -> NSMutableAttributedString {
        let attch = NSTextAttachment()
        attch.image = image
        attch.bounds = bounds
        append(NSAttributedString(attachment: attch))
        return self
    }
}

extension NSMutableAttributedString {
    /// 正则替换网页
    /// - Parameter attributes: 替换的属性
    /// - Returns: 替换结果，新的富文本
    func replaceLink(_ attributes: (_ item: AttributesItem) -> Void) -> (matchs: [Regex.Match], attributedString: NSMutableAttributedString) {
        var linkRanges = [Regex.Match]()
        let linkRegex = try! Regex("(([hH][tT]{2}[pP]://|[hH][tT]{2}[pP][sS]://|[wW][aA][pP].|[fF][tT][pP].|[fF][iI][lL][eE].)[-A-Za-z0-9+&@#/%?=~_|!:,.;']+[-A-Za-z0-9+&@#/%=~_|])|(https?:/{2})?((?!0)[0-9]{1,3}(\\.([0-9]{1,3})){3})|((https?:/{2})?(([-a-zA-Z_+~#=]{1,256}\\.)?(([a-zA-Z0-9]{1,63})\\.){1,3}([a-zA-Z]{1,8}))(:[0-9]{2,5})?([/?]([-a-zA-Z0-9@:%_+.~#?&/=]*))?)")
        linkRanges = linkRegex.matches(in: string)
        for match in linkRanges {
            addAttributes(attributes, rang: match.result.range, replace: true)
        }
        return (linkRanges, self)
    }

    /// 正则替换电话号码
    /// - Parameter attributes: 替换的属性
    /// - Returns: 替换结果，新的富文本
    func replacePhone(_ attributes: (_ item: AttributesItem) -> Void) -> (matchs: [Regex.Match], attributedString: NSMutableAttributedString) {
        var phoneRanges = [Regex.Match]()
        let phoneRegex = try! Regex("([+]?[(（]?[+]?(?<!\\d)(9[976]\\d|8[987530]\\d|6[987]\\d|5[90]\\d|42\\d|3[875]\\d|2[98654321]\\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)[)）—-]?\\d{5,14}(?!\\d))|((?<!\\d)([2-8]\\d{6,7})(?!\\d)|((?<!\\d)[(（]?010[)）—-]?\\d{7,8}(?!\\d))|((?<!\\d)[(（]?0[2-9]\\d{1,2}[)）—-]?\\d{7,8}(?!\\d)))")
        phoneRanges = phoneRegex.matches(in: string)
        for match in phoneRanges {
            addAttributes(attributes, rang: match.result.range, replace: true)
        }
        return (phoneRanges, self)
    }
}
