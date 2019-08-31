//
//  CLLineChartView.m
//  CLDemo
//
//  Created by AUG on 2019/9/3.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLLineChartView.h"



@interface CLLineChartView ()

///动画labyer
@property (nonatomic, strong) CAShapeLayer *animtionLayer;

///数据源
@property (nonatomic, strong) NSArray<CLLineChartPoint *> *pointArray;
///x最小
@property (nonatomic, assign) CGFloat xMin;
///x最大
@property (nonatomic, assign) CGFloat xMax;
///y最小
@property (nonatomic, assign) CGFloat yMin;
///y最大
@property (nonatomic, assign) CGFloat yMax;
///宽
@property (nonatomic, assign) CGFloat width;
///高
@property (nonatomic, assign) CGFloat height;

@end

@implementation CLLineChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.animtionLayer = [CAShapeLayer layer];
        self.animtionLayer.lineWidth = 1;
        self.animtionLayer.fillColor = [UIColor clearColor].CGColor;
        self.animtionLayer.strokeColor = [UIColor redColor].CGColor;
        [self.layer addSublayer:self.animtionLayer];
    }
    return self;
}
- (void)reload {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(lineChartViewPoints)]) {
        self.pointArray = [self.dataSource lineChartViewPoints];
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(lineChartViewXLineMin)]) {
        self.xMin = [self.dataSource lineChartViewXLineMin];
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(lineChartViewXLineMax)]) {
        self.xMax = [self.dataSource lineChartViewXLineMax];
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(lineChartViewYLineMin)]) {
        self.yMin = [self.dataSource lineChartViewYLineMin];
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(lineChartViewYLineMax)]) {
        self.yMax = [self.dataSource lineChartViewYLineMax];
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(lineChartViewWidth)]) {
        self.width = [self.dataSource lineChartViewWidth];
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(lineChartViewHeight)]) {
        self.height = [self.dataSource lineChartViewHeight];
    }
    
    CGFloat xSpace = self.xMax - self.xMin;
    CGFloat ySpace = self.yMax - self.yMin;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < self.pointArray.count; i++) {
        CLLineChartPoint *point = [self.pointArray objectAtIndex:i];
        CGFloat x = point.x * self.width / xSpace;
        CGFloat y = point.y * self.height / ySpace;
        if (i == 0) {
            [path moveToPoint:CGPointMake(x, y)];
        }else {
            [path addLineToPoint:CGPointMake(x, y)];
        }
    }
    self.animtionLayer.path = path.CGPath;
}


@end
