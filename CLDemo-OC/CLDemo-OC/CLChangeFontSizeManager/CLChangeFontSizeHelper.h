//
//  CLChangeFontSizeManager.h
//  CLDemo
//
//  Created by AUG on 2018/11/12.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLChangeFontSizeHelper : NSObject

/**
 设置字体大小系数，1到6  2为默认标准
 */
+ (void)setFontSizeCoefficient:(NSInteger )coefficient;

/**
 读取字体大小系数，1到6  2为默认标准
 */
+ (NSInteger )fontSizeCoefficient;

/**
 读取比例系数 (0.925~1.30)
 */
+ (float )scaleCoefficient;

@end

NS_ASSUME_NONNULL_END
