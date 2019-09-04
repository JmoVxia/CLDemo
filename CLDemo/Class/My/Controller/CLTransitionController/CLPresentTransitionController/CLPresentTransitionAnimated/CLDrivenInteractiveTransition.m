//
//  CLDrivenInteractiveTransition.m
//  CLDemo
//
//  Created by AUG on 2019/7/19.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLDrivenInteractiveTransition.h"

@interface CLDrivenInteractiveTransition ()

@property (nonatomic, assign) CLInteractiveCoverDirection dissmissDirection;

@property (nonatomic, strong) UIViewController *dissmissInteractiveController;

@property (nonatomic, assign) BOOL interactioning;

@property (nonatomic, assign) BOOL shouldComplete;

@end

@implementation CLDrivenInteractiveTransition

- (instancetype)initWithDissmissDirection:(CLInteractiveCoverDirection)dissmissDirection dissmissInteractiveController:(UIViewController *)dissmissInteractiveController {
    if (self = [super init]) {
        self.dissmissDirection = dissmissDirection;
        self.dissmissInteractiveController = dissmissInteractiveController;
        [self addGestureToViewController];
    }
    return self;
}

- (CGFloat)completionSpeed {
    return 1 - self.percentComplete;
}

// 添加手势
- (void)addGestureToViewController {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.dissmissInteractiveController.view addGestureRecognizer:panGestureRecognizer];
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view.superview];
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.interactioning = YES;
            [self.dissmissInteractiveController dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged:
            [self panGestureStateChanged:translation];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            self.interactioning = NO;
            if (!self.shouldComplete || panGestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
            break;
        default:
            break;
    }
}

-(void)panGestureStateChanged:(CGPoint)point {
    switch (self.dissmissDirection) {
        case CLInteractiveCoverDirectionBottomToTop:
        {
            if (point.y > 0) {
                return;
            }
            CGFloat fraction = fabs(point.y) / [[UIScreen mainScreen] bounds].size.height;
            fraction = fminf(fmaxf(fraction, 0.0), 1.0);
            self.shouldComplete = (fraction > 0.5);
            [self updateInteractiveTransition:fraction];
        }
            break;
        case CLInteractiveCoverDirectionLeftToRight:
        {
            if (point.x < 0) {
                return;
            }
            CGFloat fraction = point.x / [[UIScreen mainScreen] bounds].size.width;
            fraction = fminf(fmaxf(fraction, 0.0), 1.0);
            self.shouldComplete = (fraction > 0.5);
            [self updateInteractiveTransition:fraction];
        }
            break;
        case CLInteractiveCoverDirectionRightToLeft:
        {
            if (point.x > 0) {
                return;
            }
            CGFloat fraction = fabs(point.x) / [[UIScreen mainScreen] bounds].size.width;
            fraction = fminf(fmaxf(fraction, 0.0), 1.0);
            self.shouldComplete = (fraction > 0.5);
            [self updateInteractiveTransition:fraction];
        }
            break;
        case CLInteractiveCoverDirectionTopToBottom:
        {
            if (point.y < 0) {
                return;
            }
            CGFloat fraction = point.y / [[UIScreen mainScreen] bounds].size.height;
            fraction = fminf(fmaxf(fraction, 0.0), 1.0);
            self.shouldComplete = (fraction > 0.5);
            [self updateInteractiveTransition:fraction];
        }
            break;
        default:
            break;
    }
}

@end
