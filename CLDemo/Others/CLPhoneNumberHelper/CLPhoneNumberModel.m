//
//  CLPhoneNumberModel.m
//  __projectName__
//
//  Created by ios1 on 19/12/09.
//  Copyright © 2019年 ios1. All rights reserved.
//

#import "CLPhoneNumberModel.h"

@implementation CLPhoneNumberModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
	return @{@"phoneNumberInfoArray":@"PhoneNumberInfo"};
}

+ (NSDictionary *)mj_objectClassInArray{
	return @{@"phoneNumberInfoArray":@"CLPhoneNumberInfoModel"};
}

@end
