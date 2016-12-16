//
//  NSString+CLCalculateSize.h
//  CLDemo
//
//  Created by JmoVxia on 2016/12/16.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@end
