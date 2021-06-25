//
//  CLChartMaskView.m
//  demo
//
//  Created by JmoVxia on 2017/3/9.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLChartMaskView.h"
#import "CLChartXLabel.h"
#import "Tools.h"
#import "DateTools.h"
#import "UIFont+CLFont.h"
#import "UIView+CLSetRect.h"

//点距离上边最近间距
#define TopSpace  (self.isFullScreen ? (40 + YPointSpace) : (15))
//点距离下边最近间距
#define BottomSpace 50
//点距离左边最近间距
#define LeftSpace  50
//点距离右边最近间距
#define RightSpace 25
//点距离Y轴刻度起点最近间距
#define YPointSpace  15
//点距离X轴刻度起点最近间距
#define XPointSpace  15
//点的大小
#define PointWidthHeight   12

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
        _shapeLayer.lineWidth = 1;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeColor = [UIColor redColor].CGColor;
    }
    return _shapeLayer;
}
- (CABasicAnimation *) pathAnimation{
    if (_pathAnimation == nil){
        _pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _pathAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:1 :1 :1 :1] ;
        _pathAnimation.duration = 0.8;
        _pathAnimation.fromValue = @0 ;
        _pathAnimation.toValue = @1 ;
        _pathAnimation.autoreverses = NO ;
    }
    return _pathAnimation;
}



