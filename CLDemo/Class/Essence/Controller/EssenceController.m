//
//  EssenceController.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "EssenceController.h"
#import "TitleControllerView.h"
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256.0)/255.0 green:arc4random_uniform(256.0)/255.0 blue:arc4random_uniform(256.0)/255.0 alpha:1.0]

@interface EssenceController ()<UIScrollViewDelegate>


/** 底部的所有内容 */
@property (nonatomic, weak) UIScrollView *contentView;

/* 控制器数组和标题数组 */
@property (nonatomic, strong) NSArray *titlesArray;

@property (nonatomic, strong) NSMutableArray *controllersArray;

@end

@implementation EssenceController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"主页";
    
    self.controllersArray = [NSMutableArray array];
    _titlesArray = @[@"推荐",@"精华",@"图片",@"声音",@"视频",@"段子",@"社会",@"福利"];
    
    for (int i = 0; i < _titlesArray.count; i++)
    {
        UIViewController *vc1 = [[UIViewController alloc] init];
        vc1.view.backgroundColor = RandomColor;
        [self.controllersArray addObject:vc1];
    }

    
    TitleControllerView *titleView =  [[TitleControllerView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64-49)];
    [titleView initWithTitleArray:_titlesArray controllersArray:self.controllersArray fatherController:self];
    
    [self.view addSubview:titleView];
    
}










@end
