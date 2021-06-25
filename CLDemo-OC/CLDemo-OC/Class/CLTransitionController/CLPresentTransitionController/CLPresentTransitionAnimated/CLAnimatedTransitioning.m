//
//  CLAnimatedTransitioning.m
//  CLDemo
//
//  Created by AUG on 2019/7/19.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLAnimatedTransitioning.h"
#import <UIKit/UIKit.h>

@interface CLAnimatedTransitioning ()

@property (nonatomic, assign) CLAnimatedTransitionType animatedType;

@property(nonatomic, assign) CLInteractiveCoverDirection direction;

@property (nonatomic, assign) NSTimeInterval animatedDuration;


@end


@implementation CLAnimatedTransitioning

-(instancetype)initWithAnimatedType:(CLAnimatedTransitionType)type animatedDuration:(NSTimeInterval)duration direction:(CLInteractiveCoverDirection)direction {
    if (self = [super init]) {
        self.animatedType = type;
        self.direction = direction;
        self.animatedDuration = duration;
    }
    return self;
}
//MARK: - JmoVxia---UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning> __unused)transitionContext {
    return self.animatedDuration;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *toView = (UIView *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    UIView *fromView = (UIView *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *containerView = [transitionContext containerView];
    
    if (self.animatedType == present) {
        [containerView addSubview:toView];
        switch (_direction) {
            case CLInteractiveCoverDirectionLeftToRight:
                toView.transform = CGAffineTransformMakeTranslation(- toView.bounds.size.width, 0);
                break;
            case CLInteractiveCoverDirectionRightToLeft:
                toView.transform = CGAffineTransformMakeTranslation(toView.bounds.size.width, 0);
                break;
            case CLInteractiveCoverDirectionBottomToTop:
                toView.transform = CGAffineTransformMakeTranslation(0, toView.bounds.size.height);
                break;
            case CLInteractiveCoverDirectionTopToBottom:
                toView.transform = CGAffineTransformMakeTranslation(0, - toView.bounds.size.height);
                break;
            default:
                break;
        }
    }else {
        [containerView addSubview:fromView];
    }
    
    [UIView animateWithDuration:self.animatedDuration animations:^{
        if (self.animatedType == present) {
            toView.transform = CGAffineTransformIdentity;
        }else{
            switch (self->_direction) {
                case CLInteractiveCoverDirectionLeftToRight:
                    fromView.transform = CGAffineTransformMakeTranslation(fromView.bounds.size.width, 0);
                    break;
                case CLInteractiveCoverDirectionRightToLeft:
                    fromView.transform = CGAffineTransformMakeTranslation(- fromView.bounds.size.width, 0);
                    break;
                case CLInteractiveCoverDirectionTopToBottom:
                    fromView.transform = CGAffineTransformMakeTranslation(0, fromView.bounds.size.height);
                    break;
                case CLInteractiveCoverDirectionBottomToTop:
                    fromView.transform = CGAffineTransformMakeTranslation(0, - fromView.bounds.size.height);
                    break;
                default:
                    break;
            }
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
