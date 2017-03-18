//
//  CalendarManger.m
//  CalendarEventDemo
//
//  Created by JmoVxia on 2017/3/18.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CalendarManger.h"
#import "CalendarEvent.h"
static CalendarManger * manger = nil;

@interface CalendarManger ()<CalendarEventDelegate>

/**日历事件数组*/
@property (nonatomic,strong) NSMutableArray *calendararray;

@end

@implementation CalendarManger

+ (CalendarManger *)sharedManger{
    // 线程锁
    @synchronized(self) {
        // 保证对象其唯一
        if(manger == nil){
            manger = [[CalendarManger alloc] init];
        }
    }
    return manger;
}
-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}





- (void)calendarEventWithEventTitle:(NSString *)title startDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    CalendarEvent *event = [CalendarEvent calendarEventWithEventTitle:title startDate:startDate endDate:endDate];
    event.delegate = self;
    [event save];
}
#pragma mark - 储存代理
- (void)calendarEvent:(CalendarEvent *)event savedStatus:(ECalendarEventStatus)status error:(NSError *)error{
    if (status == kCalendarEventAccessSavedSucess) {
        
        NSLog(@"保存成功");
    }
}
#pragma mark - 删除代理
- (void)calendarEvent:(CalendarEvent *)event removedStatus:(ECalendarEventStatus)status error:(NSError *)error{
    if (status == kCalendarEventAccessRemovedSucess) {
        
        NSLog(@"删除成功");
    }
}

@end
