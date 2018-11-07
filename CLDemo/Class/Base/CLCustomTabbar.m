//
//  CustomTabbar.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "CLCustomTabbar.h"
#import "UIImage+CLScaleToSize.h"
#import <objc/runtime.h>

@interface CLCustomTabbar ()

@property (nonatomic,weak) UIButton *button;

/** shapeLayer*/
//@property(nonatomic,weak)CAShapeLayer *shapeLayer;

@end

@implementation CLCustomTabbar
/**
 *  用 block 重写某个 class 的指定方法
 *  @param targetClass 要重写的 class
 *  @param targetSelector 要重写的 class 里的实例方法，注意如果该方法不存在于 targetClass 里，则什么都不做
 *  @param implementationBlock 该 block 必须返回一个 block，返回的 block 将被当成 targetSelector 的新实现，所以要在内部自己处理对 super 的调用，以及对当前调用方法的 self 的 class 的保护判断（因为如果 targetClass 的 targetSelector 是继承自父类的，targetClass 内部并没有重写这个方法，则我们这个函数最终重写的其实是父类的 targetSelector，所以会产生预期之外的 class 的影响，例如 targetClass 传进来  UIButton.class，则最终可能会影响到 UIView.class），implementationBlock 的参数里第一个为你要修改的 class，也即等同于 targetClass，第二个参数为你要修改的 selector，也即等同于 targetSelector，第三个参数是 targetSelector 原本的实现，由于 IMP 可以直接当成 C 函数调用，所以可利用它来实现“调用 super”的效果，但由于 targetSelector 的参数个数、参数类型、返回值类型，都会影响 IMP 的调用写法，所以这个调用只能由业务自己写。
 *  解决方案来源声明。该解决方案及所使用的代码，来自于 QMUI iOS(https://github.com/QMUI/QMUI_iOS)。
 */
CG_INLINE BOOL
OverrideImplementation(Class targetClass, SEL targetSelector, id (^implementationBlock)(Class originClass, SEL originCMD, IMP originIMP)) {
    Method originMethod = class_getInstanceMethod(targetClass, targetSelector);
    if (!originMethod) {
        return NO;
    }
    IMP originIMP = method_getImplementation(originMethod);
    method_setImplementation(originMethod, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originIMP)));
    return YES;
}

+ (void)load {
    /* 这个问题是 iOS 12.1 的问题，只要 UITabBar 是磨砂的，并且 push viewController 时 hidesBottomBarWhenPushed = YES 则手势返回的时候就会触发。(来源于QMUIKit的处理方式)*/
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 12.1, *)) {
            OverrideImplementation(NSClassFromString(@"UITabBarButton"), @selector(setFrame:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP originIMP) {
                return ^(UIView *selfObject, CGRect firstArgv) {
                    if ([selfObject isKindOfClass:originClass]) {
                        
                        // 如果发现即将要设置一个 size 为空的 frame，则屏蔽掉本次设置
                        if (!CGRectIsEmpty(selfObject.frame) && CGRectIsEmpty(firstArgv)) {
                            return;
                        }
                        // 兼容 iOS 12 的 iPhoneX
//                        CGFloat tabBarHeight = firstArgv.size.height;
//                        CGFloat realTabBarHeight = cl_tabbarHeight;
//                        if (cl_iPhoneX_Xr_Xs_XsMax && (tabBarHeight != realTabBarHeight)) {
//                            firstArgv.size.height = realTabBarHeight;
//                        }
                    }
                    // call super
                    void (*originSelectorIMP)(id, SEL, CGRect);
                    originSelectorIMP = (void (*)(id, SEL, CGRect))originIMP;
                    originSelectorIMP(selfObject, originCMD, firstArgv);
                };
            });
        }
    });
}



- (UIButton *) button
{
    if (_button == nil)
    {
        
        UIImage *normalImage = [UIImage OriginImage:[UIImage imageNamed:@"tabBar_publish_icon"] scaleToSize:CGSizeMake(80, 80)];
        UIImage *selectedImage = [UIImage OriginImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] scaleToSize:CGSizeMake(80, 80)];
        UIButton * button = [[UIButton alloc] init];
        [button setImage:selectedImage forState:UIControlStateSelected];
        [button setImage:normalImage forState:UIControlStateNormal];
        [button addTarget:self action:@selector(publishButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        _button = button;
    }
    return _button;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//        self.shapeLayer          = shapeLayer;
//        shapeLayer.fillColor     = [UIColor lightGrayColor].CGColor;
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
   
    int index = 0;
    CGFloat itemW = self.cl_width/5.0;

    for (UIView *subviews in self.subviews)
    {
        //取到系统tabbar的Item方法
        if ([@"UITabBarButton" isEqualToString:NSStringFromClass(subviews.class)])
        {
            subviews.cl_left = index * itemW;
            subviews.cl_width = itemW;
            if (index >= 2)
            {
                subviews.cl_left +=itemW;
            }
            index++;
        }
    }
    self.button.frame = CGRectMake(0, 0, itemW, itemW);
    self.button.center = CGPointMake(self.cl_width/2.0, (self.cl_height - 30 - cl_safeBottomMargin)/2.0);
//    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:self.button.center radius:35 startAngle:0 endAngle:2* M_PI clockwise:YES];
//    self.shapeLayer.path = circle.CGPath;
   
}

-(void)didMoveToWindow {
    [super didMoveToWindow];
//    [self.layer addSublayer:self.shapeLayer];
}
//判断点是否在响应范围
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isHidden == NO) {
        UIBezierPath *circle  = [UIBezierPath bezierPathWithArcCenter:self.button.center radius:35 startAngle:0 endAngle:2* M_PI clockwise:YES];
        UIBezierPath *tabbar  = [UIBezierPath bezierPathWithRect:self.bounds];
        if ( [circle containsPoint:point] || [tabbar containsPoint:point]) {
            return YES;
        }
        return NO;
    }else {
        return [super pointInside:point withEvent:event];
    }
}

- (void)publishButton:(UIButton *)button {
    NSLog(@"-------->>凸起按钮被点击了");
}

@end
