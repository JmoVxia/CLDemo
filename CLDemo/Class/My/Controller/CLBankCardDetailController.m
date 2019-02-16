//
//  CLBankCardDetailController.m
//  CLDemo
//
//  Created by JmoVxia on 2019/2/17.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLBankCardDetailController.h"

@interface CLBankCardDetailController ()

@end

@implementation CLBankCardDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"银行卡详细信息";
    
    [self cardImage];
    
    [self content];
}

- (void)cardImage {
    
    UIImageView *cardImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 85, cl_screenWidth-20, cl_screenHeight/3)];
    cardImg.image = _bankCardModel.bankImage;
    
    [self.view addSubview:cardImg];
    
}

- (void)content {
    
    NSArray *titleArr = @[@"开户行：",@"卡号："];
    NSArray *contentArr = @[_bankCardModel.bankName ? _bankCardModel.bankName : @"",_bankCardModel.bankNumber ? _bankCardModel.bankNumber : @""];
    
    for (int i = 0; i < titleArr.count; i ++) {
        int count = 50*i;
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, cl_screenHeight/3+100+count, cl_screenWidth/4, 50)];
        titleLab.text = titleArr[i];
        [self.view addSubview:titleLab];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, cl_screenHeight/3+150+count, cl_screenWidth-20, 1)];
        lab.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:lab];
        
        UILabel *contentLab = [[UILabel alloc]initWithFrame:CGRectMake(cl_screenWidth/4+20, cl_screenHeight/3+100+count, cl_screenWidth*3/4-30, 50)];
        contentLab.numberOfLines = 0;
        contentLab.text = contentArr[i];
        [self.view addSubview:contentLab];
    }
    
    
}

-(void)dealloc{
    CLLog(@"详情页面销毁了");
}

@end
