//
//  CLRoundAnimationView.m
//  CLDemo
//
//  Created by AUG on 2019/3/7.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLRoundAnimationView.h"

@interface CLRoundAnimationView ()

///动画layer
@property (nonatomic, strong) CALayer *animationLayer;

@end


@implementation CLRoundAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        CAShapeLayer *backgroundShapeLayer = [self shapeLayerWithStrokeStart:0 strokeEnd:1];
        [self.layer setMask:backgroundShapeLayer];
        
        self.animationLayer = [CALayer layer];
        self.animationLayer.frame = self.layer.bounds;
        self.animationLayer.backgroundColor = [UIColor orangeColor].CGColor;
        CAShapeLayer *shapeLayer = [self shapeLayerWithStrokeStart:0 strokeEnd:0.2];
        [self.animationLayer setMask:shapeLayer];
        [self.layer addSublayer:self.animationLayer];
        //动画
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
        rotationAnimation.toValue = [NSNumber numberWithFloat:2.0 * M_PI];
        rotationAnimation.repeatCount = MAXFLOAT;
        rotationAnimation.duration = 0.8;
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.fillMode = kCAFillModeForwards;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [self.animationLayer addAnimation:rotationAnimation forKey:@"rotationAnnimation"];
    }
    return self;
}

- (CAShapeLayer *)shapeLayerWithStrokeStart:(CGFloat)strokeStart strokeEnd:(CGFloat)strokeEnd {
    //创建圆环
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.cl_width * 0.5, self.cl_height * 0.5) radius:(self.cl_height * 0.5 - 5) startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    //圆环遮罩
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.strokeStart = strokeStart;
    shapeLayer.strokeEnd = strokeEnd;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineDashPhase = 0.8;
    shapeLayer.path = bezierPath.CGPath;
    return shapeLayer;
}
@end
