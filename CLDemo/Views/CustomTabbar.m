//
//  CustomTabbar.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "CustomTabbar.h"
#import "UIImage+CLScaleToSize.h"

@interface CustomTabbar ()

@property (nonatomic,weak) UIButton *button;

/** shapeLayer*/
@property(nonatomic,weak)CAShapeLayer *shapeLayer;
@end

@implementation CustomTabbar



- (UIButton *) button
{
    if (_button==nil)
    {
        
        UIImage *normalImage = [UIImage OriginImage:[UIImage imageNamed:@"tabBar_publish_icon"] scaleToSize:CGSizeMake(80, 80)];
        UIImage *selectedImage = [UIImage OriginImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] scaleToSize:CGSizeMake(80, 80)];
        UIButton * button = [Tools createButtonNormalImage:normalImage selectedImage:selectedImage tag:1000 addTarget:self action:@selector(PublishButton:)];
        [self addSubview:button];
        _button = button;
    }
    return _button;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        self.shapeLayer          = shapeLayer;
        shapeLayer.fillColor     = [UIColor blueColor].CGColor;
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
   
    int index = 0;
    CGFloat itemW = self.CLwidth/5.0;

    for (UIView *subviews in self.subviews)
    {
        //取到系统tabbar的Item方法
        if ([@"UITabBarButton" isEqualToString:NSStringFromClass(subviews.class)])
        {
            subviews.CLleft = index*itemW;
            subviews.CLwidth = itemW;
            if (index >= 2)
            {
                subviews.CLleft +=itemW;
            }
            index++;
        }
    }
    self.button.frame = CGRectMake(0, 0, itemW, itemW);
    self.button.center = CGPointMake(self.CLwidth/2.0, (self.CLheight - 30)/2.0);
    UIBezierPath *circle  = [UIBezierPath bezierPathWithArcCenter:self.button.center radius:37 startAngle:0 endAngle:2* M_PI clockwise:YES];
    self.shapeLayer.path          = circle.CGPath;
   
}

-(void)didMoveToWindow {
    [super didMoveToWindow];
    [self.layer addSublayer:self.shapeLayer];
}
//判断点是否在响应范围
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isHidden == NO) {
        UIBezierPath *circle  = [UIBezierPath bezierPathWithArcCenter:self.button.center radius:37 startAngle:0 endAngle:2* M_PI clockwise:YES];
        UIBezierPath *tabbar  = [UIBezierPath bezierPathWithRect:self.bounds];
        if ( [circle containsPoint:point] || [tabbar containsPoint:point]) {
            return YES;
        }
        return NO;
    }else {
        return [super pointInside:point withEvent:event];
    }
}

- (void)PublishButton:(UIButton *)button
{
    NSLog(@"-------->>凸起按钮被点击了");
}

@end
