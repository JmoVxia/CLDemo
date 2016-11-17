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
#define FONESIZT         13
#define SELECTEDCOLOR    [UIColor colorWithRed:0.31765f green:0.31765f blue:0.31765f alpha:1.00000f]
#define UNSELECTEDCOLOR  [UIColor grayColor]

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
    [Tools setControllerTabBarItem:nc1 Title:@"精华" andFoneSize:FONESIZT withFoneName:nil selectedImage:@"tabBar_essence_click_icon" withTitleColor:SELECTEDCOLOR unselectedImage:@"tabBar_essence_icon" withTitleColor:UNSELECTEDCOLOR];
    
    NewsController *nc = [[NewsController alloc]init];
    NavigationController *nc2 = [[NavigationController alloc]initWithRootViewController:nc];
    [Tools setControllerTabBarItem:nc2 Title:@"最新" andFoneSize:FONESIZT withFoneName:nil selectedImage:@"tabBar_new_click_icon" withTitleColor:SELECTEDCOLOR unselectedImage:@"tabBar_new_icon" withTitleColor:UNSELECTEDCOLOR];
    
    FollowController *fc = [[FollowController alloc]init];
    NavigationController *nc3 = [[NavigationController alloc]initWithRootViewController:fc];
    [Tools setControllerTabBarItem:nc3 Title:@"关注" andFoneSize:FONESIZT withFoneName:nil selectedImage:@"tabBar_me_click_icon" withTitleColor:SELECTEDCOLOR unselectedImage:@"tabBar_me_icon" withTitleColor:UNSELECTEDCOLOR];
    
    MeController *mc = [[MeController alloc]init];
    NavigationController *nc4 = [[NavigationController alloc]initWithRootViewController:mc];
    [Tools setControllerTabBarItem:nc4 Title:@"我" andFoneSize:FONESIZT withFoneName:nil selectedImage:@"tabBar_friendTrends_click_icon" withTitleColor:SELECTEDCOLOR unselectedImage:@"tabBar_friendTrends_icon" withTitleColor:UNSELECTEDCOLOR];
    
    self.viewControllers = @[nc1,nc2,nc3,nc4];

}


@end
