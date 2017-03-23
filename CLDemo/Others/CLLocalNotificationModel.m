//
//  CLLocalNotificationModel.m
//  CLDemo
//
//  Created by JmoVxia on 2017/3/22.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLLocalNotificationModel.h"
#import "MJExtension.h"

@implementation CLLocalNotificationModel

MJExtensionCodingImplementation


- (instancetype)init{
    if (self = [super init]) {
        NSString *dateString = [[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd"];
        self.creatDate = [[Tools sharedTools] stringToDate:dateString withDateFormat:@"yyyy-MM-dd"];
    }
    return self;
}


@end
