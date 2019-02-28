//
//  CLJumpManager.h
//  Potato
//
//  Created by AUG on 2019/1/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AnimationType) {
    AnimationTypeBottom,
    AnimationTypeLeft,
};

@interface CLJumpManager : NSObject

///动画返回到根控制器
+ (void)backToRootViewControllerAnimation:(AnimationType)type;
///返回跟控制器
+ (void)backToRootViewController;
///根控制器
+ (UIViewController *)rootViewController;
///顶部控制器
+ (UIViewController *)topViewController;
///显示的控制器
+ (UIViewController *)visibleViewController;

@end

NS_ASSUME_NONNULL_END
