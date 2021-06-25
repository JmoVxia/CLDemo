//
//  CLVerticalCell.m
//  CLDemo
//
//  Created by AUG on 2019/11/21.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLVerticalCell.h"
#import "CLLayoutCellProtocol.h"
#import "CLVerticalItem.h"
#import "UIView+CLSetRect.h"
#import "Masonry.h"

@interface CLVerticalCell ()<CLLayoutCellProtocol>

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CLVerticalCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self mas_makeConstraints];
    }
    return self;
}
- (void)initUI {
    self.backgroundColor = cl_RandomColor;
    [self.contentView addSubview:self.titleLabel];
}
- (void)mas_makeConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.right.bottom.mas_equalTo(-10);
    }];
}
- (void)updateItem:(nonnull id<CLLayoutCellProtocol>)item {
    CLVerticalItem *verticalItem = (CLVerticalItem *)item;
    if ([verticalItem isKindOfClass:[CLVerticalItem class]]) {
        self.titleLabel.text = verticalItem.text;
    }
}
- (UILabel *) titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.borderWidth = 0.5;
        _titleLabel.layer.cornerRadius = 4;
        _titleLabel.layer.borderColor = [UIColor colorWithRed:252.0/255.0 green:194.0/255.0 blue:0 alpha:1.0].CGColor;
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}
@end
