//
//  CalendarManger.h
//  CalendarEventDemo
//
//  Created by JmoVxia on 2017/3/18.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CalendarEvent;

@interface CalendarManger : NSObject

/**
 单例创建管理者
 */
+ (CalendarManger *)sharedManger;


/**
 创建日历事件

 @param title 标题
 @param startDate 开始时间
 @param endDate 结束时间
 @param alarmDate 提醒时间
 */
- (CalendarEvent *)calendarEventWithEventTitle:(NSString *)title startDate:(NSDate *)startDate endDate:(NSDate *)endDate alarmDate:(NSDate *)alarmDate;



/**
 根据日历事件移除

 @param event 日历事件
 */
- (void)removeCalendarEventWithEvent:(CalendarEvent *)event;


/**
 查询日历事件

 @return 所有日历事件
 */
- (NSMutableArray *)queryCalendar;








@end
