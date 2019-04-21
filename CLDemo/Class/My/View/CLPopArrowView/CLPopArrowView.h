//
//  CLPopArrowView.h
//  CLDemo
//
//  Created by AUG on 2019/4/21.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,CLArrowDirection){
    
    //箭头位置
    
    CLArrowDirectionLeftTop = 1,///<左上
    CLArrowDirectionLeftMiddle,///<左中
    CLArrowDirectionLeftBottom,///<左下
    CLArrowDirectionRightTop,///<右上
    CLArrowDirectionRightMiddle,///<右中
    CLArrowDirectionRightBottom,///<右下
    CLArrowDirectionTopLeft,///<上左
    CLArrowDirectionTopMiddle,///<上中
    CLArrowDirectionTopRight,///<上右
    CLArrowDirectionBottomLeft,///<下左
    CLArrowDirectionBottomModdle,///<下中
    CLArrowDirectionBottomRight,///<下右
    
};


@interface CLPopArrowView : UIView

@property (nonatomic, strong) UIView *contentView;

-(instancetype)initWithOrigin:(CGPoint)origin width:(CGFloat)width Height:(float)height direction:(CLArrowDirection)direction;//初始化
///弹出视图
-(void)popView;
///隐藏视图
-(void)dismiss;

@end

NS_ASSUME_NONNULL_END
