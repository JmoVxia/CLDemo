//
//  CLLineChartView.m
//  CLDemo
//
//  Created by AUG on 2019/9/3.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLLineChartView.h"

@interface CLLineChartView ()

///配置
@property (nonatomic, strong) CLLineChartConfigure *configure;

///折线layer
@property (nonatomic, strong) CAShapeLayer *lineLayer;
///渐变layer
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
///虚线
@property (nonatomic, strong) CAShapeLayer *dottedLine;
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
///虚线Y
@property (nonatomic, assign) CGFloat dottedLineY;
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
        [self.layer addSublayer: self.gradientLayer];
        [self.layer addSublayer:self.lineLayer];
        [self.layer addSublayer:self.dottedLine];
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
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(lineChartViewDottedLineY)]) {
        self.dottedLineY = [self.dataSource lineChartViewDottedLineY];
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(lineChartViewChartSize)]) {
        CGSize size = [self.dataSource lineChartViewChartSize];
        self.width = size.width;
        self.height = size.height;
    }
    
    CGFloat xSpace = self.xMax - self.xMin;
    CGFloat ySpace = self.yMax - self.yMin;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint fristPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    for (NSInteger i = 0; i < (NSInteger)self.pointArray.count; i++) {
        CLLineChartPoint *point = [self.pointArray objectAtIndex:i];
        CGFloat x = (point.x - self.xMin) * self.width / xSpace;
        CGFloat y = self.height - (point.y - self.yMin) * self.height / ySpace;
        if (i == 0) {
            fristPoint = CGPointMake(x, y);
            [path moveToPoint:CGPointMake(x, y)];
        }else {
            endPoint = CGPointMake(x, y);
            [path addLineToPoint:CGPointMake(x, y)];
        }
    }
    self.lineLayer.path = path.CGPath;
    self.lineLayer.frame = CGRectMake(0, 0, self.width, self.height);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithCGPath:path.CGPath];
    [maskPath addLineToPoint:CGPointMake(endPoint.x, self.height)];
    [maskPath addLineToPoint:CGPointMake(fristPoint.x, self.height)];
    [maskPath closePath];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskPath.CGPath;
    self.gradientLayer.mask = maskLayer;
    self.gradientLayer.frame = CGRectMake(0, 0, self.width, self.height);
    
    UIBezierPath *dottedLinePath = [UIBezierPath bezierPath];
    CGFloat dottedLineY = self.height - (self.dottedLineY - self.yMin) * self.height / ySpace;
    [dottedLinePath moveToPoint:CGPointMake(0, dottedLineY)];
    [dottedLinePath addLineToPoint:CGPointMake(self.width, dottedLineY)];
    self.dottedLine.path = dottedLinePath.CGPath;
    self.dottedLine.frame = CGRectMake(0, 0, self.width, self.height);
}
- (void)updateWithConfigure:(void(^)(CLLineChartConfigure *configure))configureBlock {
    if (configureBlock) {
        configureBlock(self.configure);
        _lineLayer.lineWidth = self.configure.lineWidth;
        _lineLayer.strokeColor = self.configure.lineColor.CGColor;
        _gradientLayer.colors = self.configure.gradientColors;
        _dottedLine.strokeColor = self.configure.dottedLineColor.CGColor;
        _dottedLine.lineWidth = self.configure.dottedLineWidth;
    }
    configureBlock = nil;
}
- (CLLineChartConfigure *) configure {
    if (_configure == nil) {
        UIColor *color = [UIColor redColor];
        _configure = [[CLLineChartConfigure alloc] init];
        _configure.lineWidth = 0.5;
        _configure.lineColor = color;
        _configure.gradientColors = @[(__bridge id)[color colorWithAlphaComponent:0.35].CGColor,(__bridge id)[color colorWithAlphaComponent:0.0].CGColor];
        _configure.dottedLineColor = color;
        _configure.dottedLineWidth = 0.5;
    }
    return _configure;
}
- (CAShapeLayer *) lineLayer {
    if (_lineLayer == nil) {
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.lineWidth = self.configure.lineWidth;
        _lineLayer.fillColor = [UIColor clearColor].CGColor;
        _lineLayer.strokeColor = self.configure.lineColor.CGColor;
    }
    return _lineLayer;
}
- (CAGradientLayer *) gradientLayer {
    if (_gradientLayer == nil) {
        _gradientLayer = [[CAGradientLayer alloc] init];
        _gradientLayer.colors = self.configure.gradientColors;
        _gradientLayer.startPoint = CGPointMake(0.5, 0.5);
        _gradientLayer.endPoint = CGPointMake(0.5, 1);
        _gradientLayer.locations = @[@0,@1.0];
    }
    return _gradientLayer;
}
- (CAShapeLayer *) dottedLine {
    if (_dottedLine == nil) {
        _dottedLine = [[CAShapeLayer alloc] init];
        _dottedLine.strokeColor = self.configure.dottedLineColor.CGColor;
        _dottedLine.fillColor = nil;
        _dottedLine.lineWidth = self.configure.dottedLineWidth;
        _dottedLine.lineCap = @"square";
        _dottedLine.lineDashPattern = @[@2, @4];
    }
    return _dottedLine;
}
@end
