//
//  CLHoneycombDelegate.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/8/16.
//

import Foundation

protocol CLHoneycombDelegate: UIScrollViewDelegate {
    func honeycombView(_ honeycombView: CLHoneycombView, shouldHightlightItemAtIndex index: Int) -> Bool
    
    func honeycombView(_ honeycombView: CLHoneycombView, didHighlightItemAtIndex index: Int)
    
    func honeycombView(_ honeycombView: CLHoneycombView, didUnhighlightItemAtIndex index: Int)
    
    func honeycombView(_ honeycombView: CLHoneycombView, shouldSelectItemAtIndex index: Int) -> Bool
    
    func honeycombView(_ honeycombView: CLHoneycombView, shouldDeselectItemAtIndex index: Int) -> Bool
    
    func honeycombView(_ honeycombView: CLHoneycombView, didSelectItemAtIndex index: Int)
    
    func honeycombView(_ honeycombView: CLHoneycombView, didDeselectItemAtIndex index: Int)
    
    func honeycombView(_ honeycombView: CLHoneycombView, willDisplayCell cell: CLHoneycombCell, forIndex index: Int)
    
    func honeycombView(_ honeycombView: CLHoneycombView, didEndDisplayingCell cell: CLHoneycombCell, forIndex index: Int)
}
extension CLHoneycombDelegate {
    func honeycombView(_ honeycombView: CLHoneycombView, shouldHightlightItemAtIndex index: Int) -> Bool {
        return true
    }
    
    func honeycombView(_ honeycombView: CLHoneycombView, didHighlightItemAtIndex index: Int) {
        
    }
    
    func honeycombView(_ honeycombView: CLHoneycombView, didUnhighlightItemAtIndex index: Int) {
        
    }
    
    func honeycombView(_ honeycombView: CLHoneycombView, shouldSelectItemAtIndex index: Int) -> Bool {
        return true
    }
    
    func honeycombView(_ honeycombView: CLHoneycombView, shouldDeselectItemAtIndex index: Int) -> Bool {
        return true
    }
    
    func honeycombView(_ honeycombView: CLHoneycombView, didSelectItemAtIndex index: Int) {
        
    }
    
    func honeycombView(_ honeycombView: CLHoneycombView, didDeselectItemAtIndex index: Int) {
        
    }
    
    func honeycombView(_ honeycombView: CLHoneycombView, willDisplayCell cell: CLHoneycombCell, forIndex index: Int) {
        
    }
    
    func honeycombView(_ honeycombView: CLHoneycombView, didEndDisplayingCell cell: CLHoneycombCell, forIndex index: Int) {
        
    }
}
