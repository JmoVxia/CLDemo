//
//  CLLocalNotificationModel.h
//  CLDemo
//
//  Created by JmoVxia on 2017/3/22.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLLocalNotificationModel : NSObject

/**标题*/
@property (nonatomic,copy) NSString *title;
/**唯一标识符*/
@property (nonatomic,copy) NSString *identifier;
/**提醒时间*/
@property (nonatomic,copy) NSString *fireDate;
/**是否在本地通知中心*/
@property (nonatomic,assign) BOOL isLocalNotification;

@end
