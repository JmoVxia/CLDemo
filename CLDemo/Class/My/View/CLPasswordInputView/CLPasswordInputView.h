//
//  CLPasswordInputView.h
//  CLDemo
//
//  Created by AUG on 2019/1/15.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CLPasswordInputView;

@protocol  CLPasswordInputViewDelegate<NSObject>

@optional

/**输入改变*/
- (void)passwordInputViewDidChange:(CLPasswordInputView *)passwordInputView;

/**点击删除*/
- (void)passwordInputViewDidDeleteBackward:(CLPasswordInputView *)passwordInputView;

/**输入完成*/
- (void)passwordInputViewCompleteInput:(CLPasswordInputView *)passwordInputView;

/**开始输入*/
- (void)passwordInputViewBeginInput:(CLPasswordInputView *)passwordInputView;

/**结束输入*/
- (void)passwordInputViewEndInput:(CLPasswordInputView *)passwordInputView;

@end

@interface CLPasswordInputViewConfigure : NSObject

/**密码的位数*/
@property (nonatomic, assign) NSUInteger passwordNum;
/**边框正方形的大小*/
@property (nonatomic, assign) CGFloat squareWidth;
/**黑点的半径*/
@property (nonatomic, assign) CGFloat pointRadius;
/**边距相对中间间隙倍数*/
@property (nonatomic, assign) CGFloat spaceMultiple;
/**黑点颜色*/
@property (nonatomic, strong) UIColor *pointColor;
/**边框颜色*/
@property (nonatomic, strong) UIColor *rectColor;
/**输入框背景颜色*/
@property (nonatomic, strong) UIColor *rectBackgroundColor;
/**控件背景颜色*/
@property (nonatomic, strong) UIColor *backgroundColor;
/**是否允许三方键盘，默认NO*/
@property (nonatomic, assign) BOOL threePartyKeyboard;

@end

@interface CLPasswordInputView : UIView<UIKeyInput>

///代理
@property (nonatomic, weak) id<CLPasswordInputViewDelegate> delegate;

///输入的密码
@property (nonatomic, strong, readonly) NSMutableString *text;

///更新基本配置，block不会造成循环引用
- (void)updateWithConfigure:(void(^)(CLPasswordInputViewConfigure *configure))configBlock;

///清除文字
- (void)clearText;

@end

NS_ASSUME_NONNULL_END
