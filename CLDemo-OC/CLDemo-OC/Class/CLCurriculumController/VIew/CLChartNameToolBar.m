//
//  CLChartNameToolBar.m
//  CLDemo
//
//  Created by JmoVxia on 2017/3/16.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLChartNameToolBar.h"
#import "Masonry.h"

@interface CLChartNameToolBar ()

/**名字*/
@property (nonatomic,strong) UILabel *nameLabel;

@end


@implementation CLChartNameToolBar

- (UILabel *) nameLabel{
    if (_nameLabel == nil){
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

-(void)setNameString:(NSString *)nameString{
    _nameString = nameString;
    _nameLabel.text = _nameString;
}


@end
