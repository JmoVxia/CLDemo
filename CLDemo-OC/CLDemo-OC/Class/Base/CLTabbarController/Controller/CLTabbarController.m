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
#import "UIColor+CLHex.h"
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
- (void)initUI {
    NSLog(@"沙盒路径----->>>%@",Tools.pathDocuments);
    
    CLCustomTabbar *tabbar = [[CLCustomTabbar alloc] init];
    __weak __typeof(self) weakSelf = self;
    [tabbar setBulgeCallBack:^{
        __typeof(&*weakSelf) strongSelf = weakSelf;
        strongSelf.selectedIndex = 2;
    }];
    [self setValue:tabbar forKeyPath:@"tabBar"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [UITabBar appearance].unselectedItemTintColor = [UIColor colorWithHex:@"999999"];
    [UITabBar appearance].tintColor = [UIColor colorWithHex:@"24C065"];
    
    [self addChild:[[CLHomepageController alloc] init]
             title:NSLocalizedString(@"主页", nil)
             image:[UIImage imageNamed:@"tabBar_friendTrends_icon"]
     selectedImage:[UIImage imageNamed:@"tabBar_friendTrends_click_icon"]];
    
    [self addChild:[[CLCurriculumController alloc] init]
             title:NSLocalizedString(@"课程", nil)
             image:[UIImage imageNamed:@"tabBar_new_icon"]
     selectedImage:[UIImage imageNamed:@"tabBar_new_click_icon"]];

    [self addChild:[[CLController alloc] init]
             title:NSLocalizedString(@"课程", nil)
             image:[UIImage imageNamed:@"tabBar_new_icon"]
     selectedImage:[UIImage imageNamed:@"tabBar_new_click_icon"]];

    [self addChild:[[CLCollectionController alloc] init]
             title:NSLocalizedString(@"收藏", nil)
             image:[UIImage imageNamed:@"tabBar_me_icon"]
     selectedImage:[UIImage imageNamed:@"tabBar_me_click_icon"]];

    [self addChild:[[CLController alloc] init]
             title:NSLocalizedString(@"我的", nil)
             image:[UIImage imageNamed:@"tabBar_essence_icon"]
     selectedImage:[UIImage imageNamed:@"tabBar_essence_click_icon"]];
}

-(void)addChild:(UIViewController *)child title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    child.title = title;
    [child.tabBarItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]} forState:UIControlStateNormal];
    [child.tabBarItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]} forState:UIControlStateSelected];
    child.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    child.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CLNavigationController *navController = [[CLNavigationController alloc] initWithRootViewController:child];
    [self addChildViewController:navController];
}

-(BOOL)shouldAutorotate {
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        return [[(UINavigationController *)self.selectedViewController topViewController] shouldAutorotate] ?: NO;
    } else {
        return [self.selectedViewController shouldAutorotate] ?: NO;
    }
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        return [[(UINavigationController *)self.selectedViewController topViewController] supportedInterfaceOrientations] ?: UIInterfaceOrientationMaskPortrait;
    } else {
        return [self.selectedViewController supportedInterfaceOrientations] ?: UIInterfaceOrientationMaskPortrait;
    }
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        return [[(UINavigationController *)self.selectedViewController topViewController] preferredInterfaceOrientationForPresentation] ?: UIInterfaceOrientationPortrait;
    } else {
        return [self.selectedViewController preferredInterfaceOrientationForPresentation] ?: UIInterfaceOrientationPortrait;
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        return [[(UINavigationController *)self.selectedViewController topViewController] preferredStatusBarStyle] ?: UIStatusBarStyleDefault;
    } else {
        return [self.selectedViewController preferredStatusBarStyle] ?: UIStatusBarStyleDefault;
    }
}

-(BOOL)prefersStatusBarHidden {
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        return [[(UINavigationController *)self.selectedViewController topViewController] prefersStatusBarHidden] ?: NO;
    } else {
        return [self.selectedViewController prefersStatusBarHidden] ?: NO;
    }
}

-(UIUserInterfaceStyle)overrideUserInterfaceStyle {
    if (@available(iOS 13.0, *)) {
        if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
            return [[(UINavigationController *)self.selectedViewController topViewController] overrideUserInterfaceStyle] ?: UIUserInterfaceStyleLight;
        } else {
            return [self.selectedViewController overrideUserInterfaceStyle] ?: UIUserInterfaceStyleLight;
        }
    }else {
        return UIUserInterfaceStyleLight;
    }
}
@end
