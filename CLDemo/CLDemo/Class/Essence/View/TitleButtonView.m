//
//  TitleButtonView.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "TitleButtonView.h"

@interface TitleButtonView ()

@property (nonatomic,weak) UIButton *selectedButton;
@property (nonatomic,weak) UIView *selectedView;

@end

@implementation TitleButtonView



-(void)setArray:(NSArray *)array
{

    [self initViewsWithArray:array];

}

- (void)initViewsWithArray:(NSArray *)array
{
    CGFloat width = self.width/5.0;
    self.contentSize = CGSizeMake(width*array.count, self.height);
//    self.bounces = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    for (NSInteger i = 0; i<array.count; i++)
    {
        UIButton * button = [[UIButton alloc]init];
        button.frame = CGRectMake(i*width, 0, width, self.height);
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:button];
    }
    UIButton *fristButton = self.subviews.firstObject;
    UIView *view = [[UIView alloc]init];
    view.height = 2;
    view.top = self.height-view.height;
    view.backgroundColor = [fristButton titleColorForState:UIControlStateSelected];
    [self addSubview:view];
    self.selectedView = view;
    //根据文字内容计算宽高
    [fristButton.titleLabel sizeToFit];
    //设置位置
    view.width = fristButton.titleLabel.width;
    view.centerX = fristButton.centerX;
    //默认选中第一个按钮
    [self buttonAction:fristButton];
}

- (void)buttonAction:(UIButton *)button
{
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.selectedView.width = button.titleLabel.width;
        self.selectedView.centerX = button.centerX;
    }];
    
    //计算按钮和屏幕中间需要的偏移量
    CGFloat offsetX = button.centerX - ScreenWidth / 2.0;
    //屏幕左边按钮,重置偏移
    if (offsetX < 0)
    {
        offsetX = 0;
    }
    else
    {
        //得到最大偏移量
        CGFloat maxOffsetX = self.contentSize.width - ScreenWidth;
        // 处理最大偏移量
        if (offsetX > maxOffsetX)
        {
            offsetX = maxOffsetX;
        }
    }
    //设置偏移
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}





@end
