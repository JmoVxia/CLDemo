//
//  CLBubbleView.h
//  CLDemo
//
//  Created by AUG on 2019/3/18.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^disappearBlock)(void);


@interface CLBubbleView : UIButton

/** 大圆脱离小圆的最大距离 */
@property (nonatomic, assign) CGFloat maxDistance;
/**文字*/
@property (nonatomic,copy) NSString *text;
/**文字颜色*/
@property (nonatomic,strong) UIColor *textColor;
/**字体大小*/
@property (nonatomic,strong) UIFont *textFont;

/**
 按钮消失回调方法
 
 @param disappear 回调block
 */
- (void)disappear:(disappearBlock)disappear;

@end

NS_ASSUME_NONNULL_END
