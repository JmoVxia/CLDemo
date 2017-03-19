//
//  CalendarManger.m
//  CalendarEventDemo
//
//  Created by JmoVxia on 2017/3/18.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CalendarManger.h"
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
        NSMutableArray<CalendarEvent*> *array = (NSMutableArray *)[self.cache objectForKey:Calendararray];
        if (array) {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:array];
            [array enumerateObjectsUsingBlock:^(CalendarEvent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (![obj haveSaved]) {
                    //日历中不存在，从数组中删除
                    [tempArray removeObject:obj];
                }
            }];
            self.calendararray = tempArray;
        }else{
            self.calendararray  = [NSMutableArray array];
        }
    }
    return self;
}
- (void)calendarEventWithEventTitle:(NSString *)title startDate:(NSDate *)startDate endDate:(NSDate *)endDate alarmDate:(NSDate *)alarmDate{
    CalendarEvent *event = [CalendarEvent calendarEventWithEventTitle:title startDate:startDate endDate:endDate alarmDate:alarmDate];
//    event.delegate = self;
    [event save];
    [self.calendararray addObject:event];
    [self.cache setObject:self.calendararray forKey:Calendararray];
}
- (void)removeCalendarEventWithEvent:(CalendarEvent *)event{
//    event.delegate = self;
    [event remove];
    [self.calendararray removeObject:event];
    [self.cache setObject:self.calendararray forKey:Calendararray];

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
        [self.calendararray removeObject:event];
        NSLog(@"删除成功");
    }
}

@end
