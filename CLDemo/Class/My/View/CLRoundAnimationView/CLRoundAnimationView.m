//
//  CLRoundAnimationView.m
//  CLDemo
//
//  Created by AUG on 2019/3/7.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLRoundAnimationView.h"

@interface CLRoundAnimationViewConfigure ()

@end

@implementation CLRoundAnimationViewConfigure

+ (instancetype)defaultConfigure {
    CLRoundAnimationViewConfigure *configure = [[CLRoundAnimationViewConfigure alloc] init];
    configure.outBackgroundColor = [UIColor lightGrayColor];
    configure.inBackgroundColor = [UIColor orangeColor];
    configure.strokeStart = 0;
    configure.strokeEnd = 0.2;
    configure.duration = 0.8;
    configure.outLineWidth = 5;
    configure.inLineWidth = 5;
    configure.position = AnimationOut;
    return configure;
}

@end

@interface CLRoundAnimationView ()

///背景
@property (nonatomic, strong) CALayer *backgroundLayer;
///动画layer
@property (nonatomic, strong) CALayer *animationLayer;
///动画
@property (nonatomic, strong) CABasicAnimation *rotationAnimation;
///是否暂停
@property (nonatomic, assign) BOOL isPause;
///默认配置
@property (nonatomic, strong) CLRoundAnimationViewConfigure *configure;

@end


@implementation CLRoundAnimationView

- (void)animation {
    self.backgroundLayer = [CALayer layer];
    self.backgroundLayer.frame = self.layer.bounds;
    self.backgroundLayer.backgroundColor = self.configure.outBackgroundColor.CGColor;
    self.backgroundLayer.mask = [self shapeLayerWithLineWidth:self.configure.outLineWidth strokeStart:0 strokeEnd:1 outLayer:YES];
    
    self.animationLayer = [CALayer layer];
    self.animationLayer.frame = self.layer.bounds;
    self.animationLayer.backgroundColor = self.configure.inBackgroundColor.CGColor;
    self.animationLayer.mask = [self shapeLayerWithLineWidth:self.configure.inLineWidth strokeStart:self.configure.strokeStart strokeEnd:self.configure.strokeEnd outLayer:NO];
    //动画
    self.rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    self.rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    self.rotationAnimation.toValue = [NSNumber numberWithFloat:2.0 * M_PI];
    self.rotationAnimation.repeatCount = MAXFLOAT;
    self.rotationAnimation.duration = self.configure.duration;
    self.rotationAnimation.removedOnCompletion = NO;
    self.rotationAnimation.autoreverses = NO;
    self.rotationAnimation.fillMode = kCAFillModeForwards;
    self.rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.animationLayer addAnimation:self.rotationAnimation forKey:@"rotationAnnimation"];
}
- (CAShapeLayer *)shapeLayerWithLineWidth:(CGFloat)lineWidth strokeStart:(CGFloat)strokeStart strokeEnd:(CGFloat)strokeEnd outLayer:(BOOL)outLayer {
    //创建圆环
    CGFloat offset;
    switch (self.configure.position) {
        case AnimationOut:
            offset = 0;
            break;
        case AnimationMiddle:
            offset = outLayer ? 0 : self.configure.outLineWidth - self.configure.inLineWidth;
            break;
        case AnimationIn:
            offset = outLayer ? 0 : (self.configure.outLineWidth - self.configure.inLineWidth) * 2;
            break;
    }
    CGFloat radius = (self.frame.size.height - lineWidth - offset) * 0.5;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5) radius: radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    //圆环遮罩
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.strokeStart = strokeStart;
    shapeLayer.strokeEnd = strokeEnd;
    shapeLayer.lineWidth = lineWidth;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineDashPhase = 0.8;
    shapeLayer.path = bezierPath.CGPath;
    return shapeLayer;
}
- (void)updateWithConfigure:(void(^)(CLRoundAnimationViewConfigure *configure))configBlock {
    if (configBlock) {
        configBlock(self.configure);
    }
    self.configure.inLineWidth = MIN(self.configure.inLineWidth, self.configure.outLineWidth);
    self.backgroundLayer.backgroundColor = self.configure.outBackgroundColor.CGColor;
    self.backgroundLayer.mask = [self shapeLayerWithLineWidth:self.configure.outLineWidth strokeStart:0 strokeEnd:1 outLayer:YES];
    self.animationLayer.mask = [self shapeLayerWithLineWidth:self.configure.inLineWidth strokeStart:self.configure.strokeStart strokeEnd:self.configure.strokeEnd outLayer:NO];
    self.animationLayer.backgroundColor = self.configure.inBackgroundColor.CGColor;
    self.rotationAnimation.duration = self.configure.duration;
}
- (void)startAnimation {
    [self animation];
    [self.layer addSublayer:self.backgroundLayer];
    [self.layer addSublayer:self.animationLayer];
}
- (void)stopAnimation {
    [self.backgroundLayer removeFromSuperlayer];
    [self.animationLayer removeFromSuperlayer];
    [self.animationLayer removeAllAnimations];
}
- (void)pauseAnimation {
    if (self.isPause) {
        return;
    }
    self.isPause = YES;
    CFTimeInterval time = [self.animationLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.animationLayer.speed = 0;
    self.animationLayer.timeOffset = time;
}
- (void)resumeAnimation {
    if (!self.isPause) {
        return;
    }
    self.isPause = NO;
    CFTimeInterval pausedTime = self.animationLayer.timeOffset;
    self.animationLayer.speed = 1;
    self.animationLayer.timeOffset = 0;
    self.animationLayer.beginTime = 0;
    CFTimeInterval timeSincePause = [self.animationLayer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.animationLayer.beginTime = timeSincePause;
}
- (CLRoundAnimationViewConfigure *) configure {
    if (_configure == nil) {
        _configure = [CLRoundAnimationViewConfigure defaultConfigure];
    }
    return _configure;
}
@end
