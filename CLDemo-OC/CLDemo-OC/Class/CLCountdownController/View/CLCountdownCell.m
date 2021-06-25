//
//  CLCountdownCell.m
//  CLDemo
//
//  Created by AUG on 2019/6/6.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLCountdownCell.h"
#import "CLCountdownModel.h"
#import "Masonry.h"
#import "UIButton+CLBlockAction.h"

@interface CLCountdownCell ()

///位置
@property (nonatomic, strong) UILabel *rowLabel;
///时间
@property (nonatomic, strong) UILabel *timeLabel;
///暂停按钮
@property (nonatomic, strong) UIButton *pauseButton;

@end

@implementation CLCountdownCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        [self mas_makeConstraints];
    }
    return self;
}
- (void)initUI {
    [self.contentView addSubview:self.rowLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.pauseButton];
}
- (void)mas_makeConstraints {
    [self.rowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(10);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.rowLabel);
    }];
    [self.pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(40);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
}
- (void)setModel:(CLCountdownModel *)model {
    _model = model;
    self.rowLabel.text = [NSString stringWithFormat:@"%ld",model.row];
    self.timeLabel.text = [self fomatDate:model.remainingTime];
    self.pauseButton.selected = _model.isPause;
}
- (NSString *)fomatDate:(NSInteger)timeInterval {
    if (timeInterval > 0) {
        int days = (int)(timeInterval/(3600*24));
        int hours = (int)((timeInterval-days*24*3600)/3600);
        int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
        int seconds = (int)(timeInterval-days*24*3600-hours*3600-minutes*60);
        NSString *hoursStr;
        NSString *minutesStr;
        NSString *secondsStr;
        
        //小时
        if (hours < 10) {
            hoursStr = [NSString stringWithFormat:@"0%d",hours];
        }else {
            hoursStr = [NSString stringWithFormat:@"%d",hours];
        }
        
        //分钟
        if(minutes<10) {
            minutesStr = [NSString stringWithFormat:@"0%d",minutes];
        }else {
            minutesStr = [NSString stringWithFormat:@"%d",minutes];
        }
        //秒
        if(seconds < 10) {
            secondsStr = [NSString stringWithFormat:@"0%d", seconds];
        }else {
            secondsStr = [NSString stringWithFormat:@"%d",seconds];
        }
        
        return [NSString stringWithFormat:@"%@:%@:%@", hoursStr ,minutesStr, secondsStr];
    }else {
        return @"00:00:00";
    }
}
- (UILabel *) rowLabel {
    if (_rowLabel == nil) {
        _rowLabel = [[UILabel alloc] init];
    }
    return _rowLabel;
}
- (UILabel *) timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
    }
    return _timeLabel;
}
- (UIButton *) pauseButton {
    if (_pauseButton == nil) {
        _pauseButton = [[UIButton alloc] init];
        [_pauseButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_pauseButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_pauseButton setTitle:@"暂停" forState:UIControlStateNormal];
        [_pauseButton setTitle:@"开始" forState:UIControlStateSelected];
        __weak __typeof(self) weakSelf = self;
        [_pauseButton addActionBlock:^(UIButton * _Nullable button) {
            __typeof(&*weakSelf) strongSelf = weakSelf;
            button.selected = !button.selected;
            strongSelf.model.isPause = !strongSelf.model.isPause;
        }];
    }
    return _pauseButton;
}
@end
