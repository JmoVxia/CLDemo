//
//  CLAnimatedTransitioning.h
//  CLDemo
//
//  Created by AUG on 2019/7/19.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLTransitionEnum.h"
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface CLAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

/**
 初始化方法
 
 @param type 动画类型
 @param duration 动画时间
 */
-(instancetype)initWithAnimatedType:(CLAnimatedTransitionType)type animatedDuration:(NSTimeInterval)duration direction:(CLInteractiveCoverDirection)direction;

@end

NS_ASSUME_NONNULL_END
