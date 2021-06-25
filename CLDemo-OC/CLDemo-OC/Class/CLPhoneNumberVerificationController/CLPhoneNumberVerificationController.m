//
//  CLPhoneNumberVerificationController.m
//  CLDemo
//
//  Created by AUG on 2019/12/9.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLPhoneNumberVerificationController.h"
#import "CLPhoneNumberHelper.h"
#import <Masonry/Masonry.h>

@interface CLPhoneNumberVerificationController ()

///helper
@property (nonatomic, strong) CLPhoneNumberHelper *helper;

@property (nonatomic, strong) UITextField *countryField;

@property (nonatomic, strong) UITextField *phoneField;

@property (nonatomic, strong) UILabel *label;

@end

@implementation CLPhoneNumberVerificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.helper = [CLPhoneNumberHelper new];
    
    self.countryField = [UITextField new];
    self.countryField.placeholder = @"国家码";
    self.countryField.backgroundColor = [UIColor orangeColor];
    [self.countryField addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.countryField];
    [self.countryField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(240);
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(50);
    }];

    self.phoneField = [UITextField new];
    self.phoneField.placeholder = @"手机号";
    self.phoneField.backgroundColor = [UIColor cyanColor];
    [self.phoneField addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.phoneField];
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view);
        make.left.mas_equalTo(self.countryField.mas_right);
        make.height.mas_equalTo(50);
        make.centerY.mas_equalTo(self.countryField);
    }];

    
    self.label = [UILabel new];
    [self.view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.countryField.mas_bottom).mas_offset(90);
        make.centerX.mas_equalTo(self.view);
    }];
    
}
- (void) textChangeAction:(UITextField *) sender {
    self.label.text = [self.helper verifyCountryCode:self.countryField.text phoneNumber:self.phoneField.text] ? @"YES" : @"NO";
    [self.label sizeToFit];
}



@end
