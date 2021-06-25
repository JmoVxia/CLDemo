//
//  UIButton+CLBlockAction.h
//  CLDemo
//
//  Created by AUG on 2018/11/9.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionBlock)(UIButton * _Nullable button);


NS_ASSUME_NONNULL_BEGIN

@interface UIButton (CLBlockAction)


/**
 添加点击事件

 @param block 响应回掉
 @param controlEvents 点击的方式
 */
- (void)addActionBlock:(ActionBlock)block forControlEvents:(UIControlEvents)controlEvents;


/**
 添加点击事件

 @param block 响应回掉
 */
- (void)addActionBlock:(ActionBlock)block;



@end

NS_ASSUME_NONNULL_END
