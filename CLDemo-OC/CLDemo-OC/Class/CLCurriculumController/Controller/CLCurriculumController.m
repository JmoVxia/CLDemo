//
//  CurriculumController.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "CLCurriculumController.h"
#import "CLChartView.h"
#import "UIView+CLSetRect.h"

@interface CLCurriculumController ()<CLChartViewDelegate>

/**chartView*/
@property (nonatomic,strong) CLChartView *chartView;

@end

@implementation CLCurriculumController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = NSLocalizedString(@"课程", nil);
    
    
    
    _chartView = [[CLChartView alloc] initWithFrame:CGRectMake(0, 99, self.view.cl_width, 250)];
    [self.view addSubview:_chartView];
    _chartView.delegate = self;
    [_chartView selectedWeek];
    
}

/**周*/
- (void)CLChartViewDidSelectedWeek:(UIButton *)weekButton{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"一周" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSError * error = nil;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    _chartView.dic = dic;
}
/**一月*/
- (void)CLChartViewDidSelectedOneMonth:(UIButton *)oneMonth{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"一月" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSError * error = nil;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    _chartView.dic = dic;
}
/**三月*/
- (void)CLChartViewDidSelectedThreeMonth:(UIButton *)threeMonth{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"三月" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSError * error = nil;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    _chartView.dic = dic;
}
/**六月*/
- (void)CLChartViewDidSelectedSixMonth:(UIButton *)sixMonth{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"六月" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSError * error = nil;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    _chartView.dic = dic;
}
/**一年*/
- (void)CLChartViewDidSelectedYear:(UIButton *)year{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"一年" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSError * error = nil;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    _chartView.dic = dic;
}

#pragma mark - 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)dealloc {
    NSLog(@"课程页面销毁了");
}


@end
