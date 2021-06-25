//
//  CLChartToolBar.m
//  CLDemo
//
//  Created by JmoVxia on 2017/3/11.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLChartToolBar.h"
#import "UIColor+CLHex.h"
#import "Masonry.h"
#import "UIView+CLSetRect.h"

@interface CLChartToolBar ()
/**一周*/
@property(nonatomic,weak)UIButton *weekBtn;
/** 一个月*/
@property(nonatomic,weak)UIButton *oneMonthBtn;
/** 三个月*/
@property(nonatomic,weak)UIButton *threeMonthBtn;
/** 六个月*/
@property(nonatomic,weak)UIButton *sixMonthBtn;
/** 一年*/
@property(nonatomic,weak)UIButton *yearBtn;
/** 被选中的button*/
@property(nonatomic,weak)UIButton *selectedBtn;
/**线*/
@property (nonatomic,weak) UIView *lineView;



@end

@implementation CLChartToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //时间工具条
        _dateToolBar = [UIView new];
        [self addSubview:_dateToolBar];
        
        //名称工具条
        _nameToolBar = [CLChartNameToolBar new];
        [self addSubview:_nameToolBar];
        
        
        //一周
        UIButton *weekBtn           = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.weekBtn                = weekBtn;
        [weekBtn setTitleColor:[UIColor colorWithHex:@"#999999"] forState:(UIControlStateNormal)];
        [weekBtn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:(UIControlStateSelected)];
        [weekBtn setTitle:@"一周" forState:(UIControlStateNormal)];
        [self.dateToolBar addSubview:weekBtn];
        [weekBtn addTarget:self action:@selector(onClickWeek:) forControlEvents:(UIControlEventTouchUpInside)];
        //一个月
        UIButton *oneMonthBtn           = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.oneMonthBtn                = oneMonthBtn;
        [oneMonthBtn setTitleColor:[UIColor colorWithHex:@"#999999"] forState:(UIControlStateNormal)];
        [oneMonthBtn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:(UIControlStateSelected)];
        [oneMonthBtn setTitle:@"1个月" forState:(UIControlStateNormal)];
        [self.dateToolBar addSubview:oneMonthBtn];
        [oneMonthBtn addTarget:self action:@selector(onClickOneMonthBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        //3
        UIButton *threeMonthBtn           = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.threeMonthBtn                = threeMonthBtn;
        [threeMonthBtn setTitleColor:[UIColor colorWithHex:@"#999999"] forState:(UIControlStateNormal)];
        [threeMonthBtn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:(UIControlStateSelected)];
        [threeMonthBtn setTitle:@"3个月" forState:(UIControlStateNormal)];
        [self.dateToolBar addSubview:threeMonthBtn];
        [threeMonthBtn addTarget:self action:@selector(onClickThreeMonthBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        //6
        UIButton *sixMonthBtn           = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.sixMonthBtn                = sixMonthBtn;
        [sixMonthBtn setTitleColor:[UIColor colorWithHex:@"#999999"] forState:(UIControlStateNormal)];
        [sixMonthBtn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:(UIControlStateSelected)];
        [sixMonthBtn setTitle:@"6个月" forState:(UIControlStateNormal)];
        [self.dateToolBar addSubview:sixMonthBtn];
        [sixMonthBtn addTarget:self action:@selector(onClickSixMonthBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        //year
        UIButton *yearBtn           = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.yearBtn                = yearBtn;
        [yearBtn setTitleColor:[UIColor colorWithHex:@"#999999"] forState:(UIControlStateNormal)];
        [yearBtn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:(UIControlStateSelected)];
        [yearBtn setTitle:@"一年" forState:(UIControlStateNormal)];
        [self.dateToolBar addSubview:yearBtn];
        [yearBtn addTarget:self action:@selector(onClickYearBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRed:0.83529 green:0.83529 blue:0.83529 alpha:1.00000];
        [self.dateToolBar addSubview:lineView];
        _lineView = lineView;
        
        self.nameToolBar.hidden = NO;
        self.dateToolBar.hidden = YES;
        [self fitUI];
        
    }
    return self;
}

- (void)fitUI {
    
    [self.dateToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    [self.nameToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    [self.weekBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_equalTo(self.dateToolBar);
        make.width.mas_equalTo(self.dateToolBar).multipliedBy(0.2);
    }];
    [self.oneMonthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.weekBtn.mas_right);
        make.top.bottom.mas_equalTo(self.dateToolBar);
        make.width.mas_equalTo(self.dateToolBar).multipliedBy(0.2);
    }];
    [self.threeMonthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.oneMonthBtn.mas_right);
        make.top.bottom.mas_equalTo(self.dateToolBar);
        make.width.mas_equalTo(self.dateToolBar).multipliedBy(0.2);
    }];
    [self.sixMonthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.threeMonthBtn.mas_right);
        make.top.bottom.mas_equalTo(self.dateToolBar);
        make.width.mas_equalTo(self.dateToolBar).multipliedBy(0.2);
    }];
    [self.yearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sixMonthBtn.mas_right);
        make.top.bottom.mas_equalTo(self.dateToolBar);
        make.width.mas_equalTo(self.dateToolBar).multipliedBy(0.2);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self.dateToolBar);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(cl_screenHeight);
    }];
    
}

