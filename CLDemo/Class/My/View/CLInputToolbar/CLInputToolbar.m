//
//  CLInputToolbar.m
//  CLInputToolbar
//
//  Created by JmoVxia on 2017/8/16.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLInputToolbar.h"
#import "UIView+CLSetRect.h"

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@implementation CLInputToolbarConfigure

+ (instancetype)defaultConfigure {
    CLInputToolbarConfigure *configure = [[CLInputToolbarConfigure alloc] init];
    configure.showMaskView = YES;
    configure.textViewMaxLine = 3;
    configure.font = [UIFont systemFontOfSize:18];
    configure.placeholder = @"请输入...";
    configure.cursorColor = [UIColor colorWithRed:0.08 green:0.54 blue:0.95 alpha:1.00];
    configure.backgroundColor = [UIColor whiteColor];
    configure.textColor = RGBACOLOR(1, 1, 1, 1);
    configure.topLineColor = RGBACOLOR(0, 0, 0, 0.2);
    configure.bottomLineColor = RGBACOLOR(0, 0, 0, 0.2);
    configure.edgeLineViewColor = RGBACOLOR(0, 0, 0, 0.5);
    configure.placeholderTextColor = RGBACOLOR(0, 0, 0, 0.5);
    configure.sendButtonBorderColor = RGBACOLOR(0, 0, 0, 1.0);
    configure.sendButtonTextColor = RGBACOLOR(0, 0, 0, 1.0);
    return configure;
}
- (void)setFont:(UIFont *)font {
    _font = font;
    if (font.pointSize < 18) {
        _font = [UIFont fontWithName:_font.fontName size:18];
    }
}
- (void)setTextViewMaxLine:(NSInteger)textViewMaxLine {
    _textViewMaxLine = textViewMaxLine;
    if (!_textViewMaxLine || _textViewMaxLine <= 0) {
        _textViewMaxLine = 3;
    }
}

@end

@interface CLInputToolbar ()<UITextViewDelegate>

@property (nonatomic, strong) CLInputToolbarConfigure *configure;
/**遮罩*/
@property (nonatomic, strong) UIView *maskView;
/**背景*/
@property (nonatomic, strong) UIView *backgroundView;
/**文本输入框*/
@property (nonatomic, strong) UITextView *textView;
/**边框*/
@property (nonatomic, strong) UIView *edgeLineView;
/**顶部线条*/
@property (nonatomic, strong) UIView *topLine;
/**底部线条*/
@property (nonatomic, strong) UIView *bottomLine;
/**textView占位符*/
@property (nonatomic, strong) UILabel *placeholderLabel;
/**发送按钮*/
@property (nonatomic, strong) UIButton *sendButton;
/*keyWindow*/
@property (nonatomic, strong) UIWindow *keyWindow;
/**发送回调*/
@property (nonatomic, copy) inputToolBarSendBlock sendBlock;
///是否显示
@property (nonatomic, assign) BOOL keyboardIsShow;
@end

