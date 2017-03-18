//
//  CalendarManger.h
//  CalendarEventDemo
//
//  Created by JmoVxia on 2017/3/18.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarManger : NSObject

/**
 单例创建管理者
 */
+ (CalendarManger *)sharedManger;

/**日历事件数组*/
@property (nonatomic,strong,readonly) NSMutableArray *calendararray;


@end
