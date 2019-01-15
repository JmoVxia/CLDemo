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

@interface CLPasswordViewController ()<CLPassWordInputViewDelegate>

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
    

    CLPassWordInputView *inputView = [CLPassWordInputView new];
    inputView.delegate = self;
    [inputView becomeFirstResponder];
    [self.view addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.centerY.mas_equalTo(0);
    }];
    
    
}

/**
 *  监听输入的改变
 */
- (void)passWordDidChange:(CLPassWordInputView *)passWord {
    NSLog(@"------>>>>>%@",passWord.textStore);
}

/**
 *  监听输入的完成时
 */
- (void)passWordCompleteInput:(CLPassWordInputView *)passWord {
    NSLog(@"输入完毕------%@",passWord.textStore);
//    [passWord endEditing:YES];
}

/**
 *  监听开始输入
 */
- (void)passWordBeginInput:(CLPassWordInputView *)passWord {
    NSLog(@"-----------开始输入++++++++++++");
}

@end
