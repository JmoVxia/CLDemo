//
//  UIView+SetRect.m
//  UIView
//
//  Created by JmoVxia on 2016/10/27.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "UIView+CLSetRect.h"

@implementation UIView (CLSetRect)

- (CGPoint)cl_origin {
    
    return self.frame.origin;
}

- (void)setCl_origin:(CGPoint)cl_origin {
    
    CGRect newFrame = self.frame;
    newFrame.origin = cl_origin;
    self.frame      = newFrame;
}

- (CGFloat)cl_x {
    
    return self.frame.origin.x;
}

- (void)setCl_x:(CGFloat)cl_x {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.x = cl_x;
    self.frame        = newFrame;
}

- (CGFloat)cl_y {
    
    return self.frame.origin.y;
}

- (void)setCl_y:(CGFloat)cl_y {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.y = cl_y;
    self.frame        = newFrame;
}

- (CGFloat)cl_width {
    
    return CGRectGetWidth(self.bounds);
}

-(void)setCl_width:(CGFloat)cl_width {
    
    CGRect newFrame     = self.frame;
    newFrame.size.width = cl_width;
    self.frame          = newFrame;
}

- (CGFloat)cl_height {
    
    return CGRectGetHeight(self.bounds);
}

-(void)setCl_height:(CGFloat)cl_height {
    
    CGRect newFrame      = self.frame;
    newFrame.size.height = cl_height;
    self.frame           = newFrame;
}

- (CGFloat)cl_top {
    
    return self.frame.origin.y;
}

- (void)setCl_top:(CGFloat)cl_top {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.y = cl_top;
    self.frame        = newFrame;
}

- (CGFloat)cl_bottom {
    
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setCl_bottom:(CGFloat)cl_bottom {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.y = cl_bottom - self.frame.size.height;
    self.frame        = newFrame;
}

- (CGFloat)cl_left {
    
    return self.frame.origin.x;
}

- (void)setCl_left:(CGFloat)cl_left {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.x = cl_left;
    self.frame        = newFrame;
}

- (CGFloat)cl_right {
    
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setCl_right:(CGFloat)cl_right {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.x = cl_right - self.frame.size.width;
    self.frame        = newFrame;
}

- (CGFloat)cl_centerX {
    
    return self.center.x;
}
- (void)setCl_centerX:(CGFloat)cl_centerX {
    
    CGPoint newCenter = self.center;
    newCenter.x       = cl_centerX;
    self.center       = newCenter;
}

- (CGFloat)cl_centerY {
    
    return self.center.y;
}

- (void)setCl_centerY:(CGFloat)cl_centerY {
    
    CGPoint newCenter = self.center;
    newCenter.y       = cl_centerY;
    self.center       = newCenter;
}

- (CGPoint)cl_bottomRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)cl_bottomLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)cl_topRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}
- (CGPoint)cl_topLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}



- (CGFloat)cl_middleX {
    
    return CGRectGetWidth(self.bounds) / 2.f;
}

- (CGFloat)cl_middleY {
    
    return CGRectGetHeight(self.bounds) / 2.f;
}

- (CGPoint)cl_middlePoint {
    
    return CGPointMake(CGRectGetWidth(self.bounds) / 2.f, CGRectGetHeight(self.bounds) / 2.f);
}

- (CGSize)cl_size {
    return self.frame.size;
}

-(void)setCl_size:(CGSize)cl_size {
    CGRect frame = self.frame;
    frame.size = cl_size;
    self.frame = frame;
}

#pragma mark - 设置圆角

- (void)cl_setCornerOnTop:(CGFloat) conner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(conner, conner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)cl_setCornerOnBottom:(CGFloat) conner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(conner, conner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)cl_setCornerOnLeft:(CGFloat) conner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)
                                           cornerRadii:CGSizeMake(conner, conner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)cl_setCornerOnRight:(CGFloat) conner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(conner, conner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)cl_setCornerOnTopLeft:(CGFloat) conner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:UIRectCornerTopLeft
                                           cornerRadii:CGSizeMake(conner, conner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)cl_setCornerOnTopRight:(CGFloat) conner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:UIRectCornerTopRight
                                           cornerRadii:CGSizeMake(conner, conner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)cl_setCornerOnBottomLeft:(CGFloat) conner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:UIRectCornerBottomLeft
                                           cornerRadii:CGSizeMake(conner, conner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)cl_setCornerOnBottomRight:(CGFloat) conner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:UIRectCornerBottomRight
                                           cornerRadii:CGSizeMake(conner, conner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)cl_setAllCorner:(CGFloat) conner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                          cornerRadius:conner];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}




@end

