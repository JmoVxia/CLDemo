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


-(void)layoutSubviews
{
    [super layoutSubviews];
   
    int index = 0;
    CGFloat itemW = self.width/5.0;

    for (UIView *subviews in self.subviews)
    {
        //取到系统tabbar的Item方法
        if ([@"UITabBarButton" isEqualToString:NSStringFromClass(subviews.class)])
        {
            subviews.left = index*itemW;
            subviews.width = itemW;
            if (index >= 2)
            {
                subviews.left +=itemW;
            }
            index++;
        }
    }
    self.button.frame = CGRectMake(0, 0, itemW, itemW);
    self.button.center = CGPointMake(self.width/2.0, (self.height - 30)/2.0);
}
//重写hitTest方法，去监听发布按钮的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
    //在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在发布按钮身上
    //是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO)
    {
        //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:self.button];
        
        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ( [self.button pointInside:newP withEvent:event])
        {
            return self.button;
        }
        else
        {//如果点不在发布按钮身上，直接让系统处理就可以了
            return [super hitTest:point withEvent:event];
        }
    }
    else
    {//tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}

- (void)PublishButton:(UIButton *)button
{
    NSLog(@"-------->>凸起按钮被点击了");
}

@end
