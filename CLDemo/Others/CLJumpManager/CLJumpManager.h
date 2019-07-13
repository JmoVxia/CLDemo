//
//  CLJumpManager.h
//  Potato
//
//  Created by AUG on 2019/1/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AnimationType) {
    AnimationTypeBottom,///<底部退出
    AnimationTypeLeft,///<左侧退出
    AnimationTypeNone,  ///<没有动画
};

@interface CLJumpManager : NSObject

///动画返回到根控制器
+ (void)backToRootViewControllerAnimation:(AnimationType)type belongView:(UIView *)view;
///返回跟控制器
+ (void)backToRootViewControllerBelongView:(UIView *)view;
///根控制器
+ (UIViewController *)rootViewController;
///顶部控制器
+ (UIViewController *)topViewController;

@end

NS_ASSUME_NONNULL_END
