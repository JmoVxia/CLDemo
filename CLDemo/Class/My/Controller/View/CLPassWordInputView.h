//
//  CLPassWordInputView.h
//  CLDemo
//
//  Created by AUG on 2019/1/15.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CLPassWordInputView;

@protocol  CLPassWordInputViewDelegate<NSObject>
@optional
/**
 *  监听输入的改变
 */
- (void)passWordDidChange:(CLPassWordInputView *)passWord;

/**
 *  监听输入的完成时
 */
- (void)passWordCompleteInput:(CLPassWordInputView *)passWord;

/**
 *  监听开始输入
 */
- (void)passWordBeginInput:(CLPassWordInputView *)passWord;

@end

@interface CLPassWordInputView : UIView<UIKeyInput>

//密码的位数
@property (nonatomic, assign) NSUInteger passWordNum;
//正方形的大小
@property (nonatomic, assign) CGFloat squareWidth;
//黑点的半径
@property (nonatomic, assign) CGFloat pointRadius;
/**边距相对中间间隙倍数*/
@property (nonatomic, assign) CGFloat spaceMultiple;
//黑点的颜色
@property (nonatomic, strong) UIColor *pointColor;
//边框的颜色
@property (nonatomic, strong) UIColor *rectColor;
//代理
@property (nonatomic, weak) id<CLPassWordInputViewDelegate> delegate;
//保存密码的字符串
@property (nonatomic, strong, readonly) NSMutableString *textStore;

@end

NS_ASSUME_NONNULL_END
