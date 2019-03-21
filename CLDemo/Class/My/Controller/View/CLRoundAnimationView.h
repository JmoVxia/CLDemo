//
//  CLRoundAnimationView.h
//  CLDemo
//
//  Created by AUG on 2019/3/7.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface CLRoundAnimationViewConfigure : NSObject

///外圆背景色
@property (nonatomic, strong) UIColor *outBackgroundColor;
///内圆背景色
@property (nonatomic, strong) UIColor *inBackgroundColor;
///外圆线宽
@property (nonatomic, assign) CGFloat outLineWidth;
///内圆线宽
@property (nonatomic, assign) CGFloat inLineWidth;
///开始起点
@property (nonatomic, assign) CGFloat strokeStart;
///开始结束点
@property (nonatomic, assign) CGFloat strokeEnd;
///动画时间
@property (nonatomic, assign) CFTimeInterval duration;

@end


@interface CLRoundAnimationView : UIView

/**
 开始动画
 */
- (void)startAnimation;

/**
 停止动画
 */
- (void)stopAnimation;


/**
 暂停动画
 */
- (void)pauseAnimation;


/**
 恢复动画
 */
- (void)resumeAnimation;


/**更新基本配置，block不会造成循环引用*/
- (void)updateWithConfigure:(void(^)(CLRoundAnimationViewConfigure *configure))configBlock;


@end

NS_ASSUME_NONNULL_END
