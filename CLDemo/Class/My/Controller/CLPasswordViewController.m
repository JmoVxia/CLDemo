//
//  CLPasswordViewController.m
//  CLDemo
//
//  Created by AUG on 2019/1/15.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLPasswordViewController.h"
#import "CLPasswordView.h"
#import "CLPassWordInputView.h"
#import "Masonry.h"

@interface CLPasswordViewController ()<CLPasswordInputViewDelegate>

@end

@implementation CLPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

//    CLPasswordView *pass = [CLPasswordView new];
//    [self.view addSubview:pass];
//    [pass mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(50);
//        make.centerY.mas_equalTo(0);
//    }];
//    [pass passwordEnd:^(NSString * _Nonnull password) {
//        NSLog(@"--->>>%@",password);
//    }];
    

    CLPasswordInputView *inputView = [CLPasswordInputView new];
    inputView.delegate = self;
    [self.view addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.centerY.mas_equalTo(0);
    }];
    
    [inputView updateWithConfig:^(CLPasswordInputViewConfigure * _Nonnull config) {
        config.pointColor = [UIColor redColor];
        config.rectColor = [UIColor orangeColor];
    }];
    
}

- (void)passwordInputViewDidChange:(CLPasswordInputView *)passwordInputView {
    NSLog(@"------>>>>>%@",passwordInputView.password);
}

- (void)passwordInputViewCompleteInput:(CLPasswordInputView *)passwordInputView {
    NSLog(@"输入完毕------%@",passwordInputView.password);
//    [passWord resignFirstResponder];
}
- (void)passwordInputViewDidDeleteBackward:(CLPasswordInputView *)passwordInputView {
    NSLog(@"----点击删除----");
}
- (void)passwordInputViewBeginInput:(CLPasswordInputView *)passwordInputView {
    NSLog(@"-----------开始输入++++++++++++");
}

- (void)passwordInputViewEndInput:(CLPasswordInputView *)passwordInputView {
    NSLog(@"-----------结束输入++++++++++++");
}

@end
