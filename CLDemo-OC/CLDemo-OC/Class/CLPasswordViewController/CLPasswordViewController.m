//
//  CLPasswordViewController.m
//  CLDemo
//
//  Created by AUG on 2019/1/15.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLPasswordViewController.h"
#import "CLPassWordInputView.h"
#import "CLCoreTextView.h"
#import "Masonry.h"

@interface CLPasswordViewController ()<CLPasswordInputViewDelegate>

@property (nonatomic, strong) UILabel *label1;

@property (nonatomic, strong) UILabel *label2;

@end

@implementation CLPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.label1 = [[UILabel alloc] init];
    [self.view addSubview:self.label1];
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).mas_equalTo(30);
        make.centerX.mas_equalTo(0);
    }];
    
    self.label2 = [[UILabel alloc] init];
    [self.view addSubview:self.label2];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.label1.mas_bottom).mas_equalTo(30);
        make.centerX.mas_equalTo(0);
    }];

    CLPasswordInputView *inputView = [CLPasswordInputView new];
    inputView.delegate = self;
    [self.view addSubview:inputView];

    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.centerY.mas_equalTo(0);
    }];

    [inputView updateWithConfigure:^(CLPasswordInputViewConfigure * _Nonnull configure) {
        configure.pointColor = [UIColor redColor];
        configure.rectColor = [UIColor blackColor];
        configure.rectBackgroundColor = [UIColor whiteColor];
        configure.backgroundColor = [UIColor whiteColor];
        configure.threePartyKeyboard = YES;
    }];
}

- (void)passwordInputViewDidChange:(CLPasswordInputView *)passwordInputView {
    self.label1.text = passwordInputView.text;
    self.label2.text = @"正在输入";
}
- (void)passwordInputViewCompleteInput:(CLPasswordInputView *)passwordInputView {
    self.label2.text = @"输入完毕";
}
- (void)passwordInputViewDidDeleteBackward:(CLPasswordInputView *)passwordInputView {
    self.label2.text = @"点击删除";
}
- (void)passwordInputViewBeginInput:(CLPasswordInputView *)passwordInputView {
    self.label2.text = @"开始输入";
}
- (void)passwordInputViewEndInput:(CLPasswordInputView *)passwordInputView {
    self.label2.text = @"结束输入";
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

@end
