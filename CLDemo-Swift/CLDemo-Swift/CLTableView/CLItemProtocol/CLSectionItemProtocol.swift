//
//  CLSectionItemProtocol.swift
//  CKDDoctor
//
//  Created by Chen JmoVxia on 2022/6/15.
//

import Foundation

protocol CLSectionItemProtocol {
    var rows: [CLRowItemProtocol] { get set }

    var willDisplayHeaderViewCallback: ((Int) -> Void)? { get set }
    var didEndDisplayingHeaderViewCallback: ((Int) -> Void)? { get set }
    var viewForHeaderInSectionCallback: ((Int) -> Void)? { get set }
    var didSelectHeaderViewCallback: ((Int) -> Void)? { get set }
    func headerHeight() -> CGFloat
    func headerClass() -> UITableViewHeaderFooterView.Type?

    var willDisplayFooterViewCallback: ((Int) -> Void)? { get set }
    var didEndDisplayingFooterViewCallback: ((Int) -> Void)? { get set }
    var viewForFooterInSectionCallback: ((Int) -> Void)? { get set }
    var didSelectFooterViewCallback: ((Int) -> Void)? { get set }
    func footerHeight() -> CGFloat
    func footerClass() -> UITableViewHeaderFooterView.Type?
}

extension CLSectionItemProtocol {
    var willDisplayHeaderViewCallback: ((Int) -> Void)? {
        get {
            nil
        }
        set {}
    }

    var didEndDisplayingHeaderViewCallback: ((Int) -> Void)? {
        get {
            nil
        }
        set {}
    }

    var viewForHeaderInSectionCallback: ((Int) -> Void)? {
        get {
            nil
        }
        set {}
    }

    var didSelectHeaderViewCallback: ((Int) -> Void)? {
        get {
            nil
        }
        set {}
    }

    func headerHeight() -> CGFloat {
        UITableView.automaticDimension
    }

    func headerClass() -> UITableViewHeaderFooterView.Type? {
        nil
    }

    var willDisplayFooterViewCallback: ((Int) -> Void)? {
        get {
            nil
        }
        set {}
    }

    var didEndDisplayingFooterViewCallback: ((Int) -> Void)? {
        get {
            nil
        }
        set {}
    }

    var viewForFooterInSectionCallback: ((Int) -> Void)? {
        get {
            nil
        }
        set {}
    }

    var didSelectFooterViewCallback: ((Int) -> Void)? {
        get {
            nil
        }
        set {}
    }

    func footerHeight() -> CGFloat {
        UITableView.automaticDimension
    }

    func footerClass() -> UITableViewHeaderFooterView.Type? {
        nil
    }
}

extension CLSectionItemProtocol {
    var rows: [CLRowItemProtocol] {
        get {
            []
        }
        set {}
    }
}
