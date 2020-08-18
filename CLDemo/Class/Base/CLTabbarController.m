//
//  TabbarController.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "CLTabbarController.h"
#import "CLBaseNavigationController.h"
#import "CLCollectionController.h"
#import "CLCurriculumController.h"
#import "CLHomepageController.h"
#import "CLCustomTabbar.h"
#import "CLDemo-Swift.h"

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
    CLLog(@"沙盒路径----->>>%@",Tools.pathDocuments);
    CLCustomTabbar *tabbar = [[CLCustomTabbar alloc] init];
    __weak __typeof(self) weakSelf = self;
    [tabbar setBulgeCallBack:^{
        __typeof(&*weakSelf) strongSelf = weakSelf;
        strongSelf.selectedIndex = 2;
    }];
    [self setValue:tabbar forKeyPath:@"tabBar"];
    
    CLHomepageController *mc = [[CLHomepageController alloc] init];
    CLBaseNavigationController *nc1 = [[CLBaseNavigationController alloc] initWithRootViewController:mc];
    [Tools setControllerTabBarItem:nc1 Title:NSLocalizedString(@"主页", nil) andFoneSize:13 withFoneName:nil selectedImage:@"tabBar_friendTrends_click_icon" withTitleColor:[UIColor blackColor] unselectedImage:@"tabBar_friendTrends_icon" withTitleColor:[UIColor lightGrayColor]];
    
    CLCurriculumController *nc = [[CLCurriculumController alloc] init];
    CLBaseNavigationController *nc2 = [[CLBaseNavigationController alloc] initWithRootViewController:nc];
    [Tools setControllerTabBarItem:nc2 Title:NSLocalizedString(@"课程", nil) andFoneSize:13 withFoneName:nil selectedImage:@"tabBar_new_click_icon" withTitleColor:[UIColor blackColor] unselectedImage:@"tabBar_new_icon" withTitleColor:[UIColor lightGrayColor]];
    
    
    CLBaseViewController *aaaa = [[CLBaseViewController alloc] init];
    aaaa.title = @"凸起";
    CLBaseNavigationController *nc3 = [[CLBaseNavigationController alloc] initWithRootViewController:aaaa];
    
    
    CLCollectionController *fc = [[CLCollectionController alloc] init];
    CLBaseNavigationController *nc4 = [[CLBaseNavigationController alloc] initWithRootViewController:fc];
    [Tools setControllerTabBarItem:nc4 Title:NSLocalizedString(@"收藏", nil) andFoneSize:13 withFoneName:nil selectedImage:@"tabBar_me_click_icon" withTitleColor:[UIColor blackColor] unselectedImage:@"tabBar_me_icon" withTitleColor:[UIColor lightGrayColor]];

    CLMyController *ec = [[CLMyController alloc] init];
    CLBaseNavigationController *nc5 = [[CLBaseNavigationController alloc] initWithRootViewController:ec];
    [Tools setControllerTabBarItem:nc5 Title:NSLocalizedString(@"我的", nil) andFoneSize:13 withFoneName:nil selectedImage:@"tabBar_essence_click_icon" withTitleColor:[UIColor blackColor] unselectedImage:@"tabBar_essence_icon" withTitleColor:[UIColor lightGrayColor]];
    self.viewControllers = @[nc1,nc2,nc3,nc4,nc5];
}
- (void)pushToDebug {
    CLDebugController *controller = [CLDebugController new];
    CLBaseNavigationController *navigationController = [[CLBaseNavigationController alloc] initWithRootViewController:controller];
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navigationController animated:YES completion:nil];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (self.selectedIndex == 0) {
        NSTimeInterval t = CACurrentMediaTime();
        if (_lastSameIndexTapTime < DBL_EPSILON || t < _lastSameIndexTapTime + 0.5) {
            _lastSameIndexTapTime = t;
            _tapsInSuccession++;
            if (_tapsInSuccession == 10) {
                _tapsInSuccession = 0;
                _lastSameIndexTapTime = 0.0;
                [self pushToDebug];
            }
        } else {
            _lastSameIndexTapTime = 0.0;
            _tapsInSuccession = 0;
        }
    }
}

-(void)dealloc {
    CLLog(@"Tabbar页面销毁了");
}

@end
