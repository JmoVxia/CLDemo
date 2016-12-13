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

    NSArray *titlesArray = @[@"推荐",@"精华",@"图片",@"声音",@"视频",@"段子",@"社会",@"福利"];
    
    
    NSMutableArray *controllerArray = [NSMutableArray array];
    
    for (int i = 0; i < titlesArray.count; i++)
    {
        NSString *classString = @"AAAAViewController";
        
        [controllerArray addObject:classString];
        
    }

    
    TitleControllerView *titleView =  [[TitleControllerView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    
    [titleView initWithTitleArray:[NSMutableArray arrayWithArray:titlesArray] controllerArray:controllerArray fatherController:self];
    
    
    [self.view addSubview:titleView];
    
}










@end
