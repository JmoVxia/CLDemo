//
//  CLChatTextItem.swift
//  CLDemo
//
//  Created by Emma on 2020/1/27.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLChatTextItem: CLChatItem {
    var text: String = "" {
        didSet {
            height = nil
            attributedText = attributedString(with: text, lineSpacing: 2, paragraphSpacing: 0, alignment: .left, font: .mediumPingFangSC(15), color: isFromMyself ? .white : .black)
        }
    }

    var willDisplayCallback: ((IndexPath) -> Void)?
    var linkClickCallback: ((Int, NSAttributedString) -> Void)?
    private(set) var phoneRanges: [Regex.Match] = []
    private(set) var linkRanges: [Regex.Match] = []
    private(set) var attributedText: NSAttributedString = .init(string: "")
}

extension CLChatTextItem {
    private func attributedString(with text: String, lineSpacing: CGFloat, paragraphSpacing: CGFloat, alignment: NSTextAlignment, font: UIFont, color: UIColor) -> NSAttributedString {
        phoneRanges.removeAll()
        linkRanges.removeAll()

        let linkRegex = try! Regex("(([hH][tT]{2}[pP]://|[hH][tT]{2}[pP][sS]://|[wW][aA][pP].|[fF][tT][pP].|[fF][iI][lL][eE].)[-A-Za-z0-9+&@#/%?=~_|!:,.;']+[-A-Za-z0-9+&@#/%=~_|])|(https?:/{2})?((?!0)[0-9]{1,3}(\\.([0-9]{1,3})){3})|((https?:/{2})?(([-a-zA-Z_+~#=]{1,256}\\.)?(([a-zA-Z0-9]{1,63})\\.){1,3}([a-zA-Z]{1,8}))(:[0-9]{2,5})?([/?]([-a-zA-Z0-9@:%_+.~#?&/=]*))?)")
        linkRanges = linkRegex.matches(in: text)

        let phoneRegex = try! Regex("([+]?[(（]?[+]?(?<!\\d)(9[976]\\d|8[987530]\\d|6[987]\\d|5[90]\\d|42\\d|3[875]\\d|2[98654321]\\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)[)）—-]?\\d{5,14}(?!\\d))|((?<!\\d)([2-8]\\d{6,7})(?!\\d)|((?<!\\d)[(（]?010[)）—-]?\\d{7,8}(?!\\d))|((?<!\\d)[(（]?0[2-9]\\d{1,2}[)）—-]?\\d{7,8}(?!\\d)))")
        phoneRanges = phoneRegex.matches(in: text)

        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.paragraphSpacing = paragraphSpacing
        style.lineBreakMode = .byWordWrapping
        style.alignment = alignment
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([.paragraphStyle: style, .font: font, .foregroundColor: color], range: NSRange(location: 0, length: attributedString.length))

        for match in linkRanges + phoneRanges {
            attributedString.addAttributes([.foregroundColor: UIColor("#2658D9"), .underlineColor: UIColor("#2658D9"), .underlineStyle: NSNumber(value: NSUnderlineStyle.single.rawValue)], range: match.result.range)
        }
        return attributedString
    }
}

extension CLChatTextItem: CLRowItemProtocol {
    func cellClass() -> UITableViewCell.Type {
        return CLChatTextCell.self
    }

    func cellHeight() -> CGFloat {
        if let height = height {
            return height
        } else {
            let textHeight: CGFloat = CLCalculateHepler.height(with: attributedText, maxWidth: 200.autoWidth())
            height = (10 + textHeight + 20 + 5 + 5)
            return height!
        }
    }
}
