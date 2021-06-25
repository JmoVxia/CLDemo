//
//  NSBundle+CLLanguage.h
//  CLDemo
//
//  Created by AUG on 2018/11/7.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (CLLanguage)


/**
 是否是中文
 */
+ (BOOL)isChineseLanguage;

/**
 查询当前语言

 @return 当前语言
 */
+ (NSString *)currentLanguage;

@end

NS_ASSUME_NONNULL_END
