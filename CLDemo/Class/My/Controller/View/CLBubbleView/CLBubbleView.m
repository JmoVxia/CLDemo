//
//  CLBubbleView.m
//  CLDemo
//
//  Created by AUG on 2019/3/18.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLBubbleView.h"

@interface CLBubbleView ()

///小圆
@property (nonatomic, strong) UIView *samllCircleView;
///绘制不规则图形layer
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
///父控件
@property (nonatomic, strong) UIView *fatherView;
///销毁block回掉
@property (nonatomic, copy) disappearBlock disappear;
///按钮消失的动画图片组
@property (nonatomic, strong) NSMutableArray *images;
///高
@property (nonatomic, assign) CGFloat height;
///宽
@property (nonatomic, assign) CGFloat width;
///第一次
@property (nonatomic, assign) BOOL isFristLayoutSubviews;

@end

@implementation CLBubbleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
//MARK:JmoVxia---set
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.samllCircleView.backgroundColor = backgroundColor;
}
-(void)setText:(NSString *)text{
    [super setText:text];
    self.textAlignment = NSTextAlignmentCenter;
    if ([text isEqualToString:@"0"]) {
        self.hidden = YES;
        self.samllCircleView.hidden = YES;
    }else {
        self.hidden = NO;
        self.samllCircleView.hidden = NO;
    }
}
//MARK:JmoVxia---创建UI
- (void)initUI {
    self.isFristLayoutSubviews = YES;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor redColor];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self addGestureRecognizer:panGestureRecognizer];
}
//MARK:JmoVxia---拖拽手势
- (void)panGestureRecognizer:(UIPanGestureRecognizer*)sender {
    UIView *window = [UIApplication sharedApplication].delegate.window;
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.fatherView = self.superview;
        CGRect frame = [self.superview convertRect:self.frame toView:window];
        self.frame = frame;
        CGRect samllCircleViewFrame = [self.superview convertRect:self.samllCircleView.frame toView:window];
        self.samllCircleView.frame = samllCircleViewFrame;
        [window addSubview:self];
        [window.layer insertSublayer:self.shapeLayer below:self.layer];
        [window insertSubview:self.samllCircleView belowSubview:self];
    }
    [self.layer removeAnimationForKey:@"shake"];
    CGPoint panPoint = [sender translationInView:self];
    CGPoint changeCenter = self.center;
    changeCenter.x += panPoint.x;
    changeCenter.y += panPoint.y;
    self.center = changeCenter;
    [sender setTranslation:CGPointZero inView:self];
    //两个圆的中心点之间的距离
    CGFloat dist = [self pointToPoitnDistanceWithPoint:self.center potintB:self.samllCircleView.center];
    if (dist < self.maxDistance) {
        //拖拽距离小于设置最大距离
        CGFloat cornerRadius = (self.height > self.width ? self.width / 2 : self.height / 2);
        CGFloat samllCrecleRadius = cornerRadius - dist / 10;
        _samllCircleView.bounds = CGRectMake(0, 0, samllCrecleRadius * (2 - 1.0), samllCrecleRadius * (2 - 1.0));
        _samllCircleView.layer.cornerRadius = _samllCircleView.bounds.size.width / 2;
        if (_samllCircleView.hidden == NO && dist > 0) {
            //画不规则矩形
            self.shapeLayer.path = [self pathWithBigCirCleView:self smallCirCleView:_samllCircleView].CGPath;
        }
    } else {
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
        self.samllCircleView.hidden = YES;
    }
    //拖拽结束
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGRect frame = [window convertRect:self.frame toView:self.fatherView];
        self.frame = frame;
        CGRect samllCircleViewFrame = [window convertRect:self.samllCircleView.frame toView:self.fatherView];
        self.samllCircleView.frame = samllCircleViewFrame;
        [self.fatherView addSubview:self];
        [self.fatherView.layer insertSublayer:self.shapeLayer below:self.layer];
        [self.fatherView insertSubview:self.samllCircleView belowSubview:self];
        if (dist > self.maxDistance) {
            [self destroy];
        } else {
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer = nil;
            if (self.samllCircleView.hidden == YES) {
                [self destroy];
            }
            else{
                self.samllCircleView.hidden = YES;
                //弹性动画
                [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.center = self.samllCircleView.center;
                } completion:^(BOOL finished) {
                    self.samllCircleView.hidden = NO;
                }];
            }
        }
    }
}
//MARK:JmoVxia---路径
- (UIBezierPath *)pathWithBigCirCleView:(UIView *)bigCirCleView  smallCirCleView:(UIView *)smallCirCleView {
    CGPoint bigCenter = bigCirCleView.center;
    CGFloat x2 = bigCenter.x;
    CGFloat y2 = bigCenter.y;
    CGFloat r2 = bigCirCleView.bounds.size.width / 2;
    
    CGPoint smallCenter = smallCirCleView.center;
    CGFloat x1 = smallCenter.x;
    CGFloat y1 = smallCenter.y;
    CGFloat r1 = smallCirCleView.bounds.size.width / 2;
    // 获取圆心距离
    CGFloat d = [self pointToPoitnDistanceWithPoint:self.samllCircleView.center potintB:self.center];
    CGFloat sinθ = (x2 - x1) / d;
    CGFloat cosθ = (y2 - y1) / d;
    // 坐标系基于父控件
    CGPoint pointA = CGPointMake(x1 - r1 * cosθ , y1 + r1 * sinθ);
    CGPoint pointB = CGPointMake(x1 + r1 * cosθ , y1 - r1 * sinθ);
    CGPoint pointC = CGPointMake(x2 + r2 * cosθ , y2 - r2 * sinθ);
    CGPoint pointD = CGPointMake(x2 - r2 * cosθ , y2 + r2 * sinθ);
    CGPoint pointO = CGPointMake(pointA.x + d / 2 * sinθ , pointA.y + d / 2 * cosθ);
    CGPoint pointP = CGPointMake(pointB.x + d / 2 * sinθ , pointB.y + d / 2 * cosθ);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // A
    [path moveToPoint:pointA];
    // AB
    [path addLineToPoint:pointB];
    // 绘制BC曲线
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    // CD
    [path addLineToPoint:pointD];
    // 绘制DA曲线
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    return path;
}
//MARK:JmoVxia---两个圆心之间的距离
- (CGFloat)pointToPoitnDistanceWithPoint:(CGPoint)pointA potintB:(CGPoint)pointB {
    CGFloat offestX = pointA.x - pointB.x;
    CGFloat offestY = pointA.y - pointB.y;
    CGFloat dist = sqrtf(offestX * offestX + offestY * offestY);
    return dist;
}
//MARK:JmoVxia---销毁控件
- (void)destroy {
    //播放销毁动画
    [self startDestroyAnimations];
    //移除控件
    [self removeFromSuperview];
    [self.samllCircleView removeFromSuperview];
    self.samllCircleView = nil;
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    if (self.disappear) {
        self.disappear();
        self.disappear = nil;
    }
}
//MARK:JmoVxia---销毁回掉
- (void)disappear:(disappearBlock)disappear {
    self.disappear = disappear;
}
//MARK:JmoVxia---消失动画
- (void)startDestroyAnimations {
    UIImageView *ainmImageView = [[UIImageView alloc] initWithFrame:self.frame];
    ainmImageView.animationImages = self.images;
    ainmImageView.animationRepeatCount = 1;
    ainmImageView.animationDuration = 0.5;
    [ainmImageView startAnimating];
    [self.superview addSubview:ainmImageView];
}
//MARK:JmoVxia---获取资源图片
- (UIImage *)getPictureWithName:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"CLBubbleView" ofType:@"bundle"]];
    NSString *path   = [bundle pathForResource:name ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}
