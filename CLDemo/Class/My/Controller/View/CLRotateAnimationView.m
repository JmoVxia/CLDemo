//
//  CLRotateAnimationView.m
//  CLDemo
//
//  Created by AUG on 2018/11/29.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import "CLRotateAnimationView.h"

@implementation CLRotateAnimationViewConfigure

+ (instancetype)defaultConfigure {
    CLRotateAnimationViewConfigure *configure = [[CLRotateAnimationViewConfigure alloc] init];
    configure.startAngle = - M_PI_2;
    configure.endAngle = M_PI + M_PI_2;
    configure.number = 5;
    configure.intervalDuration = 0.12;
    configure.duration = 2;
    configure.diameter = 8;
    return configure;
}

@end

@interface CLRotateAnimationView ()

///默认配置
@property (nonatomic, strong) CLRotateAnimationViewConfigure *configure;
///是否暂停
@property (nonatomic, assign) BOOL isPause;
///layer数组
@property (nonatomic, strong) NSMutableArray<CALayer *> *layerArray;

@end

@implementation CLRotateAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layerArray = [NSMutableArray array];
    }
    return self;
}
- (void)initLayer {
    CGFloat origin_x = self.frame.size.width * 0.5;
    CGFloat origin_y = self.frame.size.height * 0.5;
    for (NSInteger i = 0; i < self.configure.number; i++) {
        CGFloat scale = (CGFloat)(self.configure.number + 1 - i) / (CGFloat)(self.configure.number + 1);
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = self.configure.backgroundColor.CGColor;
        layer.frame = CGRectMake(-500, -500, scale * self.configure.diameter, scale * self.configure.diameter);
        layer.cornerRadius = scale * self.configure.diameter * 0.5;
        //创建运动的轨迹动画
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathAnimation.calculationMode = kCAAnimationPaced;
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.removedOnCompletion = NO;
        pathAnimation.duration = self.configure.duration - self.configure.intervalDuration * self.configure.number;
        pathAnimation.beginTime = i * self.configure.intervalDuration;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        UIBezierPath *arc = [UIBezierPath bezierPathWithArcCenter:CGPointMake(origin_x, origin_y) radius:(self.frame.size.width - self.configure.diameter) * 0.5 startAngle:self.configure.startAngle endAngle:self.configure.endAngle  clockwise:YES];
        pathAnimation.path = arc.CGPath;
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[pathAnimation];
        group.duration = self.configure.duration;
        group.removedOnCompletion = NO;
        group.fillMode = kCAFillModeForwards;
        group.repeatCount = INTMAX_MAX;
        //设置运转的动画
        [layer addAnimation:group forKey:@"moveTheCircleOne"];
        [self.layerArray addObject:layer];
    }
}
//MARK:JmoVxia---更新配置
- (void)updateWithConfigure:(void(^)(CLRotateAnimationViewConfigure *configure))configBlock {
    if (configBlock) {
        configBlock(self.configure);
    }
    CGFloat intervalDuration = (CGFloat)(self.configure.duration / 2.0 / (CGFloat)self.configure.number);
    self.configure.intervalDuration = MIN(self.configure.intervalDuration, intervalDuration);
    [self stopAnimation];
    [self initLayer];
}
//MARK:JmoVxia---开始动画
- (void)startAnimation {
    [self initLayer];
    for (CALayer *layer in self.layerArray) {
        [self.layer addSublayer:layer];
    }
}
//MARK:JmoVxia---结束动画
- (void)stopAnimation {
    for (CALayer *layer in self.layerArray) {
        [layer removeFromSuperlayer];
    }
    [self.layerArray removeAllObjects];
}
//MARK:JmoVxia---暂停动画
- (void)pauseAnimation {
    if (self.isPause) {
        return;
    }
    self.isPause = YES;
    CFTimeInterval time = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0;
    self.layer.timeOffset = time;
}
//MARK:JmoVxia---恢复动画
- (void)resumeAnimation {
    if (!self.isPause) {
        return;
    }
    self.isPause = NO;
    CFTimeInterval pausedTime = self.layer.timeOffset;
    self.layer.speed = 1;
    self.layer.timeOffset = 0;
    self.layer.beginTime = 0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
}
- (CLRotateAnimationViewConfigure *) configure {
    if (_configure == nil) {
        _configure = [CLRotateAnimationViewConfigure defaultConfigure];
    }
    return _configure;
}
@end
