//
//  CLPhoneNumberInfoModel.h
//  __projectName__
//
//  Created by ios1 on 19/12/09.
//  Copyright © 2019年 ios1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLPhoneNumberInfoModel : NSObject
///通道1
@property (nonatomic, copy) NSString * alpha1;
///通道2
@property (nonatomic, copy) NSString * alpha2;
///国家码
@property (nonatomic, copy) NSString * countryCode;
///国家名称
@property (nonatomic, copy) NSString * countryName;
///号码开始
@property (nonatomic, strong) NSArray<NSString *> * mobileBegin;
///号码长度
@property (nonatomic, strong) NSArray<NSNumber *> * phoneNumberLengths;

@end
