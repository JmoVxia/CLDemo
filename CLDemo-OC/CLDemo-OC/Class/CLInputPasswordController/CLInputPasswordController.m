//
//  CLInputPasswordController.m
//  CLDemo
//
//  Created by AUG on 2019/9/17.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLInputPasswordController.h"
#import "CLInputPasswordToolBar.h"
#import "UIView+CLSetRect.h"

@interface CLInputPasswordController ()

@property (nonatomic, strong) UIButton *btn;

///密码工具条
@property (nonatomic, strong) CLInputPasswordToolBar *passwordToolBar;

@end

@implementation CLInputPasswordController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btn = [[UIButton alloc] init];
    [self.btn setBackgroundColor:[UIColor orangeColor]];
    [self.btn setTitle:@"点我" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(didTouchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
}



-(void)didTouchBtn {
    [self.passwordToolBar showToolbar];
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.btn.frame = CGRectMake(10, 150, self.view.cl_width - 20, 100);
}
-(void)dealloc {
    NSLog(@"自定义输入框页面销毁了");
}
- (CLInputPasswordToolBar *) passwordToolBar {
    if (_passwordToolBar == nil) {
        _passwordToolBar = [[CLInputPasswordToolBar alloc] init];
    }
    return _passwordToolBar;
}
@end
