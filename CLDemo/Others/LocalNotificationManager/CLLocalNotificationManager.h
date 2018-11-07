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

/**localArray*/
@property (nonatomic,strong,readonly) NSMutableArray<CLLocalNotificationModel *> *localArray;


/**
 单例创建管理者
 */
+ (CLLocalNotificationManager *)sharedManger;


/**
 插入本地通知

 @param model 通知模型
 */
- (void)insertLocalNotificationWithModel:(CLLocalNotificationModel *)model;

/**
 删除本地通知

 @param model 通知模型
 @param dateBase 是否从数据库删除
 */
- (void)deleteLocadNotificationWithModel:(CLLocalNotificationModel *)model dateBase:(BOOL)dateBase;


/**
 删除所有
 */
- (void)deleteAllLocalNotification;


@end
