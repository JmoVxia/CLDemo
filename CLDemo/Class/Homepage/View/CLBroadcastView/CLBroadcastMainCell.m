//
//  CLBroadcastMainCell.m
//  CLDemo
//
//  Created by AUG on 2019/10/14.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLBroadcastMainCell.h"
#import <Masonry/Masonry.h>

@interface CLBroadcastMainCell ()

///label
@property (nonatomic, strong) UILabel *label;

@end


@implementation CLBroadcastMainCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initUI];
        [self mas_makeConstraints];
    }
    return self;
}
- (void)initUI {
    [self addSubview:self.label];
}
- (void)mas_makeConstraints {
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self);
    }];
}
- (void)setAdText:(NSString *)adText {
    _adText = adText;
    self.label.text = adText;
}
- (UILabel *) label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:13];
    }
    return _label;
}
@end
