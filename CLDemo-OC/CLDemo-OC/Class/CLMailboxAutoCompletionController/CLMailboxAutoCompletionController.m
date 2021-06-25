//
//  CLMailboxAutoCompletionController.m
//  CLDemo
//
//  Created by AUG on 2019/8/3.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLMailboxAutoCompletionController.h"
#import "CLMailBoxTextView.h"
#import <Masonry/Masonry.h>

@interface CLMailboxAutoCompletionController ()<CLMailBoxTextViewDelegate>

///邮箱输入框
@property (nonatomic, strong) CLMailBoxTextView *mailBoxTextView;

@end

@implementation CLMailboxAutoCompletionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    [self.view addSubview:self.mailBoxTextView];
    [self.mailBoxTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    
    [self.mailBoxTextView becomeFirstResponder];
}
///开始输入
- (void)textViewBeginEditing:(CLMailBoxTextView *)texteView {
    NSLog(@"开始输入邮箱");
}
///结束输入
- (void)textViewEndEditing:(CLMailBoxTextView *)texteView {
    NSLog(@"结束输入邮箱---->%@",texteView.text);
}
///输入改变
- (void)textViewDidChange:(CLMailBoxTextView *)texteView {
    NSLog(@"当前邮箱输入----->%@",texteView.text);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (CLMailBoxTextView *) mailBoxTextView {
    if (_mailBoxTextView == nil) {
        _mailBoxTextView = [[CLMailBoxTextView alloc] init];
        _mailBoxTextView.delegate = self;
//        [_mailBoxTextView updateWithConfigure:^(CLMailBoxTextViewConfigure * _Nonnull configure) {
//            configure.font = [UIFont systemFontOfSize:18];
//            configure.textColor = [UIColor redColor];
//            configure.suffixColor = [UIColor orangeColor];
//            configure.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
//        }];
    }
    return _mailBoxTextView;
}
@end
