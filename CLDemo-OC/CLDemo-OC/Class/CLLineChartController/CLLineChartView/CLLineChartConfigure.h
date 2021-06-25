//
//  CLLineChartConfigure.h
//  CLDemo
//
//  Created by AUG on 2019/11/15.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLLineChartConfigure : NSObject

///线条宽度
@property (nonatomic, assign) CGFloat lineWidth;
///线条颜色
@property (nonatomic, strong) UIColor *lineColor;
///虚线条宽度
@property (nonatomic, assign) CGFloat dottedLineWidth;
///虚线条颜色
@property (nonatomic, strong) UIColor *dottedLineColor;
///渐变颜色数组
@property (nonatomic, strong) NSArray *gradientColors;

@end

NS_ASSUME_NONNULL_END
