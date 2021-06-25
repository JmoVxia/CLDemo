//
//  CLCustomTransitionAnimatedTransitioning.m
//  CLDemo
//
//  Created by AUG on 2019/8/31.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLCustomTransitionAnimatedTransitioning.h"
#import "CLCustomTransitionController.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


@interface CLCustomTransitionAnimatedTransitioning ()<CAAnimationDelegate>


@property (nonatomic, assign) CLAnimatedTransitionType animatedType;

@property (nonatomic, assign) NSTimeInterval animatedDuration;


@end


@implementation CLCustomTransitionAnimatedTransitioning

-(instancetype)initWithAnimatedType:(CLAnimatedTransitionType)type animatedDuration:(NSTimeInterval)duration {
    if (self = [super init]) {
        self.animatedType = type;
        self.animatedDuration = duration;
    }
    return self;
}

//MARK: - JmoVxia---UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning> __unused)transitionContext {
    return self.animatedDuration;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.animatedType == present) {
        [self presentAnimation:transitionContext];
    }else {
        [self dismissAnimation:transitionContext];
    }
}
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UINavigationController *navigationController = ((UITabBarController *)toVC).selectedViewController;
    CLCustomTransitionController *controller = [navigationController.childViewControllers lastObject];
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    [containerView addSubview:fromView];
    //画两个圆路径
    
    UIBezierPath *startCycle = [self arcPathWithRadius:15 edgeInsets:UIEdgeInsetsZero width:fromView.frame.size.width height:fromView.frame.size.height];
    
    UIBezierPath *endCycle =  [self roundPathWithCenter:controller.button.center radius:15];
    
    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor greenColor].CGColor;
    maskLayer.path = endCycle.CGPath;
    fromView.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];

    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];

    UINavigationController *navigationController = ((UITabBarController *)fromVC).selectedViewController;
    CLCustomTransitionController *controller = [navigationController.childViewControllers lastObject];
    //画两个圆路径
    UIBezierPath *startCycle =  [self roundPathWithCenter:controller.button.center radius:15];
    UIBezierPath *endCycle = [self arcPathWithRadius:15 edgeInsets:UIEdgeInsetsZero width:toView.frame.size.width height:toView.frame.size.height];
    
    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endCycle.CGPath;
    //将maskLayer作为toView的遮盖
    toView.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.delegate = self;
    //动画是加到layer上的，所以必须为CGPath，再将CGPath桥接为OC对象
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
    [transitionContext completeTransition:YES];
    [transitionContext viewForKey:UITransitionContextFromViewKey].layer.mask = nil;
    [transitionContext viewForKey:UITransitionContextToViewKey].layer.mask = nil;
}

/**
 创建圆路径

 @param center 中心点
 @param radius 半径
 @return 圆形路径
 */
- (UIBezierPath *)roundPathWithCenter:(CGPoint)center radius:(CGFloat)radius {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:center radius:15.0f startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(270) clockwise:true];
    [path addArcWithCenter:center radius:15.0f startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(360) clockwise:true];
    [path addArcWithCenter:center radius:15.0f startAngle:DEGREES_TO_RADIANS(360) endAngle:DEGREES_TO_RADIANS(90) clockwise:true];
    [path addArcWithCenter:center radius:15.0f startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(180) clockwise:true];
    [path closePath];
    return path;
}

/**
 创建圆角长方形路径

 @param radius 圆角半径
 @param edgeInsets 内边距
 @param width 长方形宽
 @param height 长方形高
 @return 圆角长方形路径
 */
- (UIBezierPath *)arcPathWithRadius:(CGFloat)radius edgeInsets:(UIEdgeInsets)edgeInsets width:(CGFloat)width height:(CGFloat)height {
    CGFloat topSpace = edgeInsets.top;
    CGFloat leftSpace = edgeInsets.left;
    CGFloat bottomSpace = edgeInsets.bottom;
    CGFloat rightSpace = edgeInsets.right;
    //创建path
    UIBezierPath *path = [UIBezierPath bezierPath];
    //左上圆角
    [path addArcWithCenter:CGPointMake(leftSpace + radius, topSpace + radius) radius:radius startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
    //右上圆角
    [path addArcWithCenter:CGPointMake(width - radius - rightSpace, radius + topSpace) radius:radius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(360) clockwise:YES];
    //右下圆角
    [path addArcWithCenter:CGPointMake(width - rightSpace - radius, height - radius - bottomSpace) radius:radius startAngle:DEGREES_TO_RADIANS(360) endAngle:DEGREES_TO_RADIANS(90) clockwise:YES];
    //左下圆角
    [path addArcWithCenter:CGPointMake(leftSpace + radius, height - radius - bottomSpace) radius:radius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(180) clockwise:YES];
    [path closePath];
    return path;
}



@end
