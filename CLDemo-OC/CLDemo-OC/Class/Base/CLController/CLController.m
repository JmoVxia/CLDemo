//
//  CLController.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "CLController.h"

@interface CLController ()

@end

@implementation CLController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //JmoVxia---统一设置返回按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = NSLocalizedString(@"返回", nil);
    self.navigationItem.backBarButtonItem = backBtn;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

@end
