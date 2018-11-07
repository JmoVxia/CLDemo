

//
//  MeController.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "CLMyController.h"
#import "CLChangeLanguageController.h"

@interface CLMyController ()

@end

@implementation CLMyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    self.navigationItem.title = NSLocalizedString(@"我的", nil);
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = cl_RandomColor;
    [button setTitle:NSLocalizedString(@"切换语言", nil) forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(@"切换语言", nil) forState:UIControlStateSelected];
    [button addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.center = self.view.center;
    [self.view addSubview:button];
}

- (void)settingAction {
    
    CLChangeLanguageController *languageController = [[CLChangeLanguageController alloc] init];
    [self.navigationController pushViewController:languageController animated:YES];
}




@end
