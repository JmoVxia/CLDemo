//
//  CLPasswordView.m
//  demo
//
//  Created by AUG on 2019/1/14.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLPasswordView.h"
#import "Masonry.h"
#import "UIView+CLSetRect.h"


@interface CLPasswordView ()<UITextFieldDelegate>

/**控件数组*/
@property (nonatomic, strong) NSMutableArray *viewArray;
/**密码*/
@property (nonatomic, copy) NSString *password;
/**输入完毕*/
@property (nonatomic, copy) void(^endBlock) (NSString *password);
/**当前值*/
@property (nonatomic, copy) NSString *inputString;
/**是否有值*/
@property (nonatomic, assign) BOOL hasValue;

@end

@implementation CLPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewArray = [NSMutableArray array];
        [self initUI];
    }
    return self;
}
- (void)initUI {
    //主线程
    for (NSInteger i = 0; i < 6; i++) {
        UITextField *textField = [[UITextField alloc] init];
        textField.layer.borderColor = [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.00].CGColor;
        textField.layer.borderWidth = 1;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.secureTextEntry = YES;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.delegate = self;
//        textField.tintColor = [UIColor whiteColor];
        [textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:textField];
        [_viewArray addObject:textField];
    }
    [(UITextField *)[_viewArray firstObject] becomeFirstResponder];
    UIButton *button = [[UIButton alloc] init];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}
- (void)textDidChange:(UITextField *)textFiled {
    if (textFiled.text.length == 1) {
        NSInteger index = [_viewArray indexOfObject:textFiled];
        [self changeFirstResponder:MIN(index + 1, _viewArray.count - 1) delete:NO text:self.inputString];
    }
}
-(void)setPassword:(NSString *)password {
    _password = password;
    if (_password.length == 6 && self.endBlock) {
        self.endBlock(_password);
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.inputString = string;
    self.hasValue = textField.text.length;
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *allString = [self.password stringByAppendingString:string];
    if (allString.length > 6) {
        return NO;
    }
    if (toBeString.length > 1) {
        [self textDidChange:textField];
        return NO;
    }
    return YES;
}
- (void)textFieldDidDeleteBackward:(UITextField *)textField {
    NSInteger index = [_viewArray indexOfObject:textField];
    [self changeFirstResponder:MAX(index - 1, 0) delete:YES text:nil];
}
- (void)changeFirstResponder:(NSInteger)index delete:(BOOL)delete text:(NSString *)text {
    UITextField *textField =  [_viewArray objectAtIndex:index];
    if (delete && !_hasValue) {
        textField.text = nil;
    }
    if (!delete && _hasValue) {
        textField.text = text;
    }
    [textField becomeFirstResponder];
    NSString *password = @"";
    for (UITextField *filed in _viewArray) {
        password = [password stringByAppendingString:filed.text];
    }
    self.password = password;
}
- (void)passwordEnd:(void(^)(NSString *password))end {
    self.endBlock = end;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [_viewArray enumerateObjectsUsingBlock:^(UITextField *textField, NSUInteger idx, BOOL * _Nonnull stop) {
        [textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(textField.mas_height);
        }];
    }];
    [_viewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:50 leadSpacing:(2.5 * ((self.cl_width - 50 * 6) / 8.0)) tailSpacing:(2.5 * ((self.cl_width - 50 * 6) / 8.0))];
}
@end
