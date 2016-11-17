//
//  EssenceController.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "EssenceController.h"
#import "ScrollView.h"
@interface EssenceController ()

@end

@implementation EssenceController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"主页";
    [self initUI];
}

- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    ScrollView *scroll = [[ScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 - 49)];
    NSArray *array = @[@"推荐",@"精华",@"图片",@"声音",@"视频",@"段子",@"社会",@"福利"];
    scroll.titleArray = array;
    [self.view addSubview:scroll];
}

- (void)initScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:scrollView];
}
@end