//MARK:JmoVxia---懒加载
- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = self.backgroundColor.CGColor;
    }
    return _shapeLayer;
}
- (UIView *)samllCircleView {
    if (!_samllCircleView) {
        _samllCircleView = [[UIView alloc] init];
    }
    return _samllCircleView;
}
- (NSMutableArray *)images {
    if (_images == nil) {
        _images = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i++) {
            UIImage *image = [self getPictureWithName:[NSString stringWithFormat:@"disappear%ld",i]];
            [_images addObject:image];
        }
    }
    return _images;
}
//MARK:JmoVxia---布局
-(void)layoutSubviews{
    [super layoutSubviews];
    self.height = self.frame.size.height;
    self.width = self.frame.size.width;
    if (self.isFristLayoutSubviews) {
        CGFloat cornerRadius = (self.height > self.width ? self.width * 0.5 : self.height * 0.5);
        self.maxDistance = cornerRadius * 6;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = cornerRadius;
        CGRect samllCireleRect = CGRectMake(0, 0, cornerRadius * (2 - 1.0) , cornerRadius * (2 - 1.0));
        self.samllCircleView.bounds = samllCireleRect;
        self.samllCircleView.center = self.center;
        self.samllCircleView.layer.cornerRadius = self.samllCircleView.bounds.size.width * 0.5;
    }
    self.isFristLayoutSubviews = NO;
}
@end
