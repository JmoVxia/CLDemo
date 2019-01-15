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
- (void)passwordDidChange:(CLPasswordInputView *)password;

/**点击删除*/
- (void)passwordDidDeleteBackward:(CLPasswordInputView *)password;

/**输入完成*/
- (void)passwordCompleteInput:(CLPasswordInputView *)password;

/**开始输入*/
- (void)passwordBeginInput:(CLPasswordInputView *)password;

/**结束输入*/
- (void)passwordEndInput:(CLPasswordInputView *)password;

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
/**默认配置*/
+ (instancetype)defaultConfig;

@end

@interface CLPasswordInputView : UIView<UIKeyInput>

/**代理*/
@property (nonatomic, weak) id<CLPasswordInputViewDelegate> delegate;

/**输入的密码*/
@property (nonatomic, strong, readonly) NSMutableString *password;

/**更新基本配置*/
- (void)updateWithConfig:(void(^)(CLPasswordInputViewConfigure *config))configBlock;

@end

NS_ASSUME_NONNULL_END
