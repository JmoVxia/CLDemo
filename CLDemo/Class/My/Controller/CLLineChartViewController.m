//
//  CLLineChartViewController.m
//  CLDemo
//
//  Created by AUG on 2019/9/3.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLLineChartViewController.h"
#import "CLLineChartView.h"
#import <Masonry/Masonry.h>

@interface CLLineChartViewController ()<CLLineChartViewDataSource>

///折线图
@property (nonatomic, strong) CLLineChartView *chart;
///数据源
@property (nonatomic, strong) NSMutableArray<CLLineChartPoint *> *arrayDS;

@end

@implementation CLLineChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.chart = [[CLLineChartView alloc] init];
    self.chart.dataSource = self;
    [self.view addSubview:self.chart];
    [self.chart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
    
    self.arrayDS = [NSMutableArray array];
    {
        CLLineChartPoint *point = [CLLineChartPoint new];
        point.x = 0.5;
        point.y = 2.8;
        [self.arrayDS addObject:point];
    }
    {
        CLLineChartPoint *point = [CLLineChartPoint new];
        point.x = 1.9;
        point.y = 2.8;
        [self.arrayDS addObject:point];
    }
    {
        CLLineChartPoint *point = [CLLineChartPoint new];
        point.x = 2.9;
        point.y = 3.8;
        [self.arrayDS addObject:point];
    }
    {
        CLLineChartPoint *point = [CLLineChartPoint new];
        point.x = 3.9;
        point.y = 5.8;
        [self.arrayDS addObject:point];
    }
    {
        CLLineChartPoint *point = [CLLineChartPoint new];
        point.x = 4.9;
        point.y = 12.8;
        [self.arrayDS addObject:point];
    }
    {
        CLLineChartPoint *point = [CLLineChartPoint new];
        point.x = 6.9;
        point.y = 4.8;
        [self.arrayDS addObject:point];
    }
    {
        CLLineChartPoint *point = [CLLineChartPoint new];
        point.x = 7.9;
        point.y = 6.8;
        [self.arrayDS addObject:point];
    }
    
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
    return 8;
}
///y最小
- (CGFloat)lineChartViewYLineMin {
    return 0;
}
///y最大
- (CGFloat)lineChartViewYLineMax {
    return 15;
}
///图表宽高
- (CGSize)lineChartViewChartSize {
    return CGSizeMake(self.view.frame.size.width, 200);
}
@end
