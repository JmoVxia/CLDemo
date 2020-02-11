//
//  ChangeFontSizeModel.m
//  CLDemo
//
//  Created by AUG on 2018/11/11.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import "ChangeFontSizeModel.h"

@interface ChangeFontSizeModel ()

/**头像frame*/
@property (nonatomic, assign) CGRect headFrame;
/**内容frame*/
@property (nonatomic, assign) CGRect contentFrame;

/**cell 的高度 */
@property (nonatomic, assign) CGFloat cellHeight;


@end



@implementation ChangeFontSizeModel

- (instancetype)initWithHeadImage:(UIImage *)headImage contentString:(NSString *)contentString fromMe:(BOOL)fromMe {
    if (self = [super init]) {
        _headImage = headImage;
        _contentString = contentString;
        _fromMe = fromMe;
        
        [self refreshFrame];
        
    }
    return self;
}

- (void)refreshFrame {
    // 计算头像位置
    CGFloat iconX = ChatMarginTop;
    if (_fromMe) {
        iconX = cl_screenWidth - ChatMarginTop - ChatIconWH;
    }
    CGFloat iconY = ChatMarginTop;
    _headFrame = CGRectMake(iconX, iconY, ChatIconWH, ChatIconWH);
    
    //计算内容位置
    CGSize maxSize = CGSizeMake(ChatContentW - 27.5, CGFLOAT_MAX);
    CGSize contentSize = [_contentString boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont clFontOfSize:18]} context:nil].size;
    CGFloat contentX = CGRectGetMaxX(_headFrame) + ChatbackgroundMarginLeft + ChatContentLeft + 7;
    if (_fromMe) {
        contentX = cl_screenWidth - contentSize.width - ChatMarginTop - ChatIconWH - ChatbackgroundMarginRight - ChatContentLeft - 7;
    }
    CGFloat contentY = iconY + ChatContentTop;
    _contentFrame = CGRectMake(contentX, contentY, contentSize.width, contentSize.height);
    
    //计算背景位置
    CGFloat backgroundX = CGRectGetMaxX(_headFrame) + ChatbackgroundMarginLeft;
    CGFloat backgroundY = iconY;
    CGFloat backgroundWidth = contentSize.width + ChatContentLeft + ChatContentRight + 7;
    CGFloat backgroundHeight = MAX(contentSize.height + ChatContentTop + ChatContentBottom, _headFrame.size.height);
    if (_fromMe) {
        backgroundX = cl_screenWidth - backgroundWidth - ChatMarginTop - ChatIconWH - ChatbackgroundMarginRight;
    }
    _backgroundFrame = CGRectMake(backgroundX, backgroundY, backgroundWidth, backgroundHeight);
    
    //cell高度
    _cellHeight = MAX(CGRectGetHeight(_backgroundFrame), CGRectGetHeight(_headFrame)) + ChatMarginTop + ChatMarginBottom;
}

@end
