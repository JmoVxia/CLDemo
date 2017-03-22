//
//  CLLocalNotificationManager.h
//  CLDemo
//
//  Created by JmoVxia on 2017/3/22.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLLocalNotificationModel.h"

@interface CLLocalNotificationManager : NSObject

/**
 单例创建管理者
 */
+ (CLLocalNotificationManager *)sharedManger;


- (void)insertLocalNotificationWithModel:(CLLocalNotificationModel *)model;

- (void)deleteLocadNotificationWithModel:(CLLocalNotificationModel *)model dateBase:(BOOL)dateBase;

@end
