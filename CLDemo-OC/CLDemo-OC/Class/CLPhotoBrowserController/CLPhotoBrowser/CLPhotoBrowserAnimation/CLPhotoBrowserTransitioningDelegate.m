//
//  CLPhotoBrowserTransitioningDelegate.m
//  Potato
//
//  Created by AUG on 2019/6/17.
//

#import "CLPhotoBrowserTransitioningDelegate.h"
#import "CLPhotoBrowserPresentationController.h"
#import "CLPhotoBrowserAnimatedTransitioning.h"
#import <UIKit/UIKit.h>

@interface CLPhotoBrowserTransitioningDelegate ()

@property (nonatomic, weak) CLPhotoBrowserPresentationController *presentationController;

@end

@implementation CLPhotoBrowserTransitioningDelegate
//设置继承自UIPresentationController 的自定义类的属性
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *__unused)source {
    CLPhotoBrowserPresentationController *presentationController = [[CLPhotoBrowserPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    self.presentationController = presentationController;
    return presentationController;
}

//控制器创建执行的动画（返回一个实现UIViewControllerAnimatedTransitioning协议的类）
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *__unused)presented presentingController:(UIViewController *__unused)presenting sourceController:(UIViewController *__unused)source {
    CLPhotoBrowserAnimatedTransitioning *animated = [[CLPhotoBrowserAnimatedTransitioning alloc] initWithAnimatedType:present animatedDuration:0.25];
    return animated;
}

//控制器销毁执行的动画（返回一个实现UIViewControllerAnimatedTransitioning协议的类）
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *__unused)dismissed {
    CLPhotoBrowserAnimatedTransitioning *animated = [[CLPhotoBrowserAnimatedTransitioning alloc] initWithAnimatedType:dismiss animatedDuration:0.25];
    return animated;
}
- (void)setAlpha:(CGFloat)alpha {
    _alpha = alpha;
    self.presentationController.maskViewAlpha = _alpha;
}

@end