-(void)setDic:(NSDictionary *)dic{
    
    _dic = dic;
    
    self.backgroundColor = [UIColor whiteColor];
    NSMutableArray *timeArray = [NSMutableArray arrayWithArray:dic[@"data"]];
    
    self.dataArray = [NSMutableArray arrayWithArray:dic[@"data"]];
    
    //数据按照日期排序
    [timeArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [[Tools sharedTools] stringToDate:obj1[@"date"] withDateFormat:@"yyyy-MM-dd"];
        NSDate *date2 = [[Tools sharedTools] stringToDate:obj2[@"date"] withDateFormat:@"yyyy-MM-dd"];
        if ([Tools compareOneDay:date1 withAnotherDay:date2] == 1) {
            return YES;
        }else{
            return NO;
        }
    }];
    
    //最大日期为今天
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *maxDateString = [dateFormatter stringFromDate:[NSDate date]];
    //最大日期
    NSDate *maxDate = [[Tools sharedTools] stringToDate:maxDateString withDateFormat:@"yyyy-MM-dd"];
    
    //日期
    NSDate *date;
    
    switch (self.dayType) {
        case Week:
            date = [[NSDate date] dateBySubtractingWeeks:1];
            break;
            
        case OneMonth:
            date = [[NSDate date] dateBySubtractingMonths:1];
            break;
            
        case ThreeMonth:
            date = [[NSDate date] dateBySubtractingMonths:3];
            break;
        case SixMonth:
            date = [[NSDate date] dateBySubtractingMonths:6];
            break;
        case Year:
            date = [[NSDate date] dateBySubtractingYears:1];
            break;
    }
    NSString *minDateString = [dateFormatter stringFromDate:[date dateByAddingDays:1]];
    //最小时间
    NSDate *minDate = [[Tools sharedTools] stringToDate:minDateString withDateFormat:@"yyyy-MM-dd"];
    //间隔天数
    NSInteger allDays = [maxDate daysFrom:minDate];
    
    //数据排序
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
    //间隔大小
    CGFloat value = maxValue - minValue;
    
    //删除子控件
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //贝塞尔曲线
    self.path = [UIBezierPath bezierPath];
    //根据排好顺序的时间创建点
    [timeArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //当前时间
        NSDate *nowDate = [[Tools sharedTools] stringToDate:obj[@"date"] withDateFormat:@"yyyy-MM-dd"];
        //当前时间到最小时间间距
        NSInteger days = [nowDate daysFrom:minDate];
        //当前数据
        CGFloat nowValue = [obj[@"FPG"] floatValue];
        
        //X坐标
        CGFloat x = ((CGFloat)(days) / (CGFloat)allDays) * (self.frame.size.width - LeftSpace - RightSpace);
        //Y坐标
        CGFloat y = ((CGFloat)(value - (nowValue - minValue)) / (CGFloat)value) * (self.frame.size.height - TopSpace - BottomSpace);
        //添加贝塞尔曲线路径
        if (idx == 0) {
            //起点
            [self.path moveToPoint:CGPointMake(x + LeftSpace, y + TopSpace)];
        }else{
            //添加其他点
            [self.path addLineToPoint:CGPointMake(x + LeftSpace, y + TopSpace)];
        }
        //创建点label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x - PointWidthHeight * 0.5 + LeftSpace ,y - PointWidthHeight * 0.5 + TopSpace ,PointWidthHeight,PointWidthHeight)];
        label.layer.cornerRadius = PointWidthHeight * 0.5;
        label.clipsToBounds = YES;
        label.layer.borderWidth = 1;
        label.backgroundColor = [UIColor whiteColor];
        label.layer.borderColor = [UIColor redColor].CGColor;
        [self addSubview:label];

    }];
    
    //添加动画
    [self.layer insertSublayer:self.shapeLayer atIndex:0];
    self.shapeLayer.path = self.path.CGPath;
    [self.shapeLayer addAnimation:self.pathAnimation forKey:nil];
    
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
        label.font = [UIFont clFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    //X轴刻度数量
    NSInteger xCount = 7;
    switch (self.dayType) {
        case Week:
            xCount = 7;
            break;
            
        case OneMonth:
            xCount = 4;
            break;
            
        case ThreeMonth:
            xCount = 3;
            break;
        case SixMonth:
            xCount = 6;
            break;
        case Year:
            xCount = 12;
            break;
    }
    
    
    //X轴刻度和数字label
    for (NSInteger i = 0; i < xCount; i++) {
        //开始绘制
        CGContextBeginPath(context);
        //画笔移动到点(31,170)
        CGContextMoveToPoint(context,i * (self.frame.size.width - LeftSpace - RightSpace)/(xCount - 1) + LeftSpace, self.cl_height - BottomSpace + 5 + XPointSpace - 5);
        //下一点
        CGContextAddLineToPoint(context,i * (self.frame.size.width - LeftSpace - RightSpace)/(xCount - 1) + LeftSpace, self.cl_height - BottomSpace + 5 + XPointSpace);
        //绘制完成
        CGContextStrokePath(context);
        
        //数字label
        CGFloat x = i * (self.frame.size.width - LeftSpace - RightSpace)/(xCount - 1) + LeftSpace;
        CGFloat width = (self.frame.size.width - LeftSpace - RightSpace)/(xCount - 1) - 1;
        CLChartXLabel *chartXLabel = [[CLChartXLabel alloc] initWithFrame:CGRectMake(x - width * 0.5, self.cl_height - (BottomSpace - 5 - XPointSpace), width, BottomSpace - 5 - XPointSpace)];
        [self addSubview:chartXLabel];
        if (i == xCount - 1) {
            //最后一个
            chartXLabel.round = YES;
        }
        //填充文字
        switch (self.dayType) {
            case Week:
            {
                NSDate *date = [[NSDate date] dateBySubtractingDays:(xCount - i - 1)];
                NSInteger day = [date day];
                chartXLabel.label.text = [NSString stringWithFormat:@"%ld",(long)day];
            }
                break;
                
            case OneMonth:
            {
                NSDate *date = [[NSDate date] dateBySubtractingWeeks:(xCount - i - 1)];
                NSInteger day = [date day];
                chartXLabel.label.text = [NSString stringWithFormat:@"%ld",(long)day];
            }
                break;
                
            case ThreeMonth:
            {
                NSDate *date = [[NSDate date] dateBySubtractingMonths:(xCount - i - 1)];
                NSInteger month = [date month];
                chartXLabel.label.text = [NSString stringWithFormat:@"%ld月",(long)month];
            }
                break;
            case SixMonth:
            {
                NSDate *date = [[NSDate date] dateBySubtractingMonths:(xCount - i - 1)];
                NSInteger month = [date month];
                chartXLabel.label.text = [NSString stringWithFormat:@"%ld月",(long)month];
            }
                break;
            case Year:
            {
                NSDate *date = [[NSDate date] dateBySubtractingMonths:(xCount - i - 1)];
                NSInteger month = [date month];
                chartXLabel.label.text = [NSString stringWithFormat:@"%ld月",(long)month];
            }
                break;
        }
}
    //Y轴竖线
//    CGContextSetLineWidth(context,1);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,LeftSpace - 5 - YPointSpace, _isFullScreen ? (20) : (0));
    CGContextAddLineToPoint(context,LeftSpace - 5 - YPointSpace, self.cl_height - BottomSpace + 5 + XPointSpace);
    CGContextStrokePath(context);
    CGContextBeginPath(context);
    //X轴竖线
    CGContextMoveToPoint(context,LeftSpace - 5 - YPointSpace, self.cl_height - BottomSpace + 5 + XPointSpace);
    CGContextAddLineToPoint(context,self.cl_width, self.cl_height - BottomSpace + 5 + XPointSpace);
    CGContextStrokePath(context);

    
}























@end
