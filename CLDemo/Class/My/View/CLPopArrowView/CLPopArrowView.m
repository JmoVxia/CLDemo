//
//  CLPopArrowView.m
//  CLDemo
//
//  Created by AUG on 2019/4/21.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLPopArrowView.h"

@interface CLPopArrowView ()

@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CLArrowDirection direction;

@end


@implementation CLPopArrowView

-(instancetype)initWithOrigin:(CGPoint)origin width:(CGFloat)width Height:(float)height direction:(CLArrowDirection)direction
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)]) {
        self.backgroundColor = [UIColor clearColor];
        self.origin = origin;
        self.height = height;
        self.width = width;
        self.direction = direction;
        self.contentView = [[UIView alloc]initWithFrame:CGRectMake(origin.x, origin.y, width, height)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat startX = self.origin.x;
    CGFloat startY = self.origin.y;
    if (_direction == CLArrowDirectionLeftTop) {
        CGContextMoveToPoint(context, startX, startY);
        CGContextAddLineToPoint(context, startX + 5, startY - 5);
        CGContextAddLineToPoint(context, startX + 5, startY + 5);
    }else if (_direction == CLArrowDirectionLeftMiddle) {
        CGContextMoveToPoint(context, startX, startY);
        CGContextAddLineToPoint(context, startX + 5, startY - 5);
        CGContextAddLineToPoint(context, startX + 5, startY + 5);
    }else if (_direction == CLArrowDirectionLeftBottom) {
        CGContextMoveToPoint(context, startX, startY);
        CGContextAddLineToPoint(context, startX + 5, startY - 5);
        CGContextAddLineToPoint(context, startX + 5, startY + 5);
    }else if (_direction == CLArrowDirectionRightTop) {
        CGContextMoveToPoint(context, startX, startY);
        CGContextAddLineToPoint(context, startX - 5, startY - 5);
        CGContextAddLineToPoint(context, startX - 5, startY + 5);
    }else if (_direction == CLArrowDirectionRightMiddle) {
        CGContextMoveToPoint(context, startX, startY);
        CGContextAddLineToPoint(context, startX - 5, startY - 5);
        CGContextAddLineToPoint(context, startX - 5, startY + 5);
    }else if (_direction == CLArrowDirectionRightBottom) {
        CGContextMoveToPoint(context, startX, startY);
        CGContextAddLineToPoint(context, startX - 5, startY - 5);
        CGContextAddLineToPoint(context, startX - 5, startY + 5);
    }else if (_direction == CLArrowDirectionTopLeft) {
        CGContextMoveToPoint(context, startX, startY);
        CGContextAddLineToPoint(context, startX + 5, startY + 5);
        CGContextAddLineToPoint(context, startX -5, startY + 5);
    }else if (_direction == CLArrowDirectionTopMiddle) {
        CGContextMoveToPoint(context, startX, startY);
        CGContextAddLineToPoint(context, startX + 5, startY + 5);
        CGContextAddLineToPoint(context, startX - 5, startY + 5);
    }else if (_direction == CLArrowDirectionTopRight) {
        CGContextMoveToPoint(context, startX, startY);
        CGContextAddLineToPoint(context, startX + 5, startY + 5);
        CGContextAddLineToPoint(context, startX - 5, startY+ 5);
    }else if (_direction == CLArrowDirectionBottomLeft) {
        CGContextMoveToPoint(context, startX, startY);
        CGContextAddLineToPoint(context, startX - 5, startY - 5);
        CGContextAddLineToPoint(context, startX + 5, startY - 5);
    }else if (_direction == CLArrowDirectionBottomModdle) {
        CGContextMoveToPoint(context, startX, startY);
        CGContextAddLineToPoint(context, startX - 5, startY - 5);
        CGContextAddLineToPoint(context, startX + 5, startY - 5);
    }else if (_direction == CLArrowDirectionBottomRight) {
        CGContextMoveToPoint(context, startX, startY);
        CGContextAddLineToPoint(context, startX - 5, startY - 5);
        CGContextAddLineToPoint(context, startX + 5, startY - 5);
    }
    CGContextClosePath(context);
    [[UIColor redColor] setFill];
    [[UIColor orangeColor] setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.contentView]) {
        [self dismiss];
    }
}
-(void)popView
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    if (_direction==CLArrowDirectionLeftTop) {
        self.contentView.layer.anchorPoint = CGPointMake(0, 0);
        self.contentView.frame = CGRectMake(self.origin.x + 5, self.origin.y - 20, self.width,self. height);
        self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }else if (_direction==CLArrowDirectionLeftMiddle) {
        self.contentView.layer.anchorPoint = CGPointMake(0, 0.5);
        self.contentView.frame = CGRectMake(self.origin.x + 5, self.origin.y - self.height * 0.5, self.width,self. height);
        self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }else if (_direction==CLArrowDirectionLeftBottom) {
        self.contentView.layer.anchorPoint = CGPointMake(0, 1);
        self.contentView.frame = CGRectMake(self.origin.x + 5, self.origin.y - self.height + 20, self.width,self. height);
        self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }else if (_direction==CLArrowDirectionRightTop) {
        self.contentView.layer.anchorPoint = CGPointMake(1, 0);
        self.contentView.frame = CGRectMake(self.origin.x - 5, self.origin.y - 20, -self.width,self. height);
        self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }else if (_direction==CLArrowDirectionRightMiddle) {
        self.contentView.layer.anchorPoint = CGPointMake(1, 0.5);
        self.contentView.frame = CGRectMake(self.origin.x - 5, self.origin.y - self.height * 0.5, -self.width,self. height);
        self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }else if (_direction==CLArrowDirectionRightBottom) {
        self.contentView.layer.anchorPoint = CGPointMake(1, 1);
        self.contentView.frame = CGRectMake(self.origin.x - 5, self.origin.y - self.height + 20, -self.width,self. height);
        self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }else if (_direction==CLArrowDirectionTopLeft) {
        self.contentView.layer.anchorPoint = CGPointMake(0, 0);
        self.contentView.frame = CGRectMake(self.origin.x - 20, self.origin.y + 5, self.width,self. height);
        self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }else if (_direction==CLArrowDirectionTopMiddle) {
        self.contentView.layer.anchorPoint = CGPointMake(0.5, 0);
        self.contentView.frame = CGRectMake(self.origin.x - self.width * 0.5, self.origin.y + 5, self.width,self. height);
        self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }else if (_direction==CLArrowDirectionTopRight) {
        self.contentView.layer.anchorPoint = CGPointMake(1, 0);
        self.contentView.frame = CGRectMake(self.origin.x + 20, self.origin.y + 5, -self.width,self. height);
        self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }else if (_direction==CLArrowDirectionBottomLeft) {
        self.contentView.layer.anchorPoint = CGPointMake(0, 1);
        self.contentView.frame = CGRectMake(self.origin.x - 20, self.origin.y - 5, self.width,-self. height);
        self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }else if (_direction==CLArrowDirectionBottomModdle) {
        self.contentView.layer.anchorPoint = CGPointMake(0.5, 1);
        self.contentView.frame = CGRectMake(self.origin.x - self.width * 0.5, self.origin.y - 5, self.width,-self. height);
        self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }else if (_direction==CLArrowDirectionBottomRight) {
        self.contentView.layer.anchorPoint = CGPointMake(1, 1);
        self.contentView.frame = CGRectMake(self.origin.x - self.width + 20, self.origin.y - 5, self.width,-self. height);
        self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }
}

-(void)dismiss
{
    self.contentView.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.15, 0.15);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

@end
