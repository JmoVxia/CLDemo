//
//  CLInputPasswordToolBar
//  CLDemo
//
//  Created by AUG on 2019/9/17.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLPasswordInputView.h"


NS_ASSUME_NONNULL_BEGIN

@interface CLInputPasswordToolBar : UIView

///弹出键盘
- (void)showToolbar;
///收回键盘
-(void)dissmissToolbar;

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
