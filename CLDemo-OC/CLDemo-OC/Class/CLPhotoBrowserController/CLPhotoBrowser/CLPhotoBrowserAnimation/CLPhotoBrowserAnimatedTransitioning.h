//
//  CLPhotoBrowserAnimatedTransitioning.h
//  Potato
//
//  Created by AUG on 2019/6/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CLAnimatedTransitionType) {
    present,
    dismiss,
};


@interface CLPhotoBrowserAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

/**
 初始化方法

 @param type 动画类型
 @param duration 动画时间
 */
-(instancetype)initWithAnimatedType:(CLAnimatedTransitionType)type animatedDuration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
