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
#import "DateTools.h"
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
        
        NSString *dateString = [[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd"];
        NSDate *date = [[Tools sharedTools] stringToDate:dateString withDateFormat:@"yyyy-MM-dd"];
        if ([date isLaterThan:obj.creatDate]) {
            //比今天早，过期日历事件，删除日历事件
            [tempArray removeObject:obj];
            [obj removeSucess:^{
                //移除成功
                CLlog(@"移除成功");
            } failed:^{
                //移除失败
                CLlog(@"移除失败");
            }];
        }
        
        if (![obj haveSaved]) {
            //日历中不存在，从数组中删除
            [tempArray removeObject:obj];
        }else{
            //日历中存在，从日历读取
            CalendarEvent *event = [obj readEvent];
            NSInteger index = [tempArray indexOfObject:obj];
            [tempArray replaceObjectAtIndex:index withObject:event];
            [obj removeSucess:^{
                
            } failed:^{
                
            }];
            [event saveSucess:^{
                
            } failed:^{
                
            } denied:^{
                
            }];
        }
    }];
    self.calendararray = tempArray;
    [self.cache setObject:self.calendararray forKey:Calendararray];
    return self.calendararray;
}

- (void)calendarEventWithEventTitle:(NSString *)title startDate:(NSDate *)startDate endDate:(NSDate *)endDate alarmDate:(NSDate *)alarmDate sucess:(EventAccessSucessBlock)sucess failed:(EventAccessFailedBlock)failed denied:(EventAccessDeniedBlock)denied{
    CalendarEvent *event = [CalendarEvent calendarEventWithEventTitle:title startDate:startDate endDate:endDate alarmDate:alarmDate];
    [event saveSucess:^{
        //保存成功
        sucess();
        CLlog(@"保存成功");
        [self.calendararray addObject:event];
        [self.cache setObject:self.calendararray forKey:Calendararray];
    } failed:^{
        //保存失败
        failed();
        CLlog(@"保存失败");
    } denied:^{
        //没有权限
        denied();
        CLlog(@"没有日历权限");
    }];
}


- (void)removeCalendarEventWithEvent:(CalendarEvent *)event sucess:(EventAccessSucessBlock)sucess failed:(EventAccessFailedBlock)failed{
    [event removeSucess:^{
        //移除成功
        CLlog(@"移除成功");
        sucess();
        [self.calendararray removeObject:event];
        [self.cache setObject:self.calendararray forKey:Calendararray];
    } failed:^{
        //移除失败
        failed();
        CLlog(@"移除失败");
    }];
}















@end
