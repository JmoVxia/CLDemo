//
//  NSString+CLCalculateSize.m
//  CLDemo
//
//  Created by JmoVxia on 2016/12/16.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "NSString+CLCalculateSize.h"

@implementation NSString (CLCalculateSize)

/**
 根据文字计算宽高
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize textSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return textSize;
}


@end
