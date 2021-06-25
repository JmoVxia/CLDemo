//
//  CLLineChartController.m
//  CLDemo
//
//  Created by AUG on 2019/9/3.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLLineChartController.h"
#import "CLLineChartView.h"
#import <Masonry/Masonry.h>

@interface CLLineChartController ()<CLLineChartViewDataSource>

///折线图
@property (nonatomic, strong) CLLineChartView *chart;
///数据源
@property (nonatomic, strong) NSMutableArray<CLLineChartPoint *> *arrayDS;

@end

@implementation CLLineChartController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chart = [[CLLineChartView alloc] init];
    self.chart.dataSource = self;
    [self.view addSubview:self.chart];
    [self.chart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(200);
    }];
    
    self.arrayDS = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 24; i++) {
        CLLineChartPoint *point = [CLLineChartPoint new];
        point.x = i + 0.5;
        point.y = [self randomBetween:7000 AndBigNum:8000 AndPrecision:100];
        [self.arrayDS addObject:point];
    }
    [self.chart reload];
}
/**
 *   samllNum:  两数中的最小值
 *   bigNum: 两数中的最大值
 *   precision: 精度值，如：精确1位小数，precision参数值为10； 两位小数precision参数值为100；
 */
- (float)randomBetween:(float)smallNum AndBigNum:(float)bigNum AndPrecision:(NSInteger)precision{
    //求两数之间的差值
    float subtraction = bigNum - smallNum;
    //取绝对值
    subtraction = ABS(subtraction);
    //乘以精度的位数
    subtraction *= precision;
    //在差值间随机
    float randomNumber = arc4random() % ((int) subtraction + 1);
    //随机的结果除以精度的位数
    randomNumber /= precision;
    //将随机的值加到较小的值上
    float result = MIN(smallNum, bigNum) + randomNumber;
    //返回结果
    return result;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.arrayDS removeAllObjects];
    for (NSInteger i = 0; i < 24; i++) {
        CLLineChartPoint *point = [CLLineChartPoint new];
        point.x = i + 0.5;
        point.y = [self randomBetween:7000 AndBigNum:8000 AndPrecision:100];
        [self.arrayDS addObject:point];
    }
    [self.chart updateWithConfigure:^(CLLineChartConfigure * _Nonnull configure) {
        UIColor *color = [UIColor colorWithHue:(arc4random() % (256) / (256.0)) saturation:(arc4random() % (256) / (256.0)) brightness:(arc4random() % (256) / (256.0)) alpha:(1.0)];
        configure.lineWidth = 0.5;
        configure.lineColor = color;
        configure.gradientColors = @[(__bridge id)[color colorWithAlphaComponent:0.5].CGColor,(__bridge id)[color colorWithAlphaComponent:0.0].CGColor];
        configure.dottedLineColor = color;
        configure.dottedLineWidth = 0.5;
    }];
    [self.chart reload];
}
///点数据
- (NSArray<CLLineChartPoint *> *)lineChartViewPoints {
    return self.arrayDS;
}
///x最小
- (CGFloat)lineChartViewXLineMin {
    return 0;
}
///x最大
- (CGFloat)lineChartViewXLineMax {
    return 24;
}
///y最小
- (CGFloat)lineChartViewYLineMin {
    return 7000;
}
///y最大
- (CGFloat)lineChartViewYLineMax {
    return 8000;
}
///虚线位置
- (CGFloat)lineChartViewDottedLineY {
    return [self randomBetween:7000 AndBigNum:8000 AndPrecision:100];
}
///图表宽高
- (CGSize)lineChartViewChartSize {
    return CGSizeMake(250, 200);
}
- (void)dealloc
{
    
}
@end
