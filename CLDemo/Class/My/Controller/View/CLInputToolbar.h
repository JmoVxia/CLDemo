//
//  CLInputToolbar.h
//  CLInputToolbar
//
//  Created by JmoVxia on 2017/8/16.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^inputToolBarSendBlock)(NSString *text);


@interface CLInputToolbarConfigure : NSObject

/**显示遮罩*/
@property (nonatomic, assign) BOOL showMaskView;
/**设置输入框最大行数*/
@property (nonatomic, assign) NSInteger textViewMaxLine;
/**输入框文字大小*/
@property (nonatomic, strong) UIFont *font;
/**占位文字*/
@property (nonatomic, copy) NSString *placeholder;
/**背景颜色*/
@property (nonatomic, strong) UIColor *backgroundColor;

@end


@interface CLInputToolbar : UIView

/**更新基本配置*/
- (void)updateWithConfig:(void(^)(CLInputToolbarConfigure *configure))configBlock;

/**弹出键盘*/
- (void)showToolbar;
/**收回键盘*/
- (void)dissmissToolbar;
/**清空文字*/
- (void)clearText;
/**点击发送按钮*/
- (void)inputToolbarSendText:(inputToolBarSendBlock)sendBlock;

@end
