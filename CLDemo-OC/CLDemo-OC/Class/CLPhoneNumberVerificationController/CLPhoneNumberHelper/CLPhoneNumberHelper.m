//
//  CLPhoneNumberHelper.m
//  CLDemo
//
//  Created by AUG on 2019/12/7.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLPhoneNumberHelper.h"
#import "CLPhoneNumberModel.h"
#import <MJExtension/MJExtension.h>

@interface CLPhoneNumberHelper ()

///开始
@property (nonatomic, strong) CLPhoneNumberModel *phoneNumberModel;

@end


@implementation CLPhoneNumberHelper

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"iso3166" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:jsonPath];
        self.phoneNumberModel = [CLPhoneNumberModel mj_objectWithKeyValues:[data mj_JSONString]];
    }
    return self;
}
- (BOOL)verifyCountryCode:(NSString *)countryCode phoneNumber:(NSString *)phoneNumber {
    NSPredicate *countryCodePredicate = [NSPredicate predicateWithFormat:@"countryCode = %@", countryCode];
    NSArray<CLPhoneNumberInfoModel *> *countryCodeInfoModelArray = [self.phoneNumberModel.phoneNumberInfoArray filteredArrayUsingPredicate:countryCodePredicate];
    if (countryCodeInfoModelArray.count > 0) {
        NSPredicate *phoneNumberLengthsPredicate = [NSPredicate predicateWithFormat:@"phoneNumberLengths CONTAINS %ld", phoneNumber.length];
        NSArray<CLPhoneNumberInfoModel *> *phoneNumberLengthsInfoModelArray = [countryCodeInfoModelArray filteredArrayUsingPredicate:phoneNumberLengthsPredicate];
        if (phoneNumberLengthsInfoModelArray.count > 0) {
            NSPredicate *mobileBeginPredicate = [NSPredicate predicateWithBlock:^BOOL(CLPhoneNumberInfoModel  *evaluatedObject, NSDictionary<NSString *,id> * __unused bindings) {
                if (evaluatedObject.mobileBegin.count == 0) {
                    return YES;
                }
                for (NSString *mobileBegin in evaluatedObject.mobileBegin) {
                    if ([mobileBegin isEqualToString:@""]) {
                        return YES;
                    }
                    BOOL hasPrefix =  [phoneNumber hasPrefix:mobileBegin];
                    if (hasPrefix) {
                        return YES;
                    }
                }
                return NO;
            }];
            NSArray<CLPhoneNumberInfoModel *> *mobileBeginInfoModelArray = [phoneNumberLengthsInfoModelArray filteredArrayUsingPredicate:mobileBeginPredicate];
            if (mobileBeginInfoModelArray.count > 0) {
                return YES;
            }
        }
    }
    return NO;
}


@end
