//
//  NewsController.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "NewsController.h"
#import "CLChartView.h"
@interface NewsController ()

/**chartView*/
@property (nonatomic,strong) CLChartView *chartView;

@end

@implementation NewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.navigationItem.title = @"课程";
    
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"血糖数据" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSError * error = nil;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    
    _chartView = [[CLChartView alloc] initWithFrame:CGRectMake(0, 99, self.view.frame.size.width, 200) Array:dic[@"data"]];
    [self.view addSubview:_chartView];
    
    
    
}

@end
