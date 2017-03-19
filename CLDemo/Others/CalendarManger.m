//
//  CalendarManger.m
//  CalendarEventDemo
//
//  Created by JmoVxia on 2017/3/18.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CalendarManger.h"
#import "YYCache.h"
#import "CalendarEvent.h"
#define Calendararray  @"calendararray"


static CalendarManger * manger = nil;

@interface CalendarManger ()
/**cache*/
@property (nonatomic,strong) YYCache *cache;
/**日历事件数组*/
@property (nonatomic,strong) NSMutableArray<CalendarEvent *> *calendararray;

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
        NSString *path = [[Tools pathDocuments] stringByAppendingPathComponent:@"CalendarManger"];
        self.cache = [[YYCache alloc] initWithPath:path];
        NSMutableArray<CalendarEvent*> *array = (NSMutableArray *)[self.cache objectForKey:Calendararray];
        if (array) {
            self.calendararray = array;
        }else{
            self.calendararray  = [NSMutableArray array];
        }
    }
    return self;
}

- (NSMutableArray *)queryCalendar{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.calendararray];
    [self.calendararray enumerateObjectsUsingBlock:^(CalendarEvent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj haveSaved]) {
            //日历中不存在，从数组中删除
            [tempArray removeObject:obj];
        }
    }];
    self.calendararray = tempArray;
    return self.calendararray;
}

- (CalendarEvent *)calendarEventWithEventTitle:(NSString *)title startDate:(NSDate *)startDate endDate:(NSDate *)endDate alarmDate:(NSDate *)alarmDate{
    CalendarEvent *event = [CalendarEvent calendarEventWithEventTitle:title startDate:startDate endDate:endDate alarmDate:alarmDate];
    [event save];
    [self.calendararray addObject:event];
    [self.cache setObject:self.calendararray forKey:Calendararray];
    return event;
}


- (void)removeCalendarEventWithEvent:(CalendarEvent *)event{
    [event remove];
    [self.calendararray removeObject:event];
    [self.cache setObject:self.calendararray forKey:Calendararray];
}















@end
