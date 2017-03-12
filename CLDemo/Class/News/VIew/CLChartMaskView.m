//
//  CLChartMaskView.m
//  demo
//
//  Created by JmoVxia on 2017/3/9.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLChartMaskView.h"
#import "Tools.h"

//Y轴上下间隙
#define YSpace  15
//X轴左右间距
#define XSpace  15



@interface CLChartMaskView ()

/**layer*/
@property (nonatomic,strong) CAShapeLayer *shapeLayer;

/**pathAnimation*/
@property (nonatomic,strong) CABasicAnimation *pathAnimation;

/**path*/
@property (nonatomic,strong) UIBezierPath*path;

/**点数组*/
@property (nonatomic,strong) NSMutableArray<NSValue*> *pointArray;

@end


@implementation CLChartMaskView

- (CAShapeLayer *) shapeLayer{
    if (_shapeLayer == nil){
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.lineWidth = 2;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeColor = [UIColor redColor].CGColor;
    }
    return _shapeLayer;
}
- (CABasicAnimation *) pathAnimation{
    if (_pathAnimation == nil){
        _pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _pathAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:1 :1 :1 :1] ;
        _pathAnimation.fromValue = @0 ;
        _pathAnimation.toValue = @1 ;
        _pathAnimation.autoreverses = NO ;
    }
    return _pathAnimation;
}



-(void)setArray:(NSArray *)array{
    
    _array = array;
    
    self.pointArray = [NSMutableArray array];
    
    self.backgroundColor = [UIColor lightGrayColor];
    NSMutableArray *timeArray = [NSMutableArray arrayWithArray:array];
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:array];
    
    
    [timeArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [[Tools sharedTools] stringToDate:obj1[@"date"] withDateFormat:@"yyyy-MM-dd"];
        NSDate *date2 = [[Tools sharedTools] stringToDate:obj2[@"date"] withDateFormat:@"yyyy-MM-dd"];
        if ([Tools compareOneDay:date1 withAnotherDay:date2] == 1) {
            return YES;
        }else{
            return NO;
        }
    }];
    
    
    NSDictionary *maxDateDic = [timeArray lastObject];
    NSDictionary *minDateDic = [timeArray firstObject];
    NSDate *maxDate = [[Tools sharedTools] stringToDate:maxDateDic[@"date"] withDateFormat:@"yyyy-MM-dd"];
    NSDate *minDate = [[Tools sharedTools] stringToDate:minDateDic[@"date"] withDateFormat:@"yyyy-MM-dd"];
    NSInteger allDays = [Tools getDaysFrom:minDate To:maxDate];
    
    
    [dataArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CGFloat value1 = [obj1[@"FPG"] floatValue];
        CGFloat value2 = [obj2[@"FPG"] floatValue];
        if (value1 < value2) {
            return YES;
        }else{
            return NO;
        }
    }];
    NSDictionary *maxValueDic = [dataArray firstObject];
    NSDictionary *minValueDic = [dataArray lastObject];
    CGFloat maxValue = [maxValueDic[@"FPG"] floatValue];
    CGFloat minValue = [minValueDic[@"FPG"] floatValue];
    
    CGFloat value = maxValue - minValue;
    
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.path = [UIBezierPath bezierPath];
    
    [timeArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDate *newDate = [[Tools sharedTools] stringToDate:obj[@"date"] withDateFormat:@"yyyy-MM-dd"];
        NSInteger days = [Tools getDaysFrom:minDate To:newDate];
        
        CGFloat newValue = [obj[@"FPG"] floatValue];
        
        
        CGFloat x = ((CGFloat)days / (CGFloat)allDays) * (self.frame.size.width - XSpace * 2);
        
        CGFloat y = ((CGFloat)(value - (newValue - minValue)) / (CGFloat)value) * (self.frame.size.height - YSpace * 2);
        
        NSValue *point = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [self.pointArray addObject:point];
        
        
        if (idx == 0) {
            [self.path moveToPoint:CGPointMake(x + XSpace, y + YSpace)];
        }else{
            [self.path addLineToPoint:CGPointMake(x + XSpace, y + YSpace)];
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x - 5 + XSpace ,y - 5 + YSpace ,10,10)];
        label.layer.cornerRadius = 5;
        label.clipsToBounds = YES;
        label.backgroundColor = [UIColor orangeColor];
        [self addSubview:label];

    }];
    
    
    [self.layer insertSublayer:self.shapeLayer atIndex:0];
    self.pathAnimation.duration = 3 ;
    self.shapeLayer.path = self.path.CGPath;
    [self.shapeLayer addAnimation:_pathAnimation forKey:nil];
    

    
}
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
 
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //指定直线样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context,1.0);
    //设置颜色
    [[UIColor blackColor] set];
    

    
    [self.pointArray enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [obj CGPointValue];
        //开始绘制
        CGContextBeginPath(context);
        //画笔移动到点(31,170)
        CGContextMoveToPoint(context,0, point.y + YSpace);
        //下一点
        CGContextAddLineToPoint(context,5, point.y + YSpace);
        //绘制完成
        CGContextStrokePath(context);
    }];
    
    CGContextSetLineWidth(context,1.5);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,1, 0);
    CGContextAddLineToPoint(context,1, self.CLheight);
    CGContextStrokePath(context);

    
}























@end
