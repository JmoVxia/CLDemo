//
//  ChangeFontSizeModel.h
//  CLDemo
//
//  Created by AUG on 2018/11/11.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


#define ChatMarginTop 7.5     //距离cell顶部间隔
#define ChatMarginBottom 7.5  //距离cell底部间隔

#define ChatbackgroundMarginLeft 3  //背景图片距离左边头像距离
#define ChatbackgroundMarginRight 3  //背景图片距离右边头像距离


#define ChatIconWH 42       //头像宽高height、width


#define ChatContentW 210    //内容最大宽度

#define ChatContentTop 10   //文本内容与按钮上边缘间隔
#define ChatContentLeft 10  //文本内容与按钮左边缘间隔
#define ChatContentBottom 10 //文本内容与按钮下边缘间隔
#define ChatContentRight 10 //文本内容与按钮右边缘间隔




@interface CLChangeFontSizeModel : NSObject

/**头像图片*/
@property (nonatomic, strong) UIImage *headImage;
/**内容*/
@property (nonatomic, strong) NSString *contentString;

/**自己*/
@property (nonatomic, assign) BOOL fromMe;
/**头像frame*/
@property (nonatomic, assign, readonly) CGRect headFrame;
/**内容frame*/
@property (nonatomic, assign, readonly) CGRect contentFrame;
/**背景frame*/
@property (nonatomic, assign, readonly) CGRect backgroundFrame;


/**cell 的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;


- (instancetype)initWithHeadImage:(UIImage *)headImage contentString:(NSString *)contentString fromMe:(BOOL)fromMe;

- (void)refreshFrame;

@end

NS_ASSUME_NONNULL_END
