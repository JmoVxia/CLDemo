//
//  UIFont+CLFont.h
//  CLDemo
//
//  Created by AUG on 2018/11/12.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (CLFont)

/**
 自定义字体，会跟随设置变化
 @param fontSize 字体大小
 */
+ (UIFont *)clFontOfSize:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
