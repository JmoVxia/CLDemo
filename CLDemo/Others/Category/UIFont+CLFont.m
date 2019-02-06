//
//  UIFont+CLFont.m
//  CLDemo
//
//  Created by AUG on 2018/11/12.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import "UIFont+CLFont.h"
#import "CLChangeFontSizeManager.h"

@implementation UIFont (CLFont)

+ (UIFont *)clFontOfSize:(CGFloat)fontSize {
    NSInteger coefficient = [CLChangeFontSizeManager fontSizeCoefficient];
    float x = 0.075 * (coefficient - 2) + 1; //改变系数x 为0.925 --1.30
    return  [UIFont systemFontOfSize:fontSize * x];
}

@end
