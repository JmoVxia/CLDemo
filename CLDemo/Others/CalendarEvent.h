//
//  CalendarEvent.h
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


@interface CalendarEvent : NSObject

/**
 *  Event title.
 */
@property (nonatomic, strong) NSString *eventTitle;

/**
 *  Alarm date.
 */
@property (nonatomic, strong) NSDate   *alarmDate;

/**
 *  Event start date.
 */
@property (nonatomic, strong) NSDate   *startDate;

/**
 *  Event end date.
 */
@property (nonatomic, strong) NSDate   *endDate;

/**
 *  Event location.
 */
@property (nonatomic, strong) NSString *eventLocation;

/**创建时间*/
@property (nonatomic,strong) NSDate *creatDate;



/**
 *  Save the event to system.
 */
- (void)saveSucess:(EventAccessSucessBlock)sucess failed:(EventAccessFailedBlock)failed denied:(EventAccessDeniedBlock)denied;

/**
 *  Remove the event.
 */
- (void)removeSucess:(EventAccessSucessBlock)sucess failed:(EventAccessFailedBlock)failed;

/**
 *  To indicate the event have saved or not.
 */
- (BOOL)haveSaved;

/**
 读取日历事件
 */
- (CalendarEvent *)readEvent;




#pragma mark - Constructor method.

+ (instancetype)calendarEventWithEventTitle:(NSString *)title startDate:(NSDate *)startDate endDate:(NSDate *)endDate alarmDate:(NSDate *)alarmDate;

@end
