//
//  CLPopArrowViewController.m
//  CLDemo
//
//  Created by AUG on 2019/4/21.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLPopArrowViewController.h"
#import "CLPopArrowView.h"

@interface CLPopArrowViewController ()

@property(strong,readwrite,nonatomic)UIButton *button;



@end

@implementation CLPopArrowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _button=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2-50, 100, 100, 30)];
    _button.center = self.view.center;
    [_button setTitle:@"测试" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
    _button.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_button];
    
    
}

-(void)btnclick
{
    CGPoint point = CGPointMake(_button.frame.origin.x + _button.frame.size.width/2, _button.frame.origin.y + _button.frame.size.height);//箭头点的位置
    CLPopArrowView *view = [[CLPopArrowView alloc] initWithOrigin:point width:200 Height:300 direction:CLArrowDirectionTopRight];//初始化弹出视图的箭头顶点位置point，展示视图的宽度Width，高度Height，Direction以及展示的方向
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    lable.text = @"测试内容";
    lable.textColor = [UIColor whiteColor];
    [view.contentView addSubview:lable];
    [view popView];
    
}


@end
