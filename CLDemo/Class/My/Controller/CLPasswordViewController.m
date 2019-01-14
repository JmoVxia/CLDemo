//
//  CLPasswordViewController.m
//  CLDemo
//
//  Created by AUG on 2019/1/15.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLPasswordViewController.h"
#import "CLPasswordView.h"
#import "Masonry.h"

@interface CLPasswordViewController ()

@end

@implementation CLPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    CLPasswordView *pass = [CLPasswordView new];
    [self.view addSubview:pass];
    [pass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.centerY.mas_equalTo(0);
    }];
    [pass passwordEnd:^(NSString * _Nonnull password) {
        NSLog(@"--->>>%@",password);
    }];
    

}



@end
