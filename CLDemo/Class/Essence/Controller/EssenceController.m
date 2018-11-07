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



@end

@implementation EssenceController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"主页";

    NSArray *titlesArray = @[@"推荐视频",@"精华",@"图片",@"声音",@"视频",@"段子",@"社会",@"福利"];
    NSString *classString = @"AAAAViewController";

    //控制器类名数组
    NSMutableArray *controllerClassNameArray = [NSMutableArray array];
    //常态颜色数组
    NSMutableArray *titleNormalColorArray = [NSMutableArray array];
    //选中颜色数组
    NSMutableArray *titleSelectedColorArray = [NSMutableArray array];

    [titlesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [controllerClassNameArray addObject:classString];
        [titleNormalColorArray addObject:CLRandomColor];
        [titleSelectedColorArray addObject:CLRandomColor];

    }];
    
    //创建
    TitleControllerView *titleView =  [[TitleControllerView alloc] initWithFrame:CGRectMake(0, cl_statusBarAndNavigationBarHeight, cl_screenWidth, cl_screenHeight - cl_tabbarHeight - cl_statusBarAndNavigationBarHeight)];

    
    //初始化
    [titleView initWithTitleArray:[NSMutableArray arrayWithArray:titlesArray] controllerClassNameArray:controllerClassNameArray titleNormalColorArray:titleNormalColorArray titleSelectedColorArray:titleSelectedColorArray number:5 fatherController:self];
    
    
    [self.view addSubview:titleView];

}



























@end