#pragma mark -Action
- (void)onClickWeek:(UIButton*)btn {
    self.selectedBtn.selected = !self.selectedBtn.isSelected;
    btn.selected              = !btn.isSelected;
    self.selectedBtn = btn;
    if (self.delegate && [self.delegate respondsToSelector:@selector(maxChartLegendViewDidSelectedWeek:)]) {
        [self.delegate maxChartLegendViewDidSelectedWeek:btn];
    }
}
- (void)onClickOneMonthBtn:(UIButton*)btn {
    self.selectedBtn.selected = !self.selectedBtn.isSelected;
    btn.selected              = !btn.isSelected;
    self.selectedBtn = btn;
    if (self.delegate && [self.delegate respondsToSelector:@selector(maxChartLegendViewDidSelectedOneMonth:)]) {
        [self.delegate maxChartLegendViewDidSelectedOneMonth:btn];
    }
}
- (void)onClickThreeMonthBtn:(UIButton*)btn {
    self.selectedBtn.selected = !self.selectedBtn.isSelected;
    btn.selected              = !btn.isSelected;
    self.selectedBtn = btn;
    if (self.delegate && [self.delegate respondsToSelector:@selector(maxChartLegendViewDidSelectedThreeMonth:)]) {
        [self.delegate maxChartLegendViewDidSelectedThreeMonth:btn];
    }
}
- (void)onClickSixMonthBtn:(UIButton*)btn {
    self.selectedBtn.selected = !self.selectedBtn.isSelected;
    btn.selected              = !btn.isSelected;
    self.selectedBtn = btn;
    if (self.delegate && [self.delegate respondsToSelector:@selector(maxChartLegendViewDidSelectedSixMonth:)]) {
        [self.delegate maxChartLegendViewDidSelectedSixMonth:btn];
    }
}
- (void)onClickYearBtn:(UIButton*)btn {
    self.selectedBtn.selected = !self.selectedBtn.isSelected;
    btn.selected              = !btn.isSelected;
    self.selectedBtn = btn;
    if (self.delegate && [self.delegate respondsToSelector:@selector(maxChartLegendViewDidSelectedYear:)]) {
        [self.delegate maxChartLegendViewDidSelectedYear:btn];
    }
}

-(void)setNameString:(NSString *)nameString{
    _nameString = nameString;
    _nameToolBar.nameString = _nameString;
}
- (void)selectedFirst {
    [self onClickWeek:self.weekBtn];
}


@end
