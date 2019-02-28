//
//  CLJumpManager.m
//  Potato
//
//  Created by AUG on 2019/1/17.
//

#import "CLJumpManager.h"

@interface CLJumpManager()

@end

@implementation CLJumpManager

+ (UIViewController *)rootViewController {
    UIViewController *viewController = [[[[UIApplication  sharedApplication] delegate] window] rootViewController];
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabViewController =  (UITabBarController *)viewController;
        if ([tabViewController.selectedViewController isKindOfClass:[UINavigationController class]]) {
            viewController = [(UINavigationController *)(tabViewController.selectedViewController) viewControllers].firstObject;
        } else {
            viewController = tabViewController.selectedViewController;
        }
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        viewController = navigationController.viewControllers.firstObject;
    }
    return viewController;
}
+ (UIViewController *)topViewController {
    return [CLJumpManager topViewControllerWithRootViewController:self.rootViewController];
}
+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (rootViewController.presentedViewController) {
            rootViewController = rootViewController.presentedViewController;
        } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController *)rootViewController;
            rootViewController = [navigationController.childViewControllers lastObject];
        } else if ([rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabBarController = (UITabBarController *)rootViewController;
            rootViewController = tabBarController.selectedViewController;
        } else {
            NSUInteger childViewControllerCount = rootViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                rootViewController = rootViewController.childViewControllers.lastObject;
                return rootViewController;
            } else {
                return rootViewController;
            }
        }
    }
    return rootViewController;
}
+ (void)backToRootViewControllerAnimation:(AnimationType)type {
    [self addAnimationWithType:type];
    [self backToRootViewController];
}
+ (void)addAnimationWithType:(AnimationType)type {
    CATransition *animation = [CATransition animation];
    //动画时间
    animation.duration = 0.25f;
    //过滤效果
    animation.type = kCATransitionReveal;
    //动画执行完毕时是否被移除
    animation.removedOnCompletion = YES;
    animation.subtype = kCATransitionFromBottom;
    if (type == AnimationTypeLeft) {
        animation.subtype = kCATransitionFromLeft;
    }
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
}
+ (void)backToRootViewController {
    UIViewController *viewController = [self visibleViewController];
    if ([viewController isEqual:self.rootViewController]) {
        return;
    }
    if (viewController.presentingViewController) {
        while (viewController.presentingViewController) {
            viewController = viewController.presentingViewController;
        }
        [viewController dismissViewControllerAnimated:NO completion:^{
            [self backToRootViewController];
        }];
    } else{
        [viewController.navigationController popToRootViewControllerAnimated:NO];
        [self backToRootViewController];
    }
}
+ (UIViewController *)visibleViewController {
    UIViewController *rootViewController =[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return [CLJumpManager visibleViewControllerFrom:rootViewController];
}
+ (UIViewController *)visibleViewControllerFrom:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [CLJumpManager visibleViewControllerFrom:[((UINavigationController *)viewController) visibleViewController]];
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [CLJumpManager visibleViewControllerFrom:[((UITabBarController *)viewController) selectedViewController]];
    } else {
        if (viewController.presentedViewController) {
            return [CLJumpManager visibleViewControllerFrom:viewController.presentedViewController];
        } else {
            return viewController;
        }
    }
}

@end
