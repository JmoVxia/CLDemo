//
//  CLInputPasswordToolBar.m
//  CLDemo
//
//  Created by AUG on 2019/9/17.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLInputPasswordToolBar.h"
#import <Masonry/Masonry.h>
#import "UIColor+CLHex.h"

@interface CLInputPasswordBackgroundView : UIView
///顶部view
@property (nonatomic, strong) UIView *topView;
///关闭按钮
@property (nonatomic, strong) UIButton *closeButton;
///标题
@property (nonatomic, strong) UILabel *titleLabel;
///横线
@property (nonatomic, strong) UIView *lineView;
///密码输入框
@property (nonatomic, strong) CLPasswordInputView *passwordInputView;
///关闭回掉
@property (nonatomic, copy) void (^closeCallBack)(void);

@end

@implementation CLInputPasswordBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self mas_makeConstraints];
    }
    return self;
}
- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topView];
    [self.topView addSubview:self.closeButton];
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.lineView];
    [self addSubview:self.passwordInputView];
}
- (void)mas_makeConstraints {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(11);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    [self.passwordInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom).mas_offset(25);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
}
- (BOOL)becomeFirstResponder {
    return [self.passwordInputView becomeFirstResponder];
}
- (BOOL)resignFirstResponder {
    return [self.passwordInputView resignFirstResponder];
}
- (void)closeButtonAcrtion {
    if (self.closeCallBack) {
        self.closeCallBack();
    }
}
- (UIView *) topView {
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
}
- (UIButton *) closeButton {
    if (_closeButton == nil) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"btn_x"] forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"btn_x"] forState:UIControlStateSelected];
        [_closeButton addTarget:self action:@selector(closeButtonAcrtion) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UILabel *) titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"请输入密码";
        _titleLabel.textColor = [UIColor colorWithHex:@"0x000000"];
    }
    return _titleLabel;
}
- (UIView *) lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHex:@"0xEDEDED"];
    }
    return _lineView;
}
- (CLPasswordInputView *) passwordInputView {
    if (_passwordInputView == nil) {
        _passwordInputView = [[CLPasswordInputView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
        [_passwordInputView updateWithConfigure:^(CLPasswordInputViewConfigure * _Nonnull configure) {
            configure.spaceMultiple = 5;
        }];
    }
    return _passwordInputView;
}
@end

@interface CLInputPasswordToolBar ()<UITextViewDelegate>

/**遮罩*/
@property (nonatomic, strong) UIView *maskView;
///textField
@property (nonatomic, strong) UITextField *textField;
///密码输入控件
@property (nonatomic, strong) CLInputPasswordBackgroundView *passwordView;
/*keyWindow*/
@property (nonatomic, strong) UIWindow *keyWindow;
///是否显示
@property (nonatomic, assign) BOOL keyboardIsShow;

@end

@implementation CLInputPasswordToolBar

- (void)showToolbar {
    
    if (self.keyboardIsShow) {
        return;
    }
    [self.keyWindow addSubview:self.maskView];
    [self.maskView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.backgroundColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.4];
    }];
    [self.keyWindow addSubview:self];
    [self addSubview:self.textField];
    self.textField.inputAccessoryView = self.passwordView;
    self.keyboardIsShow = YES;
    [self.textField becomeFirstResponder];
    [self.passwordView becomeFirstResponder];
}
-(void)dissmissToolbar {
    if (!self.keyboardIsShow) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.backgroundColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.0];
    }completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self removeFromSuperview];
    }];
    self.keyboardIsShow = NO;
    [self.passwordView.passwordInputView clearText];
    [self.passwordView resignFirstResponder];
    [self.textField resignFirstResponder];
}
- (void)tapActions:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self dissmissToolbar];
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (CGRectContainsPoint(self.passwordView.frame, point)) {
        return self.passwordView;
    }
    return hitView;
}
- (void)setDelegate:(id<CLPasswordInputViewDelegate>)delegate {
    _delegate = delegate;
    self.passwordView.passwordInputView.delegate = _delegate;
}
-(void)updateWithConfigure:(void (^)(CLPasswordInputViewConfigure * _Nonnull))configBlock {
    [self.passwordView.passwordInputView updateWithConfigure:configBlock];
}
- (NSMutableString *)text {
    return self.passwordView.passwordInputView.text;
}

///清除文字
- (void)clearText {
    [self.passwordView.passwordInputView clearText];
}
//MARK:JmoVxia---懒加载
- (UIView *) maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActions:)];
        [_maskView addGestureRecognizer:tapGestureRecognizer];
    }
    return _maskView;
}
- (UITextField *) textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textField;
}
- (CLInputPasswordBackgroundView *) passwordView {
    if (_passwordView == nil) {
        _passwordView = [[CLInputPasswordBackgroundView alloc] initWithFrame:CGRectMake(0, 0, 0, 145)];
        __weak __typeof(self) weakSelf = self;
        _passwordView.closeCallBack = ^{
            __typeof(&*weakSelf) strongSelf = weakSelf;
            [strongSelf dissmissToolbar];
        };
    }
    return _passwordView;
}
- (UIWindow *) keyWindow {
    if (_keyWindow == nil) {
        _keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    return _keyWindow;
}


@end
