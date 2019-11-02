//
//  CLHorizontalLayoutCell.m
//  CLDemo
//
//  Created by AUG on 2019/11/2.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLHorizontalLayoutCell.h"
#import <Masonry/Masonry.h>
#import "CLHorizontalLayoutCellProtocol.h"
#import "CLHorizontalLayoutItem.h"

@interface CLHorizontalLayoutCell ()<CLHorizontalLayoutCellProtocol>

///label
@property (nonatomic, strong) UILabel *label;

@end

@implementation CLHorizontalLayoutCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self mas_makeConstraints];
    }
    return self;
}
- (void)initUI {
    [self.contentView addSubview:self.label];
}
- (void)mas_makeConstraints {
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}
- (void)updateItem:(CLHorizontalLayoutItemProtocol *)item {
    CLHorizontalLayoutItem *horizontalLayoutItem = (CLHorizontalLayoutItem *)item;
    if ([horizontalLayoutItem isKindOfClass:[CLHorizontalLayoutItem class]]) {
        self.label.text = horizontalLayoutItem.text;
    }
}
- (UILabel *) label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}
@end
