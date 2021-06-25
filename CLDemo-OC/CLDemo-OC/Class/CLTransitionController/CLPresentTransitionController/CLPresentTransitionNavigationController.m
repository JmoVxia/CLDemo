//
//  CLPresentTransitionNavigationController.m
//  CLDemo
//
//  Created by AUG on 2019/7/19.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLPresentTransitionNavigationController.h"
#import "CLTransitioningDelegate.h"

@interface CLPresentTransitionNavigationController ()<UINavigationControllerDelegate>

@property(nonatomic, assign) CLInteractiveCoverDirection presentDirection;

@property(nonatomic, assign) CLInteractiveCoverDirection dissmissDirection;

///转场代理
@property (nonatomic, strong) CLTransitioningDelegate *transitioning;

//dissmiss交互控制器
@property (nonatomic, strong) UIViewController *dissmissInteractiveController;


@end

@implementation CLPresentTransitionNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    return [self initWithRootViewController:rootViewController presentDirection:CLInteractiveCoverDirectionRightToLeft dissmissDirection:CLInteractiveCoverDirectionLeftToRight];
}


- (instancetype)initWithRootViewController:(UIViewController *)rootViewController presentDirection:(CLInteractiveCoverDirection)presentDirection dissmissDirection:(CLInteractiveCoverDirection)dissmissDirection {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.dissmissInteractiveController = rootViewController;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalPresentationCapturesStatusBarAppearance = YES;
        self.presentDirection = presentDirection;
        self.dissmissDirection = dissmissDirection;
        self.transitioningDelegate = self.transitioning;
    }
    return self;
}

- (CLTransitioningDelegate *) transitioning {
    if (_transitioning == nil) {
        _transitioning = [[CLTransitioningDelegate alloc] initWithPresentDirection:self.presentDirection dissmissDirection:self.dissmissDirection dissmissInteractiveController:self.dissmissInteractiveController];
    }
    return _transitioning;
}


@end
