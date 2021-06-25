//
//  CLMailBoxTextView.m
//  CLDemo
//
//  Created by AUG on 2019/8/3.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLMailBoxTextView.h"
#import "Masonry.h"

@interface CLMailBoxTextView ()<UITextFieldDelegate>

///输入框
@property (nonatomic, strong) UITextField *textField;
///邮箱labale
@property (nonatomic, strong) UILabel *emailLabel;
///完整的邮箱
@property (nonatomic, copy) NSString *email;
///输入的文字
@property (nonatomic, copy, nullable) NSString *text;
///配置
@property (nonatomic, strong) CLMailBoxTextViewConfigure *configure;

@end


@implementation CLMailBoxTextViewConfigure

+ (instancetype)defaultConfigure {
    CLMailBoxTextViewConfigure *configure = [[CLMailBoxTextViewConfigure alloc] init];
    configure.mailMatchingArray = @[
                                   @"@gmail.com",
                                   @"@yahoo.com",
                                   @"@msn.com",
                                   @"@hotmail.com",
                                   @"@aol.com",
                                   @"@ask.com",
                                   @"@live.com",
                                   @"@qq.com",
                                   @"@0355.net",
                                   @"@163.com",
                                   @"@163.net",
                                   @"@263.net",
                                   @"@3721.net",
                                   @"@yeah.net",
                                   @"@googlemail.com",
                                   @"@mail.com",
                                   ];
    configure.edgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    configure.font = [UIFont systemFontOfSize:15];
    configure.textColor = [UIColor blackColor];
    configure.suffixColor = [UIColor colorWithRed:0.71 green:0.72 blue:0.72 alpha:1.00];
    return configure;
}

@end


@implementation CLMailBoxTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self mas_makeConstraints];
    }
    return self;
}
//MARK:JmoVxia---创建UI
- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    self.textField.placeholder = @"请输入邮箱";
    [self addSubview:self.emailLabel];
    [self addSubview:self.textField];
}
//MARK:JmoVxia---约束
- (void)mas_makeConstraints {
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.configure.edgeInsets);
    }];
    [self.emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.textField);
    }];
}
- (void)updateWithConfigure:(void(^)(CLMailBoxTextViewConfigure *configure))configureBlock {
    if (configureBlock) {
        configureBlock(self.configure);
    }
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.configure.edgeInsets);
    }];
    self.textField.font = self.configure.font;
    self.textField.textColor = self.configure.textColor;
    self.emailLabel.font = self.configure.font;
    self.emailLabel.textColor = self.configure.suffixColor;
    configureBlock = nil;
}
//MARK:JmoVxia---UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //获取完整的输入文本
    NSString *completeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //以@符号分割文本
    NSArray<NSString *> *emailStringArray = [completeString componentsSeparatedByString:@"@"];
    //获取邮箱前缀
    NSString *emailString = [emailStringArray firstObject];
    //邮箱匹配 没有输入@符号时 用@匹配
    NSString *matchString = @"@";
    if(emailStringArray.count > 1){
        //如果已经输入@符号 截取@符号以后的字符串作为匹配字符串
        matchString = [completeString substringFromIndex:emailString.length];
    }
    //匹配邮箱 得到所有跟当前输入匹配的邮箱后缀
    NSArray *suffixArray = [self checkEmailString:matchString];
    //边界控制 如果没有跟当前输入匹配的后缀置为@""
    NSString *fixString = suffixArray.count > 0 ? [suffixArray firstObject] : @"";
    //将Email部分字段隐藏
    NSInteger cutLenth = suffixArray.count > 0 ? completeString.length : emailString.length;
    //最终的邮箱地址
    self.email = fixString.length > 0 ? [NSString stringWithFormat:@"%@%@",emailString,fixString] : completeString;
    //设置Email的attribute
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@", emailString, fixString]];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0, cutLenth)];
    self.emailLabel.attributedText = attributeString;
    //清空文本框内容时 隐藏Email
    if(completeString.length == 0){
        self.emailLabel.text = nil;
        self.email = nil;
    }
    self.text = completeString;
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    textField.text = self.email;
    self.text = self.email;
    self.emailLabel.text = nil;
    [self textFieldDidEndEditing:textField];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewBeginEditing:)]) {
        [self.delegate textViewBeginEditing:self];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.text = self.email;
    self.text = self.email;
    self.emailLabel.text = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewEndEditing:)]) {
        [self.delegate textViewEndEditing:self];
    }
}
- (BOOL)becomeFirstResponder {
    return [self.textField becomeFirstResponder];
}
- (BOOL)resignFirstResponder {
    return [self.textField resignFirstResponder];
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (BOOL)canResignFirstResponder {
    return YES;
}
///清除文字
- (void)clearText {
    self.textField.text = nil;
    self.emailLabel.text = nil;
    self.text = nil;
    self.email = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
}
/**
 *  替换邮箱匹配类型
 *
 *  @param string 匹配的字段
 *
 *  @return 匹配成功的Array
 */
- (NSArray *)checkEmailString:(NSString *)string {
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@",string];
    return [self.configure.mailMatchingArray filteredArrayUsingPredicate:predicate];
}
//MARK: - JmoVxia---懒加载
- (UITextField *) textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.keyboardType = UIKeyboardTypeEmailAddress;
        _textField.font = self.configure.font;
        _textField.textColor = self.configure.textColor;
        _textField.delegate = self;
    }
    return _textField;
}
- (UILabel *) emailLabel {
    if (_emailLabel == nil) {
        _emailLabel = [[UILabel alloc] init];
        _emailLabel.font = self.configure.font;
        _emailLabel.textColor = self.configure.suffixColor;
    }
    return _emailLabel;
}
- (CLMailBoxTextViewConfigure *) configure {
    if (_configure == nil) {
        _configure = [CLMailBoxTextViewConfigure defaultConfigure];
    }
    return _configure;
}

@end
