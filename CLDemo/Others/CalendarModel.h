//
//  CalendarModel.h
//  CLDemo
//
//  Created by JmoVxia on 2017/3/19.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CalendarEvent;

@interface CalendarModel : NSObject
/**ID*/
@property (nonatomic,strong) NSString *calendarId;
/**calendar*/
@property (nonatomic,strong) CalendarEvent *calendar;

@end
