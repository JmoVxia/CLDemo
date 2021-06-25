//
//  CLPhoneNumberHelper.h
//  CLDemo
//
//  Created by AUG on 2019/12/7.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLPhoneNumberHelper : NSObject

/// 根据国家码和电话号码验证是否合法
/// @param countryCode 国际码
/// @param phoneNumber 电话号码
- (BOOL)verifyCountryCode:(NSString *)countryCode phoneNumber:(NSString *)phoneNumber;

@end

NS_ASSUME_NONNULL_END
