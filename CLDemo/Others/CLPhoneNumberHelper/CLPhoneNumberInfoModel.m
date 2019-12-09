//
//  CLPhoneNumberInfoModel.m
//  __projectName__
//
//  Created by ios1 on 19/12/09.
//  Copyright © 2019年 ios1. All rights reserved.
//

#import "CLPhoneNumberInfoModel.h"
@implementation CLPhoneNumberInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
	return @{@"mobileBegin":@"MobileBeginWith",@"phoneNumberLengths":@"PhoneNumberLengths",@"alpha1":@"Alpha2",@"countryCode":@"CountryCode",@"countryName":@"CountryName",@"alpha2":@"Alpha3"};
}

@end