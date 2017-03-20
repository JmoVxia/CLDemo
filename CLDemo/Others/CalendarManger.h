//
//  CalendarManger.h
//  CalendarEventDemo
//
//  Created by JmoVxia on 2017/3/18.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^EventAccessSucessBlock)();
typedef void(^EventAccessFailedBlock)();
typedef void(^EventAccessDeniedBlock)();

@class CalendarEvent;

@interface CalendarManger : NSObject

/**
 单例创建管理者
 */
+ (CalendarManger *)sharedManger;



/**
 创建并且保存日历事件

 @param title 标题
 @param startDate 开始时间
 @param endDate 结束时间
 @param alarmDate 提醒时间
 @param sucess 成功回调
 @param failed 失败回调
 @param denied 没有访问日历权限回调
 */
- (void)calendarEventWithEventTitle:(NSString *)title startDate:(NSDate *)startDate endDate:(NSDate *)endDate alarmDate:(NSDate *)alarmDate sucess:(EventAccessSucessBlock)sucess failed:(EventAccessFailedBlock)failed denied:(EventAccessDeniedBlock)denied;



/**
 移除日历事件

 @param event 日历事件
 @param sucess 成功回调
 @param failed 失败回调
 */
- (void)removeCalendarEventWithEvent:(CalendarEvent *)event sucess:(EventAccessSucessBlock)sucess failed:(EventAccessFailedBlock)failed;


/**
 查询日历事件

 @return 所有日历事件
 */
- (NSMutableArray *)queryCalendar;








@end
