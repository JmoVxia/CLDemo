//
//  CLChartToolBar.m
//  CLDemo
//
//  Created by JmoVxia on 2017/3/11.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLChartToolBar.h"
#import "UIColor+AIExtension.h"

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
/** 缩放*/
@property(nonatomic,weak)UIButton *zoomBtn;
/** 被选中的button*/
@property(nonatomic,weak)UIButton *selectedBtn;
/**名称label*/
@property (nonatomic,weak) UILabel *nameLable;

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
        _nameToolBar = [UIView new];
        [self addSubview:_nameToolBar];
        
        //名称label
        UILabel *nameLabel = [UILabel new];
        [self.nameToolBar addSubview:nameLabel];
        _nameLable = nameLabel;
        
        //一周
        UIButton *weekBtn           = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.weekBtn                = weekBtn;
        [weekBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
        [weekBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateSelected)];
        [weekBtn setTitle:@"一周" forState:(UIControlStateNormal)];
        [self.dateToolBar addSubview:weekBtn];
        [weekBtn addTarget:self action:@selector(onClickWeek:) forControlEvents:(UIControlEventTouchUpInside)];
        //一个月
        UIButton *oneMonthBtn           = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.oneMonthBtn                = oneMonthBtn;
        [oneMonthBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
        [oneMonthBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateSelected)];
        [oneMonthBtn setTitle:@"1个月" forState:(UIControlStateNormal)];
        [self.dateToolBar addSubview:oneMonthBtn];
        [oneMonthBtn addTarget:self action:@selector(onClickOneMonthBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        //3
        UIButton *threeMonthBtn           = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.threeMonthBtn                = threeMonthBtn;
        [threeMonthBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
        [threeMonthBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateSelected)];
        [threeMonthBtn setTitle:@"3个月" forState:(UIControlStateNormal)];
        [self.dateToolBar addSubview:threeMonthBtn];
        [threeMonthBtn addTarget:self action:@selector(onClickThreeMonthBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        //6
        UIButton *sixMonthBtn           = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.sixMonthBtn                = sixMonthBtn;
        [sixMonthBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
        [sixMonthBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateSelected)];
        [sixMonthBtn setTitle:@"6个月" forState:(UIControlStateNormal)];
        [self.dateToolBar addSubview:sixMonthBtn];
        [sixMonthBtn addTarget:self action:@selector(onClickSixMonthBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        //year
        UIButton *yearBtn           = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.yearBtn                = yearBtn;
        [yearBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
        [yearBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateSelected)];
        [yearBtn setTitle:@"一年" forState:(UIControlStateNormal)];
        [self.dateToolBar addSubview:yearBtn];
        [yearBtn addTarget:self action:@selector(onClickYearBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        //缩放
        UIButton *zoomBtn           = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.zoomBtn                = zoomBtn;
        self.zoomBtn.backgroundColor = [UIColor redColor];
        [self addSubview:zoomBtn];
        [zoomBtn setImage:[UIImage imageNamed:@"collapse_icon"] forState:(UIControlStateNormal)];
        [zoomBtn addTarget:self action:@selector(onClickZoomBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        
        self.nameToolBar.hidden = NO;
        self.dateToolBar.hidden = YES;
        [self fitUI];
        
    }
    return self;
}

- (void)fitUI {
    
    [self.dateToolBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.right.equalTo(-50);
    }];
    [self.nameToolBar makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.dateToolBar);
    }];
    [self.nameLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameToolBar).offset(10);
        make.top.bottom.right.equalTo(self.nameToolBar);
    }];
    [self.zoomBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(-10);
        make.width.height.equalTo(40);
    }];
    [self.weekBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self.dateToolBar);
        make.width.equalTo(self.dateToolBar).multipliedBy(0.2);
    }];
    [self.oneMonthBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekBtn.right);
        make.top.bottom.equalTo(self.dateToolBar);
        make.width.equalTo(self.dateToolBar).multipliedBy(0.2);
    }];
    [self.threeMonthBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.oneMonthBtn.right);
        make.top.bottom.equalTo(self.dateToolBar);
        make.width.equalTo(self.dateToolBar).multipliedBy(0.2);
    }];
    [self.sixMonthBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.threeMonthBtn.right);
        make.top.bottom.equalTo(self.dateToolBar);
        make.width.equalTo(self.dateToolBar).multipliedBy(0.2);
    }];
    [self.yearBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sixMonthBtn.right);
        make.top.bottom.equalTo(self.dateToolBar);
        make.width.equalTo(self.dateToolBar).multipliedBy(0.2);
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
- (void)onClickZoomBtn:(UIButton*)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(maxChartLegendViewDidSelectedZoom:)]) {
        [self.delegate maxChartLegendViewDidSelectedZoom:btn];
    }
}
-(void)setNameString:(NSString *)nameString{
    _nameString = nameString;
    _nameLable.text = _nameString;
}
- (void)selectedFirst {
    [self onClickWeek:self.weekBtn];
}


@end
