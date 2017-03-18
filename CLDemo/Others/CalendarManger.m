//
//  CalendarManger.m
//  CalendarEventDemo
//
//  Created by JmoVxia on 2017/3/18.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CalendarManger.h"
#import "CalendarEvent.h"
#import "YYCache.h"

#define Calendararray  @"calendararray"


static CalendarManger * manger = nil;

@interface CalendarManger ()<CalendarEventDelegate>
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
        NSMutableArray *array = (NSMutableArray *)[self.cache objectForKey:Calendararray];
        if (array) {
            self.calendararray = array;
        }else{
            self.calendararray  = [NSMutableArray array];
        }
    }
    return self;
}

- (void)calendarEventWithEventTitle:(NSString *)title startDate:(NSDate *)startDate endDate:(NSDate *)endDate alarmDate:(NSDate *)alarmDate eventIdKey:(NSString *)eventIdKey{
    CalendarEvent *event = [CalendarEvent calendarEventWithEventTitle:title startDate:startDate endDate:endDate alarmDate:alarmDate eventIdKey:eventIdKey];
    event.delegate = self;
    [event save];
}
#pragma mark - 储存代理
- (void)calendarEvent:(CalendarEvent *)event savedStatus:(ECalendarEventStatus)status error:(NSError *)error{
    if (status == kCalendarEventAccessSavedSucess) {
        [self.calendararray addObject:event];
        [self.cache setObject:self.calendararray forKey:Calendararray];
        NSLog(@"保存成功");
    }
}
#pragma mark - 删除代理
- (void)calendarEvent:(CalendarEvent *)event removedStatus:(ECalendarEventStatus)status error:(NSError *)error{
    if (status == kCalendarEventAccessRemovedSucess) {
        [self.calendararray removeObject:event];
        NSLog(@"删除成功");
    }
}

@end
