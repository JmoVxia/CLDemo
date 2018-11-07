//
//  CLLanguageManager.h
//  CLDemo
//
//  Created by AUG on 2018/11/7.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLLanguageManager : NSObject
/**
 用户自定义使用的语言，当传nil时，等同于resetSystemLanguage
 */
@property (class, nonatomic, strong, nullable) NSString *userLanguage;
/**
 重置系统语言
 */
+ (void)resetSystemLanguage;

@end

NS_ASSUME_NONNULL_END
