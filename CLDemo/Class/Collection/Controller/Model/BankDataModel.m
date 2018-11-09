//
//  BankDataModel.m
//  CLSearchDemo
//
//  Created by AUG on 2018/10/28.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import "BankDataModel.h"
#import "MJExtension.h"

@implementation BankDataModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"bankId" : @"ID",
             @"bankCode" : @"BankCode",
             @"createdAt" : @"CreatedAt",
             @"name" : @"Name",
             };
}
@end
