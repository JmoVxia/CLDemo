//
//  NavigationController.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "CLNavigationController.h"
#import "CLController.h"
#import "UIImage+CLScaleToSize.h"

@interface CLNavigationController ()

@property(nonatomic, strong) UIButton *backButton;

@end

@implementation CLNavigationController

-(UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[[UIImage imageNamed:@"back"] imageWithTintColor:[UIColor blackColor]] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.tintColor = [UIColor blackColor];
}

- (void)setNavigationBarBackgroundColor:(UIColor *)navigationBarBackgroundColor {
    self.view.backgroundColor = navigationBarBackgroundColor;
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:navigationBarBackgroundColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage imageWithColor:navigationBarBackgroundColor]];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = navigationBarBackgroundColor;
        appearance.shadowColor = [UIColor clearColor];
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = appearance;
    }
}

-(void)backAction {
    if ([self.topViewController isKindOfClass:[CLController class]]) {
        CLController *controller = (CLController *)self.topViewController;
        [controller back];
    }
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    }
    [super pushViewController:viewController animated:animated];
}

-(void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    if (viewControllers.count > 0) {
        UIViewController *lastViewController = viewControllers.lastObject;
        lastViewController.hidesBottomBarWhenPushed = YES;
        lastViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    }
    [super setViewControllers:viewControllers animated:animated];
}

-(NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        self.topViewController.hidesBottomBarWhenPushed = NO;
    }
    return [super popToRootViewControllerAnimated:animated];
}

-(BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}

-(BOOL)prefersStatusBarHidden {
    return self.topViewController.prefersStatusBarHidden;
}

-(UIUserInterfaceStyle)overrideUserInterfaceStyle {
    if (@available(iOS 13.0, *)) {
        return self.topViewController.overrideUserInterfaceStyle;
    } else {
        return UIUserInterfaceStyleLight;
    }
}

@end
