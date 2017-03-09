//
//  TabbarController.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "TabbarController.h"
#import "NavigationController.h"
#import "EssenceController.h"
#import "FollowController.h"
#import "NewsController.h"
#import "MeController.h"
#import "CustomTabbar.h"
#define FontSize         13
#define SelectedColor    [UIColor blackColor]
#define UnSelectedColor  [UIColor lightGrayColor]

@interface TabbarController ()

@end

@implementation TabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
   }
- (void)initUI
{
    [self setValue:[[CustomTabbar alloc]init] forKeyPath:@"tabBar"];
    
    EssenceController *ec = [[EssenceController alloc]init];
    NavigationController *nc1 = [[NavigationController alloc]initWithRootViewController:ec];
    [Tools setControllerTabBarItem:nc1 Title:@"主页" andFoneSize:FontSize withFoneName:nil selectedImage:@"tabBar_essence_click_icon" withTitleColor:SelectedColor unselectedImage:@"tabBar_essence_icon" withTitleColor:UnSelectedColor];
    
    NewsController *nc = [[NewsController alloc]init];
    NavigationController *nc2 = [[NavigationController alloc]initWithRootViewController:nc];
    [Tools setControllerTabBarItem:nc2 Title:@"课程" andFoneSize:FontSize withFoneName:nil selectedImage:@"tabBar_new_click_icon" withTitleColor:SelectedColor unselectedImage:@"tabBar_new_icon" withTitleColor:UnSelectedColor];
    
    FollowController *fc = [[FollowController alloc]init];
    NavigationController *nc3 = [[NavigationController alloc]initWithRootViewController:fc];
    [Tools setControllerTabBarItem:nc3 Title:@"收藏" andFoneSize:FontSize withFoneName:nil selectedImage:@"tabBar_me_click_icon" withTitleColor:SelectedColor unselectedImage:@"tabBar_me_icon" withTitleColor:UnSelectedColor];
    
    MeController *mc = [[MeController alloc]init];
    NavigationController *nc4 = [[NavigationController alloc]initWithRootViewController:mc];
    [Tools setControllerTabBarItem:nc4 Title:@"我的" andFoneSize:FontSize withFoneName:nil selectedImage:@"tabBar_friendTrends_click_icon" withTitleColor:SelectedColor unselectedImage:@"tabBar_friendTrends_icon" withTitleColor:UnSelectedColor];
    
    self.viewControllers = @[nc1,nc2,nc3,nc4];

}


@end
