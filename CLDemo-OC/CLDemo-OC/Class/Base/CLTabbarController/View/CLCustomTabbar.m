//
//  CustomTabbar.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "CLCustomTabbar.h"
#import "UIImage+CLScaleToSize.h"
#import "UIButton+CLBlockAction.h"
#import "UIView+CLSetRect.h"

@interface CLCustomTabbar ()

@property (nonatomic,weak) UIButton *bulgeButton;

@end

@implementation CLCustomTabbar

- (UIButton *) bulgeButton {
    if (_bulgeButton == nil) {
        UIImage *normalImage = [UIImage originImage:[UIImage imageNamed:@"tabBar_publish_icon"] scaleToSize:CGSizeMake(80, 80)];
        UIImage *selectedImage = [UIImage originImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] scaleToSize:CGSizeMake(80, 80)];
        UIButton * button = [[UIButton alloc] init];
        [button setImage:selectedImage forState:UIControlStateSelected];
        [button setImage:normalImage forState:UIControlStateNormal];
        __weak __typeof(self) weakSelf = self;
        [button addActionBlock:^(UIButton *button) {
            __typeof(&*weakSelf) strongSelf = weakSelf;
            [strongSelf bulgeButtonAction:button];
        }];
        [self addSubview:button];
        _bulgeButton = button;
    }
    return _bulgeButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTranslucent:NO];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    int index = 0;
    CGFloat itemW = self.cl_width/5.0;

    for (UIView *subviews in self.subviews) {
        //取到系统tabbar的Item方法
        if ([@"UITabBarButton" isEqualToString:NSStringFromClass(subviews.class)]) {
            if (index == 2) {
                subviews.hidden = YES;
            }
            index++;
        }
    }
    self.bulgeButton.frame = CGRectMake(0, 0, itemW, itemW);
    self.bulgeButton.center = CGPointMake(self.cl_width/2.0, (self.cl_height - 30 - cl_safeBottomMargin)/2.0);
}
//判断点是否在响应范围
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isHidden == NO) {
        UIBezierPath *circle  = [UIBezierPath bezierPathWithArcCenter:self.bulgeButton.center radius:35 startAngle:0 endAngle:2* M_PI clockwise:YES];
        UIBezierPath *tabbar  = [UIBezierPath bezierPathWithRect:self.bounds];
        if ( [circle containsPoint:point] || [tabbar containsPoint:point]) {
            return YES;
        }
        return NO;
    }else {
        return [super pointInside:point withEvent:event];
    }
}

- (void)bulgeButtonAction:(UIButton *)button {
    if (self.bulgeCallBack) {
        self.bulgeCallBack();
    }
    NSLog(@"-------->>凸起按钮被点击了");
}

@end
