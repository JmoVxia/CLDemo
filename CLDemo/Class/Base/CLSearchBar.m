//
//  CLSearchBar.m
//  AISchoolDiscipline
//
//  Created by JmoVxia on 2016/12/10.
//  Copyright © 2016年 艾泽鑫. All rights reserved.
//

#import "CLSearchBar.h"

@implementation CLSearchBar

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
#pragma mark - UI
- (void)initUI{
    
    // 设置背景图片
    //        self.background = [UIImage resizeImageWithName:@"searchbar_textfield_background_os7@2x"];
    
    self.backgroundColor = [UIColor whiteColor];
    // 设置圆角
    //        self.layer.cornerRadius = 5;
    
    // 设置字体
    self.font = [UIFont clFontOfSize:14];
    
    
    // 设置清楚按钮
    self.clearButtonMode = UITextFieldViewModeAlways;
    
    
    // 设置默认提示文字
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor grayColor];
    self.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"搜索" attributes:dict];
    
    
    /**
     * 左边放大镜图标
     */
    UIImageView * iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"]];
    
    // 让放大镜图片居中
    iconView.contentMode = UIViewContentModeCenter;
    // 把放大镜赋值给leftview
    self.leftView = iconView;
    // 让leftview显示
    self.leftViewMode = UITextFieldViewModeUnlessEditing;
    
    
}
// 重写来编辑区域，可以改变光标起始位置，以及光标最右到什么地方，placeHolder的位置也会改变
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    [super editingRectForBounds:bounds];
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width-25, bounds.size.height);//更好理解些
    return inset;
}
// 修改文本展示区域，一般跟editingRectForBounds一起重写,可以改变占位文字颜色
- (CGRect)textRectForBounds:(CGRect)bounds
{
    [super textRectForBounds:bounds];
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width-25, bounds.size.height);//更好理解些
    return inset;
}
// 控制placeHolder的位置，左右缩20，但是光标位置不变
/*
 -(CGRect)placeholderRectForBounds:(CGRect)bounds
 {
 CGRect inset = CGRectMake(bounds.origin.x+100, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
 return inset;
 }
 */

-(void)layoutSubviews
{
    [super layoutSubviews];
    // 设置左侧图片的frame
    self.leftView.frame = CGRectMake(self.frame.size.width - 50, 0, 50, self.frame.size.height);
}



@end
