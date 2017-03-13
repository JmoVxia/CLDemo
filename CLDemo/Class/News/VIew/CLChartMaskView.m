//
//  CLChartMaskView.m
//  demo
//
//  Created by JmoVxia on 2017/3/9.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLChartMaskView.h"
#import "Tools.h"

//Y轴上边间隙
#define YTopSpace  15
//Y轴下边间距
#define YbottomSpace 45
//Y轴左边间距
#define YLeftSpace  45
//X轴右边间距
#define XRightSpace 90


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



-(void)setDic:(NSDictionary *)dic{
    
    _dic = dic;
    
    self.pointArray = [NSMutableArray array];
    
    self.backgroundColor = [UIColor lightGrayColor];
    NSMutableArray *timeArray = [NSMutableArray arrayWithArray:dic[@"data"]];
    
//    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:dic[@"data"]];
    
    
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
    
    
//    [dataArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        CGFloat value1 = [obj1[@"FPG"] floatValue];
//        CGFloat value2 = [obj2[@"FPG"] floatValue];
//        if (value1 < value2) {
//            return YES;
//        }else{
//            return NO;
//        }
//    }];
//    NSDictionary *maxValueDic = [dataArray firstObject];
//    NSDictionary *minValueDic = [dataArray lastObject];
    CGFloat maxValue = [_dic[@"ymax"] floatValue];
    CGFloat minValue = [_dic[@"ymin"] floatValue];
    
    CGFloat value = maxValue - minValue;
    
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.path = [UIBezierPath bezierPath];
    
    [timeArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDate *newDate = [[Tools sharedTools] stringToDate:obj[@"date"] withDateFormat:@"yyyy-MM-dd"];
        NSInteger days = [Tools getDaysFrom:minDate To:newDate];
        
        CGFloat newValue = [obj[@"FPG"] floatValue];
        
        
        CGFloat x = ((CGFloat)days / (CGFloat)allDays) * (self.frame.size.width - YLeftSpace - XRightSpace);
        
        CGFloat y = ((CGFloat)(value - (newValue - minValue)) / (CGFloat)value) * (self.frame.size.height - YTopSpace - YbottomSpace);
        
        NSValue *point = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [self.pointArray addObject:point];
        
        
        if (idx == 0) {
            [self.path moveToPoint:CGPointMake(x + YLeftSpace, y + YTopSpace)];
        }else{
            [self.path addLineToPoint:CGPointMake(x + YLeftSpace, y + YTopSpace)];
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x - 5 + YLeftSpace ,y - 5 + YTopSpace ,10,10)];
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
    

    //Y轴刻度
    for (NSInteger i = 0; i < 10; i++) {
        //开始绘制
        CGContextBeginPath(context);
        //画笔移动到点(31,170)
        CGContextMoveToPoint(context,YLeftSpace - 5 - 15, i * (self.frame.size.height - YTopSpace - YbottomSpace)/9.0 + YTopSpace);
        //下一点
        CGContextAddLineToPoint(context,YLeftSpace - 15, i * (self.frame.size.height - YTopSpace - YbottomSpace)/9.0 + YTopSpace);
        //绘制完成
        CGContextStrokePath(context);
  
    }
    //Y轴数字label
    CGFloat maxValue = [_dic[@"ymax"] floatValue];
    CGFloat minValue = [_dic[@"ymin"] floatValue];
    CGFloat value = maxValue - minValue;
    for (NSInteger i = 0; i < 10; i++) {
        
        CGFloat y = i * (self.frame.size.height - YTopSpace - YbottomSpace)/9.0 + YTopSpace;
        CGFloat height = (self.frame.size.height - YTopSpace - YbottomSpace)/9.0 - 1;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0 ,y - height * 0.5,YLeftSpace - 5 - 15,height)];
        NSInteger num = (NSInteger)((value/9) * (9 - i) + minValue);
        label.text = [NSString stringWithFormat:@"%ld",(long)num];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    
    //X轴刻度
    for (NSInteger i = 0; i < 7; i++) {
        //开始绘制
        CGContextBeginPath(context);
        //画笔移动到点(31,170)
        CGContextMoveToPoint(context,i * (self.frame.size.width - YLeftSpace - XRightSpace)/6.0 + YLeftSpace, self.CLheight - YbottomSpace + 5 + 15 - 5);
        //下一点
        CGContextAddLineToPoint(context,i * (self.frame.size.width - YLeftSpace - XRightSpace)/6.0 + YLeftSpace, self.CLheight - YbottomSpace + 5 + 15);
        //绘制完成
        CGContextStrokePath(context);
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Y轴竖线
    CGContextSetLineWidth(context,1.5);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,YLeftSpace - 5 - 15, 0);
    CGContextAddLineToPoint(context,YLeftSpace - 5 - 15, self.CLheight - YbottomSpace + 5 + 15);
    CGContextStrokePath(context);
    CGContextBeginPath(context);
    //X轴竖线
    CGContextMoveToPoint(context,YLeftSpace - 5 - 15, self.CLheight - YbottomSpace + 5 + 15);
    CGContextAddLineToPoint(context,self.CLwidth, self.CLheight - YbottomSpace + 5 + 15);
    CGContextStrokePath(context);

    
}























@end