@implementation CLInputToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
-(void)initUI {
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0,0, cl_screenWidth, 50);
    //顶部线条
    [self addSubview:self.topLine];
    //底部线条
    [self addSubview:self.bottomLine];
    //边框
    [self addSubview:self.edgeLineView];
    //输入框
    [self addSubview:self.textView];
    //占位文字
    [self addSubview:self.placeholderLabel];
    //发送按钮
    [self addSubview:self.sendButton];
    [self refreshUI];
}
- (void)refreshUI {
    self.textView.font = self.configure.font;
    self.placeholderLabel.font = self.configure.font;
    CGFloat lineH = self.textView.font.lineHeight;
    self.cl_height = ceil(lineH) + 10 + 10;
    self.textView.cl_height = lineH;
    self.textView.tintColor = self.configure.cursorColor;
    self.textView.textColor = self.configure.textColor;
    self.placeholderLabel.text = self.configure.placeholder;
    self.backgroundView.backgroundColor = self.configure.backgroundColor;
    self.topLine.backgroundColor = self.configure.topLineColor;
    self.bottomLine.backgroundColor = self.configure.bottomLineColor;
    self.edgeLineView.layer.borderColor = self.configure.edgeLineViewColor.CGColor;
    self.placeholderLabel.textColor = self.configure.placeholderTextColor;
    self.sendButton.layer.borderColor = self.textView.text.length > 0 ? self.configure.sendButtonBorderColor.CGColor : RGBACOLOR(0, 0, 0, 0.2).CGColor;
    [self.sendButton setTitleColor:self.textView.text.length > 0 ? self.configure.sendButtonTextColor : RGBACOLOR(0, 0, 0, 0.2) forState:UIControlStateNormal];
    [self.sendButton setTitleColor:self.textView.text.length > 0 ? self.configure.sendButtonTextColor : RGBACOLOR(0, 0, 0, 0.2) forState:UIControlStateSelected];
}
- (void)updateWithConfig:(void(^)(CLInputToolbarConfigure *configure))configBlock {
    if (configBlock) {
        configBlock(self.configure);
    }
    configBlock = nil;
    [self refreshUI];
}
//MARK:JmoVxia---UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length;
    if (textView.text.length == 0) {
        self.sendButton.enabled = NO;
        [self.sendButton setTitleColor:RGBACOLOR(0, 0, 0, 0.2) forState:UIControlStateNormal];
        [self.sendButton setTitleColor:RGBACOLOR(0, 0, 0, 0.2) forState:UIControlStateSelected];
        self.sendButton.layer.borderColor = RGBACOLOR(0, 0, 0, 0.2).CGColor;
    }else{
        self.sendButton.enabled = YES;
        [self.sendButton setTitleColor:self.configure.sendButtonTextColor forState:UIControlStateNormal];
        [self.sendButton setTitleColor:self.configure.sendButtonTextColor forState:UIControlStateSelected];
        self.sendButton.layer.borderColor = self.configure.sendButtonBorderColor.CGColor;
    }
    CGFloat contentSizeH = textView.contentSize.height;
    CGFloat lineH = textView.font.lineHeight;
    CGFloat maxTextViewHeight = ceil(lineH * self.configure.textViewMaxLine + textView.textContainerInset.top + textView.textContainerInset.bottom);
    if (contentSizeH <= maxTextViewHeight) {
        textView.cl_height = contentSizeH;
    }else{
        textView.cl_height = maxTextViewHeight;
    }
    CGFloat newHeight = ceil(textView.cl_height) + 10 + 10;
    CGFloat change = newHeight - self.cl_height;
    if (change != 0) {
        self.cl_height = newHeight;
        self.cl_top = self.cl_top - change;
    }
    [textView scrollRangeToVisible:NSMakeRange(textView.selectedRange.location, 1)];
}
- (void)tapActions:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self dissmissToolbar];
}
-(void)didClickSendButton {
    if (self.sendBlock) {
        self.sendBlock(self.textView.text);
    }
}
- (void)inputToolbarSendText:(inputToolBarSendBlock)sendBlock{
    self.sendBlock = sendBlock;
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (BOOL)canResignFirstResponder {
    return YES;
}
- (BOOL)becomeFirstResponder {
    return [self showToolbar];
}
- (BOOL)resignFirstResponder {
    return [self dissmissToolbar];
}
- (BOOL)showToolbar {
    if (self.keyboardIsShow) {
        return YES;
    }
    if (self.configure.showMaskView) {
        [self.keyWindow addSubview:self.maskView];
        [UIView animateWithDuration:0.25 animations:^{
            self.maskView.backgroundColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.4];
        }];
    }
    [self.keyWindow addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.textView];
    self.textView.inputAccessoryView = self;
    self.keyboardIsShow = YES;
    return [self.textView becomeFirstResponder];
}
-(BOOL)dissmissToolbar {
    if (!self.keyboardIsShow) {
        return YES;
    }
    self.textView.text = nil;
    self.textView.inputAccessoryView = nil;
    [self.textView.delegate textViewDidChange:self.textView];
    [self.backgroundView removeFromSuperview];
    if (self.configure.showMaskView) {
        [UIView animateWithDuration:0.25 animations:^{
            self.maskView.backgroundColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.0];
        }completion:^(BOOL finished) {
            [self.maskView removeFromSuperview];
        }];
    }
    self.keyboardIsShow = NO;
    return [self.textView resignFirstResponder];
}
- (void)clearText {
    self.textView.text = nil;
    [self.textView.delegate textViewDidChange:self.textView];
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (CGRectContainsPoint(self.textView.frame, point)) {
        return self.textView;
    }
    return hitView;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.maskView.cl_size = CGSizeMake(cl_screenWidth, cl_screenHeight);
    self.cl_width = cl_screenWidth;
    self.topLine.cl_left = 0;
    self.topLine.cl_top = 0;
    self.topLine.cl_width = self.cl_width;
    self.topLine.cl_height = 1;

    self.bottomLine.cl_left = 0;
    self.bottomLine.cl_bottom = 0;
    self.bottomLine.cl_width = self.cl_width;
    self.bottomLine.cl_height = 1;

    self.edgeLineView.cl_height = self.textView.cl_height + 10;
    self.edgeLineView.cl_width = self.cl_width - 50 - 30;
    self.edgeLineView.cl_left = 10;

    self.textView.cl_width = self.cl_width - 50 - 46;
    self.textView.cl_left = 18;

    self.placeholderLabel.cl_width = self.textView.cl_width - 10;
    self.placeholderLabel.cl_left = 23;
    self.placeholderLabel.cl_height = self.textView.cl_height;

    self.sendButton.cl_right = self.cl_width - 10;
    self.sendButton.cl_width = 50;
    self.sendButton.cl_height = 30;

    CGFloat contentSizeH = self.textView.contentSize.height;
    CGFloat lineH = self.textView.font.lineHeight;
    CGFloat maxTextViewHeight = ceil(lineH * self.configure.textViewMaxLine + self.textView.textContainerInset.top + self.textView.textContainerInset.bottom);
    if (contentSizeH <= maxTextViewHeight) {
        self.textView.cl_height = contentSizeH;
    }else{
        self.textView.cl_height = maxTextViewHeight;
    }

    CGFloat newHeight = ceil(self.textView.cl_height) + 10 + 10;
    CGFloat change = newHeight - self.cl_height;
    if (change != 0) {
        self.cl_height = newHeight;
        self.cl_top = self.cl_top - change;
    }
    self.edgeLineView.cl_centerY = self.cl_height * 0.5;
    self.placeholderLabel.cl_centerY = self.cl_height * 0.5;
    self.sendButton.cl_centerY = self.cl_height * 0.5;
    self.backgroundView.frame = [self convertRect:self.bounds toView:self.keyWindow];
    self.textView.cl_centerY = self.backgroundView.cl_height * 0.5;
}
//MARK:JmoVxia---懒加载
- (CLInputToolbarConfigure *) configure {
    if (_configure == nil) {
        _configure = [CLInputToolbarConfigure defaultConfigure];
    }
    return _configure;
}
- (UIView *) maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActions:)];
        [_maskView addGestureRecognizer:tapGestureRecognizer];
    }
    return _maskView;
}
- (UIView *) backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] init];
    }
    return _backgroundView;
}
- (UIView *) topLine {
    if (_topLine == nil) {
        _topLine = [[UIView alloc] init];
    }
    return _topLine;
}
- (UIView *) bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] init];
    }
    return _bottomLine;
}
- (UIView *) edgeLineView {
    if (_edgeLineView == nil) {
        _edgeLineView = [[UIView alloc]init];
        _edgeLineView.layer.cornerRadius = 5;
        _edgeLineView.layer.borderWidth = 1;
        _edgeLineView.layer.masksToBounds = YES;
    }
    return _edgeLineView;
}
- (UITextView *) textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];;
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.delegate = self;
        _textView.layoutManager.allowsNonContiguousLayout = NO;
        _textView.scrollsToTop = NO;
        _textView.textContainerInset = UIEdgeInsetsZero;
        _textView.textContainer.lineFragmentPadding = 0;
    }
    return _textView;
}
- (UILabel *) placeholderLabel {
    if (_placeholderLabel == nil) {
        _placeholderLabel = [[UILabel alloc] init];
    }
    return _placeholderLabel;
}
- (UIButton *) sendButton {
    if (_sendButton == nil) {
        _sendButton = [[UIButton alloc] init];
        _sendButton.layer.borderWidth = 1.0;
        _sendButton.layer.cornerRadius = 5.0;
        _sendButton.enabled = NO;
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(didClickSendButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}
- (UIWindow *) keyWindow {
    if (_keyWindow == nil) {
        _keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    return _keyWindow;
}


@end
