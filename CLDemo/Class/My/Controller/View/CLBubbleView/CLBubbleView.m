//
//  CLBubbleView.m
//  CLDemo
//
//  Created by AUG on 2019/3/18.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLBubbleView.h"

@interface CLBubbleView ()

/**小圆*/
@property (nonatomic, strong) UIView *samllCircleView;
/**绘制不规则图形*/
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
/**superView*/
@property (nonatomic,strong) UIView *superView;
/**disappearBlock*/
@property (nonatomic,copy) disappearBlock disappear;
/** 按钮消失的动画图片组 */
@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation CLBubbleView
- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView
{
    if (self = [super initWithFrame:frame]) {
        
        self.superView = superView;
        
        [self initUI];
    }
    
    return self;
}

#pragma mark - 懒加载
- (CAShapeLayer *)shapeLayer
{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = self.backgroundColor.CGColor;
        [self.superView.layer insertSublayer:_shapeLayer below:self.layer];
    }
    
    return _shapeLayer;
}

- (UIView *)samllCircleView
{
    if (!_samllCircleView) {
        _samllCircleView = [[UIView alloc] init];
        [self.superView insertSubview:_samllCircleView belowSubview:self];
    }
    
    return _samllCircleView;
}

- (NSMutableArray *)images
{
    if (_images == nil) {
        _images = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i++) {
            UIImage *image = [self getPictureWithName:[NSString stringWithFormat:@"disappear%ld",i]];
            [_images addObject:image];
        }
    }
    
    return _images;
}
- (void)initUI
{
    CGFloat cornerRadius = (self.frame.size.height > self.frame.size.width ? self.frame.size.width / 2.0 : self.frame.size.height / 2.0);
    
    _maxDistance = cornerRadius * 4;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backgroundColor = [UIColor redColor];
    CGRect samllCireleRect = CGRectMake(0, 0, cornerRadius * (2 - 1.0) , cornerRadius * (2 - 1.0));
    self.samllCircleView.bounds = samllCireleRect;
    _samllCircleView.center = self.center;
    _samllCircleView.layer.cornerRadius = _samllCircleView.bounds.size.width / 2.0;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
    [self addGestureRecognizer:pan];
}

#pragma mark - 拖拽手势
- (void)drag:(UIPanGestureRecognizer *)pan
{
    [self.layer removeAnimationForKey:@"shake"];
    
    CGPoint panPoint = [pan translationInView:self];
    
    CGPoint changeCenter = self.center;
    changeCenter.x += panPoint.x;
    changeCenter.y += panPoint.y;
    self.center = changeCenter;
    [pan setTranslation:CGPointZero inView:self];
    
    //俩个圆的中心点之间的距离
    CGFloat dist = [self pointToPoitnDistanceWithPoint:self.center potintB:self.samllCircleView.center];
    
    if (dist < _maxDistance) {
        //拖拽距离小于设置最大距离
        CGFloat cornerRadius = (self.frame.size.height > self.frame.size.width ? self.frame.size.width / 2 : self.frame.size.height / 2);
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
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        if (dist > _maxDistance) {
            
            //销毁全部控件
            [self killAll];
            
        } else {
            
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer = nil;
            
            if (self.samllCircleView.hidden == YES) {
                //隐藏代表已经被拉出去过（包括被拉出去又回来的情况）
                //销毁全部控件
                [self killAll];
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

#pragma mark - 俩个圆心之间的距离
- (CGFloat)pointToPoitnDistanceWithPoint:(CGPoint)pointA potintB:(CGPoint)pointB
{
    CGFloat offestX = pointA.x - pointB.x;
    CGFloat offestY = pointA.y - pointB.y;
    CGFloat dist = sqrtf(offestX * offestX + offestY * offestY);
    return dist;
}
#pragma mark - 销毁控件
- (void)killAll
{
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
    }
}
- (void)disappear:(disappearBlock)disappear {
    self.disappear = disappear;
}
#pragma mark - 不规则路径
- (UIBezierPath *)pathWithBigCirCleView:(UIView *)bigCirCleView  smallCirCleView:(UIView *)smallCirCleView
{
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
#pragma mark - 消失动画
- (void)startDestroyAnimations
{
    UIImageView *ainmImageView = [[UIImageView alloc] initWithFrame:self.frame];
    ainmImageView.animationImages = self.images;
    ainmImageView.animationRepeatCount = 1;
    ainmImageView.animationDuration = 0.5;
    [ainmImageView startAnimating];
    
    [self.superview addSubview:ainmImageView];
}
#pragma mark - 获取资源图片
- (UIImage *)getPictureWithName:(NSString *)name
{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"CLBubbleView" ofType:@"bundle"]];
    NSString *path   = [bundle pathForResource:name ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}

#pragma mark - 文字
-(void)setText:(NSString *)text{
    _text = text;
    [self setTitle:text forState:UIControlStateNormal];
}
#pragma 文字颜色
-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    [self setTitleColor:textColor forState:UIControlStateNormal];
}
#pragma mark - 字体大小
-(void)setTextFont:(UIFont *)textFont{
    _textFont = textFont;
    [self.titleLabel setFont:textFont];
}
#pragma mark - 布局
-(void)layoutSubviews{
    [super layoutSubviews];
    //在这里设置颜色是因为这里才能够取得self的颜色
    _samllCircleView.backgroundColor = self.backgroundColor;
    if ([_text isEqualToString:@"0"]) {
        self.hidden = YES;
        self.samllCircleView.hidden = YES;
    }
    else{
        self.hidden = NO;
        self.samllCircleView.hidden = NO;
    }
}
@end
