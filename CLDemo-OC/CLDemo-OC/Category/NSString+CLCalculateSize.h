//
//  NSString+CLCalculateSize.h
//  CLDemo
//
//  Created by JmoVxia on 2016/12/16.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (CLCalculateSize)
/**
 *  计算文本占用的宽高
 *
 *  @param font    显示的字体
 *  @param maxSize 最大的显示范围
 *
 *  @return 占用的宽高
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;


/**
 使用核心文本计算字符串高度

 @param font 字体
 @param maxWidth 最大宽度
 @param maxLines 最大行数
 @return 高度
 */
- (int)calculateHeightWithFont:(UIFont*)font maxWidth:(CGFloat) maxWidth maxLines:(NSInteger)maxLines;

@end
