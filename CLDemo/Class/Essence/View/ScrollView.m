//
//  ScrollView.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "ScrollView.h"
#import "TitleButtonView.h"
@implementation ScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
    }
    return self;
}

-(void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    [self initViewWithArray:titleArray];

}

- (void)initViewWithArray:(NSArray *)array
{
    [self initUI];
    TitleButtonView *titleButtonView = [[TitleButtonView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    titleButtonView.array = array;
    titleButtonView.backgroundColor = [UIColor whiteColor];
    [self addSubview:titleButtonView];
}
- (void)initUI
{
    
}



@end
