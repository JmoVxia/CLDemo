//
//  CLChartMaskView.m
//  demo
//
//  Created by JmoVxia on 2017/3/9.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLChartMaskView.h"
#import "Tools.h"

//点距离上边最近间距
#define TopSpace  15
//点距离下边最近间距
#define BottomSpace 45
//点距离左边最近间距
#define LeftSpace  45
//点距离右边最近间距
#define RightSpace 15
//点距离Y轴刻度起点最近间距
#define YPointSpace  15
//点距离X轴刻度起点最近间距
#define XPointSpace  15


@interface CLChartMaskView ()

/**layer*/
@property (nonatomic,strong) CAShapeLayer *shapeLayer;

/**pathAnimation*/
@property (nonatomic,strong) CABasicAnimation *pathAnimation;

/**path*/
@property (nonatomic,strong) UIBezierPath*path;

/**点数组*/
@property (nonatomic,strong) NSMutableArray *dataArray;

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



-(void)setDic:(NSDictionary *)dic{
    
    _dic = dic;
    
    
    self.backgroundColor = [UIColor lightGrayColor];
    NSMutableArray *timeArray = [NSMutableArray arrayWithArray:dic[@"data"]];
    
    self.dataArray = [NSMutableArray arrayWithArray:dic[@"data"]];
    
    
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
    
    
    [self.dataArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CGFloat value1 = [obj1[@"FPG"] floatValue];
        CGFloat value2 = [obj2[@"FPG"] floatValue];
        if (value1 < value2) {
            return YES;
        }else{
            return NO;
        }
    }];
    NSDictionary *maxValueDic = [self.dataArray firstObject];
    NSDictionary *minValueDic = [self.dataArray lastObject];
    CGFloat maxValue = [maxValueDic[@"FPG"] floatValue];
    CGFloat minValue = [minValueDic[@"FPG"] floatValue];
    
    CGFloat value = maxValue - minValue;
    
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.path = [UIBezierPath bezierPath];
    
    [timeArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDate *newDate = [[Tools sharedTools] stringToDate:obj[@"date"] withDateFormat:@"yyyy-MM-dd"];
        NSInteger days = [Tools getDaysFrom:minDate To:newDate];
        
        CGFloat newValue = [obj[@"FPG"] floatValue];
        
        
        CGFloat x = ((CGFloat)days / (CGFloat)allDays) * (self.frame.size.width - LeftSpace - RightSpace);
        
        CGFloat y = ((CGFloat)(value - (newValue - minValue)) / (CGFloat)value) * (self.frame.size.height - TopSpace - BottomSpace);
        
        
        
        if (idx == 0) {
            [self.path moveToPoint:CGPointMake(x + LeftSpace, y + TopSpace)];
        }else{
            [self.path addLineToPoint:CGPointMake(x + LeftSpace, y + TopSpace)];
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x - 5 + LeftSpace ,y - 5 + TopSpace ,10,10)];
        label.layer.cornerRadius = 5;
        label.clipsToBounds = YES;
        label.backgroundColor = [UIColor orangeColor];
        [self addSubview:label];

    }];
    
    
    [self.layer insertSublayer:self.shapeLayer atIndex:0];
    self.pathAnimation.duration = 3 ;
    self.shapeLayer.path = self.path.CGPath;
    [self.shapeLayer addAnimation:_pathAnimation forKey:nil];
    
    [self setNeedsDisplay];
    
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
    
    //Y轴刻度和数字label
    NSDictionary *maxValueDic = [self.dataArray firstObject];
    NSDictionary *minValueDic = [self.dataArray lastObject];
    CGFloat maxValue = [maxValueDic[@"FPG"] floatValue];
    CGFloat minValue = [minValueDic[@"FPG"] floatValue];
    
    CGFloat value = maxValue - minValue;
    for (NSInteger i = 0; i < 10; i++) {
        //开始绘制
        CGContextBeginPath(context);
        //画笔移动到点(31,170)
        CGContextMoveToPoint(context,LeftSpace - 5 - YPointSpace, i * (self.frame.size.height - TopSpace - BottomSpace)/9.0 + TopSpace);
        //下一点
        CGContextAddLineToPoint(context,LeftSpace - YPointSpace, i * (self.frame.size.height - TopSpace - BottomSpace)/9.0 + TopSpace);
        //绘制完成
        CGContextStrokePath(context);
        
        //数字label
        CGFloat y = i * (self.frame.size.height - TopSpace - BottomSpace)/9.0 + TopSpace;
        CGFloat height = (self.frame.size.height - TopSpace - BottomSpace)/9.0 - 1;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0 ,y - height * 0.5,LeftSpace - 5 - YPointSpace,height)];
        NSInteger num = (NSInteger)((value/9) * (9 - i) + minValue);
        label.text = [NSString stringWithFormat:@"%ld",(long)num];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }

    //X轴刻度和数字label
    for (NSInteger i = 0; i < 7; i++) {
        //开始绘制
        CGContextBeginPath(context);
        //画笔移动到点(31,170)
        CGContextMoveToPoint(context,i * (self.frame.size.width - LeftSpace - RightSpace)/6.0 + LeftSpace, self.CLheight - BottomSpace + 5 + XPointSpace - 5);
        //下一点
        CGContextAddLineToPoint(context,i * (self.frame.size.width - LeftSpace - RightSpace)/6.0 + LeftSpace, self.CLheight - BottomSpace + 5 + XPointSpace);
        //绘制完成
        CGContextStrokePath(context);
        
        //数字label
        CGFloat x = i * (self.frame.size.width - LeftSpace - RightSpace)/6.0 + LeftSpace;
        CGFloat width = (self.frame.size.width - LeftSpace - RightSpace)/6.0 - 1;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x - width * 0.5, self.CLheight - (BottomSpace - 5 - XPointSpace), width, BottomSpace - 5 - XPointSpace)];
        NSInteger num = (NSInteger)((value/6) * (6 - i) + minValue);
        label.text = [NSString stringWithFormat:@"%ld",(long)num];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Y轴竖线
    CGContextSetLineWidth(context,1.5);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,LeftSpace - 5 - YPointSpace, 0);
    CGContextAddLineToPoint(context,LeftSpace - 5 - YPointSpace, self.CLheight - BottomSpace + 5 + XPointSpace);
    CGContextStrokePath(context);
    CGContextBeginPath(context);
    //X轴竖线
    CGContextMoveToPoint(context,LeftSpace - 5 - YPointSpace, self.CLheight - BottomSpace + 5 + XPointSpace);
    CGContextAddLineToPoint(context,self.CLwidth, self.CLheight - BottomSpace + 5 + XPointSpace);
    CGContextStrokePath(context);

    
}























@end
