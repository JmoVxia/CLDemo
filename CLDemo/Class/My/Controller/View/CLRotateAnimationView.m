//
//  CLRotateAnimationView.m
//  CLDemo
//
//  Created by AUG on 2018/11/29.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import "CLRotateAnimationView.h"

@implementation CLRotateAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)createCircle:(float)startAngle andEndAngle:(float)endAngle {
    
    CGFloat origin_x = self.frame.size.width * 0.5;
    CGFloat origin_y = self.frame.size.height * 0.5;
    
    for (NSInteger i = 0; i < 5; i++) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor redColor].CGColor;
        layer.frame = CGRectMake(-500, -500, 6 - i, 6 - i);
        layer.cornerRadius = (6 - i) * 0.5;
        //创建运动的轨迹动画
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathAnimation.calculationMode = kCAAnimationPaced;
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.removedOnCompletion = NO;
        pathAnimation.duration = 1.5;
        pathAnimation.beginTime = i * 0.1;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        UIBezierPath *arc = [UIBezierPath bezierPathWithArcCenter:CGPointMake(origin_x, origin_y) radius:20 startAngle:startAngle endAngle:endAngle  clockwise:YES];
        pathAnimation.path = arc.CGPath;
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[pathAnimation];
        group.duration = 2;
        group.removedOnCompletion = NO;
        group.fillMode = kCAFillModeForwards;
        group.repeatCount = INTMAX_MAX;
        //设置运转的动画
        [layer addAnimation:group forKey:@"moveTheCircleOne"];
        [self.layer addSublayer:layer];
    }
}

@end
