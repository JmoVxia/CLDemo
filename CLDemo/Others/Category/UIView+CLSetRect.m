//
//  UIView+SetRect.m
//  UIView
//
//  Created by JmoVxia on 2016/10/27.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "UIView+CLSetRect.h"

@implementation UIView (CLSetRect)

- (CGPoint)CLviewOrigin {
    
    return self.frame.origin;
}

- (void)setCLviewOrigin:(CGPoint)CLviewOrigin {
    
    CGRect newFrame = self.frame;
    newFrame.origin = CLviewOrigin;
    self.frame      = newFrame;
}

- (CGSize)CLviewSize {
    
    return self.frame.size;
}

- (void)setCLviewSize:(CGSize)CLviewSize {
    
    CGRect newFrame = self.frame;
    newFrame.size   = CLviewSize;
    self.frame      = newFrame;
}

- (CGFloat)CLx {
    
    return self.frame.origin.x;
}

- (void)setCLx:(CGFloat)CLx {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.x = CLx;
    self.frame        = newFrame;
}

- (CGFloat)CLy {
    
    return self.frame.origin.y;
}

- (void)setCLy:(CGFloat)CLy {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.y = CLy;
    self.frame        = newFrame;
}

- (CGFloat)CLwidth {
    
    return CGRectGetWidth(self.bounds);
}

- (void)setCLwidth:(CGFloat)CLwidth {
    
    CGRect newFrame     = self.frame;
    newFrame.size.width = CLwidth;
    self.frame          = newFrame;
}

- (CGFloat)CLheight {
    
    return CGRectGetHeight(self.bounds);
}

- (void)setCLheight:(CGFloat)CLheight {
    
    CGRect newFrame      = self.frame;
    newFrame.size.height = CLheight;
    self.frame           = newFrame;
}

- (CGFloat)CLtop {
    
    return self.frame.origin.y;
}

- (void)setCLtop:(CGFloat)CLtop {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.y = CLtop;
    self.frame        = newFrame;
}

- (CGFloat)CLbottom {
    
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setCLbottom:(CGFloat)CLbottom {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.y = CLbottom - self.frame.size.height;
    self.frame        = newFrame;
}

- (CGFloat)CLleft {
    
    return self.frame.origin.x;
}

- (void)setCLleft:(CGFloat)CLleft {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.x = CLleft;
    self.frame        = newFrame;
}

- (CGFloat)CLright {
    
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setCLright:(CGFloat)CLright {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.x = CLright - self.frame.size.width;
    self.frame        = newFrame;
}

- (CGFloat)CLcenterX {
    
    return self.center.x;
}

- (void)setCLcenterX:(CGFloat)CLcenterX {
    
    CGPoint newCenter = self.center;
    newCenter.x       = CLcenterX;
    self.center       = newCenter;
}

- (CGFloat)CLcenterY {
    
    return self.center.y;
}

- (void)setCLcenterY:(CGFloat)CLcenterY {
    
    CGPoint newCenter = self.center;
    newCenter.y       = CLcenterY;
    self.center       = newCenter;
}

- (CGPoint)CLbottomRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)CLbottomLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)CLtopRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}
- (CGPoint)CLtopLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}



- (CGFloat)CLmiddleX {
    
    return CGRectGetWidth(self.bounds) / 2.f;
}

- (CGFloat)CLmiddleY {
    
    return CGRectGetHeight(self.bounds) / 2.f;
}

- (CGPoint)CLmiddlePoint {
    
    return CGPointMake(CGRectGetWidth(self.bounds) / 2.f, CGRectGetHeight(self.bounds) / 2.f);
}


#pragma mark - 设置圆角

- (void)setCornerOnTop:(CGFloat) conner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(conner, conner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setCornerOnBottom:(CGFloat) conner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(conner, conner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setCornerOnLeft:(CGFloat) conner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)
                                           cornerRadii:CGSizeMake(conner, conner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setCornerOnRight:(CGFloat) conner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(conner, conner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setCornerOnTopLeft:(CGFloat) conner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:UIRectCornerTopLeft
                                           cornerRadii:CGSizeMake(conner, conner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setCornerOnTopRight:(CGFloat) conner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:UIRectCornerTopRight
                                           cornerRadii:CGSizeMake(conner, conner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setCornerOnBottomLeft:(CGFloat) conner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:UIRectCornerBottomLeft
                                           cornerRadii:CGSizeMake(conner, conner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setCornerOnBottomRight:(CGFloat) conner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:UIRectCornerBottomRight
                                           cornerRadii:CGSizeMake(conner, conner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setAllCorner:(CGFloat) conner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                          cornerRadius:conner];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}




@end
