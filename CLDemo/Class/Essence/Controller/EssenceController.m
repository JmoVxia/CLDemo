//
//  EssenceController.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "EssenceController.h"
#import "TitleButtonView.h"
@interface EssenceController ()

@end

@implementation EssenceController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"精华";
    [self initScrollView];
    [self initUI];
}
- (void)initScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:scrollView];
}
- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    TitleButtonView *titleButtonView = [[TitleButtonView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 40)];
    NSArray *array = @[@"推荐",@"精华",@"图片",@"声音",@"视频",@"段子",@"社会",@"福利"];
    titleButtonView.array = array;
    
    titleButtonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleButtonView];
}

@end
