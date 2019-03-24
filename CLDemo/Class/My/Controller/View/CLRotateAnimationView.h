//
//  CLRotateAnimationView.h
//  CLDemo
//
//  Created by AUG on 2018/11/29.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface CLRotateAnimationViewConfigure : NSObject

///开始起点
@property (nonatomic, assign) CGFloat startAngle;
///开始结束点
@property (nonatomic, assign) CGFloat endAngle;
///动画总时间
@property (nonatomic, assign) CFTimeInterval duration;
///动画间隔时间
@property (nonatomic, assign) CFTimeInterval intervalDuration;
///小球个数
@property (nonatomic, assign) NSInteger number;
///小球直径
@property (nonatomic, assign) CGFloat diameter;
///小球背景颜色
@property (nonatomic, strong) UIColor *backgroundColor;

@end


@interface CLRotateAnimationView : UIView

///开始动画
- (void)startAnimation;
///停止动画
- (void)stopAnimation;
///暂停动画
- (void)pauseAnimation;
///恢复动画
- (void)resumeAnimation;
///更新配置
- (void)updateWithConfigure:(void(^)(CLRotateAnimationViewConfigure *configure))configBlock;

@end

NS_ASSUME_NONNULL_END
