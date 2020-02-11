//
//  CLCustomTransitionPresentationController.m
//  CLDemo
//
//  Created by AUG on 2019/9/3.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLCustomTransitionPresentationController.h"

@implementation CLCustomTransitionPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    if (self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]) {
    }
    return self;
}

- (BOOL)shouldRemovePresentersView {
    return YES;
}

@end
