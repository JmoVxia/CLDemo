//
//  CLTransitioningDelegate.m
//  CLDemo
//
//  Created by AUG on 2019/7/19.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLTransitioningDelegate.h"
#import "CLAnimatedTransitioning.h"
#import "CLDrivenInteractiveTransition.h"

@interface CLTransitioningDelegate ()

@property(nonatomic, assign) CLInteractiveCoverDirection presentDirection;

@property(nonatomic, assign) CLInteractiveCoverDirection dissmissDirection;

///交互动画
@property (nonatomic, strong) CLDrivenInteractiveTransition *interactiveTransition;

@end


@implementation CLTransitioningDelegate

-(instancetype)initWithPresentDirection:(CLInteractiveCoverDirection)presentDirection dissmissDirection:(CLInteractiveCoverDirection)dissmissDirection dissmissInteractiveController:(UIViewController *)dissmissInteractiveController{
    if (self = [super init]) {
        self.presentDirection = presentDirection;
        self.dissmissDirection = dissmissDirection;
        self.interactiveTransition = [[CLDrivenInteractiveTransition alloc] initWithDissmissDirection:self.dissmissDirection dissmissInteractiveController:dissmissInteractiveController];
    }
    return self;
}

//控制器创建执行的动画（返回一个实现UIViewControllerAnimatedTransitioning协议的类）
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *__unused)presented presentingController:(UIViewController *__unused)presenting sourceController:(UIViewController *__unused)source {
    CLAnimatedTransitioning *animated = [[CLAnimatedTransitioning alloc] initWithAnimatedType:present animatedDuration:0.35 direction:self.presentDirection];
    return animated;
}

//控制器销毁执行的动画（返回一个实现UIViewControllerAnimatedTransitioning协议的类）
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *__unused)dismissed {
    CLAnimatedTransitioning *animated = [[CLAnimatedTransitioning alloc] initWithAnimatedType:dismiss animatedDuration:0.35 direction:self.dissmissDirection];
    return animated;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactiveTransition.interactioning ? self.interactiveTransition : nil;
}

@end
