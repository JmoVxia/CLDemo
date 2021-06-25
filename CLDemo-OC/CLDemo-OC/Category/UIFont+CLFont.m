//
//  UIFont+CLFont.m
//  CLDemo
//
//  Created by AUG on 2018/11/12.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import "UIFont+CLFont.h"
#import "CLChangeFontSizeHelper.h"

@implementation UIFont (CLFont)

+ (UIFont *)clFontOfSize:(CGFloat)fontSize {
    return  [UIFont systemFontOfSize:fontSize * [CLChangeFontSizeHelper scaleCoefficient]];
}

@end
