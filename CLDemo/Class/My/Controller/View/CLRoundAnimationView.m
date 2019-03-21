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
    return configure;
}

@end

@interface CLRoundAnimationView ()

///动画layer
@property (nonatomic, strong) CALayer *animationLayer;
///外圆
@property (nonatomic, strong) CAShapeLayer *backgroundShapeLayer;
///动画
@property (nonatomic, strong) CABasicAnimation *rotationAnimation;
///是否暂停
@property (nonatomic, assign) BOOL isPause;
///默认配置
@property (nonatomic, strong) CLRoundAnimationViewConfigure *configure;

@end


@implementation CLRoundAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.backgroundColor = self.configure.outBackgroundColor.CGColor;
        self.layer.mask = [self shapeLayerWithLineWidth:self.configure.outLineWidth strokeStart:0 strokeEnd:1];
        
        self.animationLayer = [CALayer layer];
        self.animationLayer.frame = self.layer.bounds;
        self.animationLayer.backgroundColor = self.configure.inBackgroundColor.CGColor;
        self.animationLayer.mask = [self shapeLayerWithLineWidth:self.configure.inLineWidth strokeStart:self.configure.strokeStart strokeEnd:self.configure.strokeEnd];
        [self.layer addSublayer:self.animationLayer];
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
    }
    return self;
}
- (CAShapeLayer *)shapeLayerWithLineWidth:(CGFloat)lineWidth strokeStart:(CGFloat)strokeStart strokeEnd:(CGFloat)strokeEnd {
    //创建圆环
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.cl_width * 0.5, self.cl_height * 0.5) radius:(self.cl_height - lineWidth) * 0.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
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
    self.layer.backgroundColor = self.configure.outBackgroundColor.CGColor;
    self.layer.mask = [self shapeLayerWithLineWidth:self.configure.outLineWidth strokeStart:0 strokeEnd:1];
    self.animationLayer.mask = [self shapeLayerWithLineWidth:self.configure.inLineWidth strokeStart:self.configure.strokeStart strokeEnd:self.configure.strokeEnd];
    self.animationLayer.backgroundColor = self.configure.inBackgroundColor.CGColor;
    self.rotationAnimation.duration = self.configure.duration;
}
- (void)startAnimation {
    [self.animationLayer addAnimation:self.rotationAnimation forKey:@"rotationAnnimation"];
}
- (void)stopAnimation {
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
