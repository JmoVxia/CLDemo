//
//  TabbarController.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "CLTabbarController.h"
#import "CLBaseNavigationController.h"
#import "CLEssenceController.h"
#import "CLCollectionController.h"
#import "CLCurriculumController.h"
#import "CLMyController.h"
#import "CLCustomTabbar.h"

@interface CLTabbarController ()

@end

@implementation CLTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
   }
- (void)initUI
{
    CLLog(@"沙盒路径----->>>%@",Tools.pathDocuments);
    [self setValue:[[CLCustomTabbar alloc] init] forKeyPath:@"tabBar"];
    
    CLEssenceController *ec = [[CLEssenceController alloc] init];
    CLBaseNavigationController *nc1 = [[CLBaseNavigationController alloc] initWithRootViewController:ec];
    [Tools setControllerTabBarItem:nc1 Title:NSLocalizedString(@"主页", nil) andFoneSize:13 withFoneName:nil selectedImage:@"tabBar_essence_click_icon" withTitleColor:[UIColor blackColor] unselectedImage:@"tabBar_essence_icon" withTitleColor:[UIColor lightGrayColor]];
    
    CLCurriculumController *nc = [[CLCurriculumController alloc] init];
    CLBaseNavigationController *nc2 = [[CLBaseNavigationController alloc] initWithRootViewController:nc];
    [Tools setControllerTabBarItem:nc2 Title:NSLocalizedString(@"课程", nil) andFoneSize:13 withFoneName:nil selectedImage:@"tabBar_new_click_icon" withTitleColor:[UIColor blackColor] unselectedImage:@"tabBar_new_icon" withTitleColor:[UIColor lightGrayColor]];
    
    CLCollectionController *fc = [[CLCollectionController alloc] init];
    CLBaseNavigationController *nc3 = [[CLBaseNavigationController alloc] initWithRootViewController:fc];
    [Tools setControllerTabBarItem:nc3 Title:NSLocalizedString(@"收藏", nil) andFoneSize:13 withFoneName:nil selectedImage:@"tabBar_me_click_icon" withTitleColor:[UIColor blackColor] unselectedImage:@"tabBar_me_icon" withTitleColor:[UIColor lightGrayColor]];
    
    CLMyController *mc = [[CLMyController alloc] init];
    CLBaseNavigationController *nc4 = [[CLBaseNavigationController alloc] initWithRootViewController:mc];
    [Tools setControllerTabBarItem:nc4 Title:NSLocalizedString(@"我的", nil) andFoneSize:13 withFoneName:nil selectedImage:@"tabBar_friendTrends_click_icon" withTitleColor:[UIColor blackColor] unselectedImage:@"tabBar_friendTrends_icon" withTitleColor:[UIColor lightGrayColor]];
    
    self.viewControllers = @[nc1,nc2,nc3,nc4];

}
-(void)dealloc {
    CLLog(@"Tabbar页面销毁了");
}

@end
