//
//  UIView+SetRect.h
//  UIView
//
//  Created by JmoVxia on 2016/10/27.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * 随机色
 */
#define cl_RandomColor [UIColor colorWithHue:(arc4random() % (256) / (256.0)) saturation:(arc4random() % (128) / (256.0)) + (0.5) brightness:(arc4random() % (128) / (256.0)) + (0.5) alpha:(1.0)]
/**
 *  UIScreen width.
 */
#define  cl_screenWidth   [UIScreen mainScreen].bounds.size.width

/**
 *  UIScreen height.
 */
#define  cl_screenHeight  [UIScreen mainScreen].bounds.size.height

/**iPhone6为标准，乘以宽的比例*/
#define cl_scaleX_px(value) (((value) * 0.5f)/(375.f) * cl_screenWidth)
/**iPhone6为标准，乘以高的比例*/
#define cl_scaleY_px(value) (((value) * 0.5f)/(667.f) * cl_screenHeight)
/**直接使用像素*/
#define cl_px(value) ((value) * 0.5f)

/**iPhone6为标准，乘以宽的比例*/
#define cl_scaleX_pt(value) ((value)/(375.f) * cl_screenWidth)
/**iPhone6为标准，乘以高的比例*/
#define cl_scaleY_pt(value) ((value)/(667.f) * cl_screenHeight)
/**直接使用点*/
#define cl_pt(value) ((value) * 0.5f)


/**
 *  Status bar height.
 */
#define  statusBarHeight      [[UIApplication sharedApplication] statusBarFrame].size.height

/**
 *  Navigation bar height.
 */
#define  cl_navigationBarHeight  44.f

/**
 *  Status bar & navigation bar height.
 */
#define  cl_statusBarAndNavigationBarHeight   (statusBarHeight + 44.f)

/**
 tabbar高度
 */
#define  cl_tabbarHeight         ((cl_iPhoneX || cl_iPhoneXr || cl_iPhoneXs || cl_iPhoneXsMax) ? (49.f + 34.f) : 49.f)
/**
 底部安全间距
 */
#define  cl_safeBottomMargin  ((cl_iPhoneX || cl_iPhoneXr || cl_iPhoneXs || cl_iPhoneXsMax) ? 34.f : 0.f)



// 判断是否是ipad
#define cl_isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
// 判断iPhone4系列
#define cl_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !cl_isPad : NO)
// 判断iPhone5系列
#define cl_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !cl_isPad : NO)
// 判断iPhone6系列
#define cl_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !cl_isPad : NO)
//判断iphone6+系列
#define cl_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !cl_isPad : NO)
// 判断iPhoneX
#define cl_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !cl_isPad : NO)
// 判断iPHoneXr
#define cl_iPhoneXr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !cl_isPad : NO)
// 判断iPhoneXs
#define cl_iPhoneXs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !cl_isPad : NO)
// 判断iPhoneXs Max
#define cl_iPhoneXsMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !cl_isPad : NO)

// 判断iPhoneX系列
#define cl_iPhoneX_Xr_Xs_XsMax ((cl_iPhoneX) || (cl_iPhoneXr) || (cl_iPhoneXs) || (cl_iPhoneXsMax))


@interface UIView (cl_SetRect)



/**
 控件起点
 */
@property (nonatomic) CGPoint cl_origin;

/**
 控件起点x
 */
@property (nonatomic) CGFloat cl_x;

/**
 控件起点Y
 */
@property (nonatomic) CGFloat cl_y;

/**
 控件宽
 */
@property (nonatomic) CGFloat cl_width;

/**
 控件高
 */
@property (nonatomic) CGFloat cl_height;

/**
 控件顶部
 */
@property (nonatomic) CGFloat cl_top;

/**
 控件底部
 */
@property (nonatomic) CGFloat cl_bottom;

/**
 控件左边
 */
@property (nonatomic) CGFloat cl_left;

/**
 控件右边
 */
@property (nonatomic) CGFloat cl_right;

/**
 控件中心点X
 */
@property (nonatomic) CGFloat cl_centerX;

/**
 控件中心点Y
 */
@property (nonatomic) CGFloat cl_centerY;

/**
 控件左下
 */
@property(readonly) CGPoint cl_bottomLeft ;

/**
 控件右下
 */
@property(readonly) CGPoint cl_bottomRight ;

/**
 控件左上
 */
@property(readonly) CGPoint cl_topLeft ;
/**
 控件右上
 */
@property(readonly) CGPoint cl_topRight ;


/**
 屏幕中心点X
 */
@property (nonatomic, readonly) CGFloat cl_middleX;

/**
 屏幕中心点Y
 */
@property (nonatomic, readonly) CGFloat cl_middleY;

/**
 屏幕中心点
 */
@property (nonatomic, readonly) CGPoint cl_middlePoint;

/**
 控件size
 */
@property (nonatomic) CGSize cl_size;



/**
 设置上边圆角
 */
- (void)cl_setCornerOnTop:(CGFloat) conner;

/**
 设置下边圆角
 */
- (void)cl_setCornerOnBottom:(CGFloat) conner;
/**
 设置左边圆角
 */
- (void)cl_setCornerOnLeft:(CGFloat) conner;
/**
 设置右边圆角
 */
- (void)cl_setCornerOnRight:(CGFloat) conner;

/**
 设置左上圆角
 */
- (void)cl_setCornerOnTopLeft:(CGFloat) conner;

/**
 设置右上圆角
 */
- (void)cl_setCornerOnTopRight:(CGFloat) conner;
/**
 设置左下圆角
 */
- (void)cl_setCornerOnBottomLeft:(CGFloat) conner;
/**
 设置右下圆角
 */
- (void)cl_setCornerOnBottomRight:(CGFloat) conner;


/**
 设置所有圆角
 */
- (void)cl_setAllCorner:(CGFloat) conner;


@end

