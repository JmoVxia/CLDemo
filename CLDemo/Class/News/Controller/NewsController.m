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

@end

@implementation NewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.navigationItem.title = @"课程";
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"血糖数据" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    
    // NSJSONSerialization json数据解析的类
    // 第一个参数：要解析的数据
    // 第二个参数：解析的描述（NSJSONReadingMutableContainers）
    // 第三参数：获取错误（解析过程中的错误 NSError）
    // nil 不需要获取错误信息
    NSError * error = nil;
    // 返回值的类型id，用什么接收取决于最外层的结构
    // 如果［］用数组，如果｛｝用字典
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    
    CLChartView *chartView = [CLChartView new];
    chartView.dic = dic;
    chartView.frame = CGRectMake(0, 99, self.view.frame.size.width, 200);
    [self.view addSubview:chartView];
    

    
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
