//
//  CLCustomTransitionDelegate.m
//  CLDemo
//
//  Created by AUG on 2019/8/31.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLCustomTransitionDelegate.h"
#import "CLCustomTransitionAnimatedTransitioning.h"
#import "CLCustomTransitionPresentationController.h"

@implementation CLCustomTransitionDelegate


- (instancetype)init {
    self = [super init];
    if (self) {
        self.presentDuration = 0.35;
        self.dissmissDuration = 0.35;
    }
    return self;
}


//控制器创建执行的动画（返回一个实现UIViewControllerAnimatedTransitioning协议的类）
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *__unused)presented presentingController:(UIViewController *__unused)presenting sourceController:(UIViewController *__unused)source {
    CLCustomTransitionAnimatedTransitioning *animated = [[CLCustomTransitionAnimatedTransitioning alloc] initWithAnimatedType:present animatedDuration:self.presentDuration];
    return animated;
}

//控制器销毁执行的动画（返回一个实现UIViewControllerAnimatedTransitioning协议的类）
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *__unused)dismissed {
    CLCustomTransitionAnimatedTransitioning *animated = [[CLCustomTransitionAnimatedTransitioning alloc] initWithAnimatedType:dismiss animatedDuration:self.dissmissDuration];
    return animated;
}
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *__unused)source {
    CLCustomTransitionPresentationController *presentationController = [[CLCustomTransitionPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    return presentationController;
}
- (BOOL)shouldRemovePresentersView {
    return YES;
}
@end
