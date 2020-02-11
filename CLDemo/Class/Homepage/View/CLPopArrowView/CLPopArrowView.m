//
//  CLPopArrowView.m
//  CLDemo
//
//  Created by AUG on 2019/4/21.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLPopArrowView.h"
#import "UIColor+CLHex.h"

@interface CLPopArrowView ()

@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CLArrowDirection direction;

///shapeLayer
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

///animation
@property (nonatomic, strong) CABasicAnimation *animation;

@property (nonatomic, strong) UIView *contentView;

@end


@implementation CLPopArrowView

-(instancetype)initWithOrigin:(CGPoint)origin width:(CGFloat)width Height:(float)height direction:(CLArrowDirection)direction {
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)]) {
        [self addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        self.backgroundColor = [UIColor clearColor];
        self.origin = origin;
        self.height = height;
        self.width = width;
        self.direction = direction;
    }
    return self;
}
-(void)popView {
    CGFloat spaceWidth = 10;
    CGFloat marginWidth = 20;
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    //主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_direction == CLArrowDirectionLeftTop) {
            self.contentView.layer.anchorPoint = CGPointMake(0, 0);
            self.contentView.frame = CGRectMake(self.origin.x + spaceWidth, self.origin.y - marginWidth, self.width,self.height);
            self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            [UIView animateWithDuration:0.2 animations:^{
                self.contentView.transform = CGAffineTransformMakeScale(1, 1);
            }completion:^(BOOL __unused finished) {
                self.shapeLayer.path = [self shapeLayerPath];
                [self.shapeLayer addAnimation:self.animation forKey:@"shapeLayerAnimation"];
            }];
        }else if (self->_direction == CLArrowDirectionLeftMiddle) {
            self.contentView.layer.anchorPoint = CGPointMake(0, 0.5);
            self.contentView.frame = CGRectMake(self.origin.x + spaceWidth, self.origin.y - self.height * 0.5, self.width,self.height);
            self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            [UIView animateWithDuration:0.2 animations:^{
                self.contentView.transform = CGAffineTransformMakeScale(1, 1);
            }completion:^(BOOL __unused finished) {
                self.shapeLayer.path = [self shapeLayerPath];
                [self.shapeLayer addAnimation:self.animation forKey:@"shapeLayerAnimation"];
            }];
        }else if (self->_direction == CLArrowDirectionLeftBottom) {
            self.contentView.layer.anchorPoint = CGPointMake(0, 1);
            self.contentView.frame = CGRectMake(self.origin.x + spaceWidth, self.origin.y - self.height + marginWidth, self.width,self.height);
            self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            [UIView animateWithDuration:0.2 animations:^{
                self.contentView.transform = CGAffineTransformMakeScale(1, 1);
            }completion:^(BOOL __unused finished) {
                self.shapeLayer.path = [self shapeLayerPath];
                [self.shapeLayer addAnimation:self.animation forKey:@"shapeLayerAnimation"];
            }];
        }else if (self->_direction == CLArrowDirectionRightTop) {
            self.contentView.layer.anchorPoint = CGPointMake(1, 0);
            self.contentView.frame = CGRectMake(self.origin.x - spaceWidth, self.origin.y - marginWidth, -self.width,self.height);
            self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            [UIView animateWithDuration:0.2 animations:^{
                self.contentView.transform = CGAffineTransformMakeScale(1, 1);
            }completion:^(BOOL __unused finished) {
                self.shapeLayer.path = [self shapeLayerPath];
                [self.shapeLayer addAnimation:self.animation forKey:@"shapeLayerAnimation"];
            }];
        }else if (self->_direction == CLArrowDirectionRightMiddle) {
            self.contentView.layer.anchorPoint = CGPointMake(1, 0.5);
            self.contentView.frame = CGRectMake(self.origin.x - spaceWidth, self.origin.y - self.height * 0.5, -self.width,self.height);
            self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            [UIView animateWithDuration:0.2 animations:^{
                self.contentView.transform = CGAffineTransformMakeScale(1, 1);
            }completion:^(BOOL __unused finished) {
                self.shapeLayer.path = [self shapeLayerPath];
                [self.shapeLayer addAnimation:self.animation forKey:@"shapeLayerAnimation"];
            }];
        }else if (self->_direction == CLArrowDirectionRightBottom) {
            self.contentView.layer.anchorPoint = CGPointMake(1, 1);
            self.contentView.frame = CGRectMake(self.origin.x - spaceWidth, self.origin.y - self.height + marginWidth, -self.width,self.height);
            self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            [UIView animateWithDuration:0.2 animations:^{
                self.contentView.transform = CGAffineTransformMakeScale(1, 1);
            }completion:^(BOOL __unused finished) {
                self.shapeLayer.path = [self shapeLayerPath];
                [self.shapeLayer addAnimation:self.animation forKey:@"shapeLayerAnimation"];
            }];
        }else if (self->_direction == CLArrowDirectionTopLeft) {
            self.contentView.layer.anchorPoint = CGPointMake(0, 0);
            self.contentView.frame = CGRectMake(self.origin.x - marginWidth, self.origin.y + spaceWidth, self.width,self.height);
            self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            [UIView animateWithDuration:0.2 animations:^{
                self.contentView.transform = CGAffineTransformMakeScale(1, 1);
            }completion:^(BOOL __unused finished) {
                self.shapeLayer.path = [self shapeLayerPath];
                [self.shapeLayer addAnimation:self.animation forKey:@"shapeLayerAnimation"];
            }];
        }else if (self->_direction == CLArrowDirectionTopMiddle) {
            self.contentView.layer.anchorPoint = CGPointMake(0.5, 0);
            self.contentView.frame = CGRectMake(self.origin.x - self.width * 0.5, self.origin.y + spaceWidth, self.width,self.height);
            self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            [UIView animateWithDuration:0.2 animations:^{
                self.contentView.transform = CGAffineTransformMakeScale(1, 1);
            }completion:^(BOOL __unused finished) {
                self.shapeLayer.path = [self shapeLayerPath];
                [self.shapeLayer addAnimation:self.animation forKey:@"shapeLayerAnimation"];\
            }];
        }else if (self->_direction == CLArrowDirectionTopRight) {
            self.contentView.layer.anchorPoint = CGPointMake(1, 0);
            self.contentView.frame = CGRectMake(self.origin.x + marginWidth, self.origin.y + spaceWidth, -self.width,self.height);
            self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            [UIView animateWithDuration:0.2 animations:^{
                self.contentView.transform = CGAffineTransformMakeScale(1, 1);
            }completion:^(BOOL __unused finished) {
                self.shapeLayer.path = [self shapeLayerPath];
                [self.shapeLayer addAnimation:self.animation forKey:@"shapeLayerAnimation"];
            }];
        }else if (self->_direction == CLArrowDirectionBottomLeft) {
            self.contentView.layer.anchorPoint = CGPointMake(0, 1);
            self.contentView.frame = CGRectMake(self.origin.x - marginWidth, self.origin.y - spaceWidth, self.width,-self.height);
            self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            [UIView animateWithDuration:0.2 animations:^{
                self.contentView.transform = CGAffineTransformMakeScale(1, 1);
            }completion:^(BOOL __unused finished) {
                self.shapeLayer.path = [self shapeLayerPath];
                [self.shapeLayer addAnimation:self.animation forKey:@"shapeLayerAnimation"];
            }];
        }else if (self->_direction == CLArrowDirectionBottomMiddle) {
            self.contentView.layer.anchorPoint = CGPointMake(0.5, 1);
            self.contentView.frame = CGRectMake(self.origin.x - self.width * 0.5, self.origin.y - spaceWidth, self.width,-self.height);
            self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            [UIView animateWithDuration:0.2 animations:^{
                self.contentView.transform = CGAffineTransformMakeScale(1, 1);
            }completion:^(BOOL __unused finished) {
                self.shapeLayer.path = [self shapeLayerPath];
                [self.shapeLayer addAnimation:self.animation forKey:@"shapeLayerAnimation"];
            }];
        }else if (self->_direction == CLArrowDirectionBottomRight) {
            self.contentView.layer.anchorPoint = CGPointMake(1, 1);
            self.contentView.frame = CGRectMake(self.origin.x - self.width + marginWidth, self.origin.y - spaceWidth, self.width,-self.height);
            self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            [UIView animateWithDuration:0.2 animations:^{
                self.contentView.transform = CGAffineTransformMakeScale(1, 1);
            }completion:^(BOOL __unused finished) {
                self.shapeLayer.path = [self shapeLayerPath];
                [self.shapeLayer addAnimation:self.animation forKey:@"shapeLayerAnimation"];
            }];
        }
    });
}
-(void)dismiss:(nullable void (^)(void)) completion {
    //主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        [self.shapeLayer removeFromSuperlayer];
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(0, 0);
        } completion:^(BOOL __unused finished) {
            [self removeFromSuperview];
            if (completion) {
                completion();
            }
        }];
    });
}
- (void)tapAction {
    [self dismiss:nil];
}
- (CGPathRef)shapeLayerPath {
    CGFloat spaceWidth = 10;
    
    CGFloat startX = CGRectGetMinX(self.contentView.frame);
    CGFloat startY = CGRectGetMinY(self.contentView.frame);
    
    CGFloat width = CGRectGetWidth(self.contentView.frame);
    CGFloat height = CGRectGetHeight(self.contentView.frame);
    
    CGPoint point1 = CGPointZero;
    CGPoint point2 = CGPointZero;
    CGPoint point3 = CGPointZero;
    CGPoint point4 = CGPointZero;
    CGPoint point5 = CGPointZero;
    CGPoint point6 = CGPointZero;
    CGPoint point7 = CGPointZero;
    CGPoint point8 = CGPointZero;
    
    if (_direction == CLArrowDirectionLeftTop || _direction == CLArrowDirectionLeftMiddle || _direction == CLArrowDirectionLeftBottom) {
        point1 = CGPointMake(self.origin.x, self.origin.y);
        point2 = CGPointMake(self.origin.x + spaceWidth, self.origin.y - spaceWidth);
        point3 = CGPointMake(startX, startY);
        point4 = CGPointMake(startX + width, startY);
        point5 = CGPointMake(startX + width, startY + height);
        point6 = CGPointMake(startX, startY + height);
        point7 = CGPointMake(startX, self.origin.y + spaceWidth);
        point8 = CGPointMake(self.origin.x, self.origin.y);
    }else if (_direction == CLArrowDirectionRightTop || _direction == CLArrowDirectionRightMiddle || _direction == CLArrowDirectionRightBottom) {
        point1 = CGPointMake(self.origin.x, self.origin.y);
        point2 = CGPointMake(self.origin.x - spaceWidth, self.origin.y - spaceWidth);
        point3 = CGPointMake(startX + width, startY);
        point4 = CGPointMake(startX, startY);
        point5 = CGPointMake(startX, startY + height);
        point6 = CGPointMake(startX + width, startY + height);
        point7 = CGPointMake(startX + width, self.origin.y + spaceWidth);
        point8 = CGPointMake(self.origin.x, self.origin.y);
    }else if (_direction == CLArrowDirectionTopMiddle || _direction == CLArrowDirectionTopRight || _direction == CLArrowDirectionTopLeft) {
        point1 = CGPointMake(startX, startY);
        point2 = CGPointMake(self.origin.x - spaceWidth, startY);
        point3 = CGPointMake(self.origin.x, self.origin.y);
        point4 = CGPointMake(self.origin.x + spaceWidth, startY);
        point5 = CGPointMake(startX + width, startY);
        point6 = CGPointMake(startX + width, startY + height);
        point7 = CGPointMake(startX, startY + height);
        point8 = CGPointMake(startX, startY);
    }else if (_direction == CLArrowDirectionBottomRight || _direction == CLArrowDirectionBottomLeft || _direction == CLArrowDirectionBottomMiddle) {
        point1 = CGPointMake(startX + width, startY + height);
        point2 = CGPointMake(self.origin.x - spaceWidth, startY + height);
        point3 = CGPointMake(self.origin.x, self.origin.y);
        point4 = CGPointMake(self.origin.x + spaceWidth, startY + height);
        point5 = CGPointMake(startX, startY + height);
        point6 = CGPointMake(startX, startY);
        point7 = CGPointMake(startX + width, startY);
        point8 = CGPointMake(startX + width, startY + height);
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path addLineToPoint:point4];
    [path addLineToPoint:point5];
    [path addLineToPoint:point6];
    [path addLineToPoint:point7];
    [path addLineToPoint:point8];
    [path closePath];
    return path.CGPath;
}
- (UIView *) contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(self.origin.x, self.origin.y, self.width, self.height)];
        _contentView.autoresizesSubviews = YES;
        _contentView.clipsToBounds = YES;
        [self addSubview:_contentView];
    }
    return _contentView;
}
- (CAShapeLayer *) shapeLayer {
    if (_shapeLayer == nil) {
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.frame = self.frame;
        _shapeLayer.strokeColor = [UIColor colorWithRGBHex:0xb2b2b2].CGColor;
        _shapeLayer.fillColor = self.contentView.backgroundColor.CGColor;
        _shapeLayer.lineWidth = 0.5;
        [self.layer addSublayer:_shapeLayer];
        [self.layer insertSublayer:_shapeLayer below:self.contentView.layer];
    }
    return _shapeLayer;
}

- (CABasicAnimation *) animation {
    if (_animation == nil) {
        _animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _animation.duration = 0.2;
        _animation.removedOnCompletion = YES;
        _animation.fromValue = @(0.3);
        _animation.toValue = @(1);
    }
    return _animation;
}
@end
