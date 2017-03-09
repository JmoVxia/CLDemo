//
//  CLChartMaskView.m
//  demo
//
//  Created by JmoVxia on 2017/3/9.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLChartMaskView.h"
#import "Tools.h"

@implementation CLChartMaskView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}






- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    
    
    NSMutableArray *array = self.dic[@"data"];
    
    NSMutableArray *timeArray = [NSMutableArray arrayWithArray:array];
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:array];
    
    
    [timeArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [[Tools sharedTools] stringToDate:obj1[@"date"] withDateFormat:@"yyyy-MM-dd"];
        NSDate *date2 = [[Tools sharedTools] stringToDate:obj2[@"date"] withDateFormat:@"yyyy-MM-dd"];
        if ([Tools compareOneDay:date1 withAnotherDay:date2] == -1) {
            return YES;
        }else{
            return NO;
        }
    }];
    
    
    NSDictionary *maxDateDic = [timeArray firstObject];
    NSDictionary *minDateDic = [timeArray lastObject];
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
    
    CGContextRef ctx =UIGraphicsGetCurrentContext();
    
    [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDate *newDate = [[Tools sharedTools] stringToDate:obj[@"date"] withDateFormat:@"yyyy-MM-dd"];
        NSInteger days = [Tools getDaysFrom:minDate To:newDate];
        
        CGFloat newValue = [obj[@"FPG"] floatValue];
        
        
        CGFloat x = ((CGFloat)days / (CGFloat)allDays) * (self.frame.size.width - 20);
        
        CGFloat y = ((CGFloat)(value - newValue) / (CGFloat)value) * (self.frame.size.height - 20);
        
        UIBezierPath*path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x - 5 + 10,y - 5 + 10,10,10)];
        CGContextAddPath(ctx,path.CGPath);
        CGContextDrawPath(ctx,kCGPathStroke);
    }];
}


@end
