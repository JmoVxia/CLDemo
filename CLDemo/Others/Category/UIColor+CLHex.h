//
//  UIColor+CLHex.h
//  CLDemo
//
//  Created by AUG on 2019/1/15.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (CLHex)

+ (UIColor *)colorWithHex:(NSString *)hex;

+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha;

+ (UIColor *)colorWithRGBHex:(UInt32)hex;

@end

NS_ASSUME_NONNULL_END
