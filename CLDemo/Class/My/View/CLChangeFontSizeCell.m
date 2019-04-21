//
//  CLChangeFontSizeCell.m
//  CLDemo
//
//  Created by AUG on 2018/11/11.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import "CLChangeFontSizeCell.h"

@interface CLChangeFontSizeCell ()

/**头像*/
@property (nonatomic, strong) UIImageView *headImageView;
/**内容*/
@property (nonatomic, strong) UILabel *contentTextLabel;
/**背景*/
@property (nonatomic, strong) UIImageView *backgroundImageView;



@end


@implementation CLChangeFontSizeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.backgroundColor = [UIColor clearColor];
    self.backgroundImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.backgroundImageView];
    
    self.headImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.headImageView];
    
    self.contentTextLabel = [[UILabel alloc] init];
    self.contentTextLabel.numberOfLines = 0;
    self.contentTextLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.contentTextLabel];
}
-(void)setModel:(ChangeFontSizeModel *)model {
    UIImage *backgroundImage;
    if (model.fromMe) {
        self.contentTextLabel.textColor =[UIColor whiteColor];
        backgroundImage = [UIImage imageNamed:@"woxin_chatRight_bg"];
        backgroundImage =  [backgroundImage stretchableImageWithLeftCapWidth:backgroundImage.size.width * 0.5 topCapHeight:backgroundImage.size.height * 0.9];
    }else {
        self.contentTextLabel.textColor =[UIColor blackColor];
        backgroundImage = [UIImage imageNamed:@"woxin_chatLeft_bg"];
        backgroundImage =  [backgroundImage stretchableImageWithLeftCapWidth:backgroundImage.size.width * 0.5 topCapHeight:backgroundImage.size.height * 0.9];
    }
    
    self.contentTextLabel.font = [UIFont clFontOfSize:18];

    
    self.headImageView.image = model.headImage;
    self.headImageView.frame = model.headFrame;
    
    self.backgroundImageView.image = backgroundImage;
    self.backgroundImageView.frame = model.backgroundFrame;
    
    self.contentTextLabel.attributedText = [self attributedString:model.contentString Font:self.contentTextLabel.font];
    self.contentTextLabel.frame = model.contentFrame;
}

- (NSMutableAttributedString *)attributedString:(NSString *)string Font:(UIFont *)font {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    NSDictionary * dic = @{
                          NSParagraphStyleAttributeName:paragraphStyle,
                          NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleNone],
                          NSFontAttributeName:font,
                          NSForegroundColorAttributeName:[UIColor blackColor],
                          };
    [attributedString setAttributes:dic range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

@end
