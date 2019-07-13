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

+ (void)backToRootViewControllerAnimation:(AnimationType)type belongView:(UIView *)view {
    UIViewController *viewController = [self findBelongViewControllerForView:view];
    if (viewController.presentingViewController) {
        while (viewController.presentingViewController) {
            viewController = viewController.presentingViewController;
        }
        if (type) {
            [self addAnimationWithType:type];
        }else {
            [self addAnimationWithType:AnimationTypeBottom];
        }
        [viewController dismissViewControllerAnimated:NO completion:nil];
    } else{
        if (type) {
            [self addAnimationWithType:type];
        }else {
            [self addAnimationWithType:AnimationTypeLeft];
        }
        [viewController.navigationController popToRootViewControllerAnimated:NO];
    }
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
+ (void)addAnimationWithType:(AnimationType)type {
    if (type != AnimationTypeNone) {
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
}
+ (void)backToRootViewControllerBelongView:(UIView *)view {
    [self backToRootViewControllerAnimation:AnimationTypeNone belongView:view];
}
+ (nullable UIViewController *)findBelongViewControllerForView:(UIView *)view {
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]]) {
            return (UIViewController *)responder;
        }
    return nil;
}

@end
