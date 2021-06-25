//
//  CLCustomTransitionAnimatedTransitioning.h
//  CLDemo
//
//  Created by AUG on 2019/8/31.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLTransitionEnum.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLCustomTransitionAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

-(instancetype)initWithAnimatedType:(CLAnimatedTransitionType)type animatedDuration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
