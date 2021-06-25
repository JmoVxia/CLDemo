//
//  UITextField+CLDelegate.h
//  demo
//
//  Created by AUG on 2019/1/14.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CLTextFieldDelegate<UITextFieldDelegate>

@optional - (void)textFieldDidDeleteBackward:(UITextField *)textField;

@end

@interface UITextField (CLDelegate)

@property (weak, nonatomic) id<CLTextFieldDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
