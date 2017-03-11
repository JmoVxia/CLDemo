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
    
    
    _chartView = [[CLChartView alloc] initWithFrame:CGRectMake(0, 99, self.view.CLwidth, 250)];
    [self.view addSubview:_chartView];
//    [_chartView makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.top.equalTo(99);
//        make.height.equalTo(200);
//    }];
    
    
    _chartView.array = dic[@"data"];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"血压数据" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSError * error = nil;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    _chartView.array = dic[@"data"];

    
}




@end
