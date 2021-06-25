//
//  TabbarController.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "CLTabbarController.h"
#import "CLNavigationController.h"
#import "CLCollectionController.h"
#import "CLCurriculumController.h"
#import "CLHomepageController.h"
#import "CLCustomTabbar.h"
#import "Tools.h"
#import "CLMyController.h"

@interface CLTabbarController ()
{
    NSTimeInterval _lastSameIndexTapTime;
    int _tapsInSuccession;
}
@end

@implementation CLTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
   }
- (void)initUI
{
    NSLog(@"沙盒路径----->>>%@",Tools.pathDocuments);
    CLCustomTabbar *tabbar = [[CLCustomTabbar alloc] init];
    __weak __typeof(self) weakSelf = self;
    [tabbar setBulgeCallBack:^{
        __typeof(&*weakSelf) strongSelf = weakSelf;
        strongSelf.selectedIndex = 2;
    }];
    [self setValue:tabbar forKeyPath:@"tabBar"];
    
    CLHomepageController *mc = [[CLHomepageController alloc] init];
    CLNavigationController *nc1 = [[CLNavigationController alloc] initWithRootViewController:mc];
    [Tools setControllerTabBarItem:nc1 Title:NSLocalizedString(@"主页", nil) andFoneSize:13 withFoneName:nil selectedImage:@"tabBar_friendTrends_click_icon" withTitleColor:[UIColor blackColor] unselectedImage:@"tabBar_friendTrends_icon" withTitleColor:[UIColor lightGrayColor]];
    
    CLCurriculumController *nc = [[CLCurriculumController alloc] init];
    CLNavigationController *nc2 = [[CLNavigationController alloc] initWithRootViewController:nc];
    [Tools setControllerTabBarItem:nc2 Title:NSLocalizedString(@"课程", nil) andFoneSize:13 withFoneName:nil selectedImage:@"tabBar_new_click_icon" withTitleColor:[UIColor blackColor] unselectedImage:@"tabBar_new_icon" withTitleColor:[UIColor lightGrayColor]];
    
    
    CLController *aaaa = [[CLController alloc] init];
    aaaa.title = @"凸起";
    CLNavigationController *nc3 = [[CLNavigationController alloc] initWithRootViewController:aaaa];
    
    
    CLCollectionController *fc = [[CLCollectionController alloc] init];
    CLNavigationController *nc4 = [[CLNavigationController alloc] initWithRootViewController:fc];
    [Tools setControllerTabBarItem:nc4 Title:NSLocalizedString(@"收藏", nil) andFoneSize:13 withFoneName:nil selectedImage:@"tabBar_me_click_icon" withTitleColor:[UIColor blackColor] unselectedImage:@"tabBar_me_icon" withTitleColor:[UIColor lightGrayColor]];

    CLMyController *my = [[CLMyController alloc] init];
    CLNavigationController *nc5 = [[CLNavigationController alloc] initWithRootViewController:my];
    [Tools setControllerTabBarItem:nc5 Title:NSLocalizedString(@"我的", nil) andFoneSize:13 withFoneName:nil selectedImage:@"tabBar_essence_click_icon" withTitleColor:[UIColor blackColor] unselectedImage:@"tabBar_essence_icon" withTitleColor:[UIColor lightGrayColor]];
    self.viewControllers = @[nc1,nc2,nc3,nc4,nc5];
}


-(void)dealloc {
    NSLog(@"Tabbar页面销毁了");
}

@end
