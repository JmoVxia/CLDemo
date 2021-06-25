//
//  CLCustomQRCodeController.m
//  CLDemo
//
//  Created by AUG on 2019/4/5.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLCustomQRCodeController.h"
#import "UIImage+CLQRCode.h"
#import "UIView+CLSetRect.h"

@interface CLCustomQRCodeController ()

///imageView
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CLCustomQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [self.view addSubview:self.imageView];
    CLCorrectionConfigure *configure = [CLCorrectionConfigure initConfigure:@"https://www.baidu.com" callBack:^(CLCorrectionConfigure * _Nonnull configure) {
        configure.leftTopOutColor = cl_RandomColor;
        configure.leftTopInColor = cl_RandomColor;
        configure.rightTopOutColor = cl_RandomColor;
        configure.rightTopInColor = cl_RandomColor;
        configure.leftBottomOutColor = cl_RandomColor;
        configure.leftBottomInColor = cl_RandomColor;
        configure.colorsArray = [NSMutableArray arrayWithArray:@[cl_RandomColor, cl_RandomColor, cl_RandomColor, cl_RandomColor, cl_RandomColor, cl_RandomColor, cl_RandomColor, cl_RandomColor, cl_RandomColor, cl_RandomColor]];
    }];
    self.imageView.image = [UIImage generateQRCodeWithConfigure:configure];
    self.imageView.center = self.view.center;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CLCorrectionConfigure *configure = [CLCorrectionConfigure initConfigure:@"https://www.baidu.com" callBack:^(CLCorrectionConfigure * _Nonnull configure) {
        configure.leftTopOutColor = cl_RandomColor;
        configure.leftTopInColor = cl_RandomColor;
        configure.rightTopOutColor = cl_RandomColor;
        configure.rightTopInColor = cl_RandomColor;
        configure.leftBottomOutColor = cl_RandomColor;
        configure.leftBottomInColor = cl_RandomColor;
        configure.colorsArray = [NSMutableArray arrayWithArray:@[cl_RandomColor, cl_RandomColor, cl_RandomColor, cl_RandomColor, cl_RandomColor, cl_RandomColor, cl_RandomColor, cl_RandomColor, cl_RandomColor, cl_RandomColor]];
    }];
    
    self.imageView.image = [UIImage generateQRCodeWithConfigure:configure];
    self.imageView.center = self.view.center;
}


@end
