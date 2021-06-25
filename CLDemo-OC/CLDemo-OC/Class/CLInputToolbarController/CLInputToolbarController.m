//
//  CLInputToolbarController.m
//  CLDemo
//
//  Created by AUG on 2019/2/16.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLInputToolbarController.h"
#import "CLInputToolbar.h"
#import "UIView+CLSetRect.h"

@interface CLInputToolbarController ()

@property (nonatomic, strong) CLInputToolbar *inputToolbar;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation CLInputToolbarController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.inputToolbar resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btn = [[UIButton alloc] init];
    [self.btn setBackgroundColor:[UIColor orangeColor]];
    [self.btn setTitle:@"点我" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(didTouchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    // 输入框
    [self setTextViewToolbar];
    
}

-(void)setTextViewToolbar {
    self.inputToolbar = [[CLInputToolbar alloc] init];
    [self.inputToolbar updateWithConfig:^(CLInputToolbarConfigure *configure) {
        //这里的block是一个局部变量，不会造成循环引用，内部可以使用self
        NSLog(@"我不会被循环引用%@",self);
        configure.textViewMaxLine = 4;
        configure.font = [UIFont systemFontOfSize:10];
        configure.showMaskView = YES;
//        configure.cursorColor = [UIColor redColor];
//        configure.textColor = cl_RandomColor;
//        configure.backgroundColor = cl_RandomColor;
//        configure.topLineColor = cl_RandomColor;
//        configure.bottomLineColor = cl_RandomColor;
//        configure.edgeLineViewColor = cl_RandomColor;
//        configure.sendButtonBorderColor = cl_RandomColor;
//        configure.sendButtonTextColor = cl_RandomColor;
//        configure.placeholderTextColor = cl_RandomColor;
    }];
    __weak __typeof(self) weakSelf = self;
    [self.inputToolbar inputToolbarSendText:^(NSString *text) {
        __typeof(&*weakSelf) strongSelf = weakSelf;
        NSLog(@"%@",text);
        [strongSelf.btn setTitle:text forState:UIControlStateNormal];
        // 清空输入框文字
        [strongSelf.inputToolbar clearText];
    }];
}

-(void)didTouchBtn {
    [self.inputToolbar becomeFirstResponder];
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.btn.frame = CGRectMake(10, 150, self.view.cl_width - 20, 100);
}
-(void)dealloc {
    NSLog(@"自定义输入框页面销毁了");
}
@end
