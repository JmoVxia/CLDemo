//
//  CalendarEvent.m
//  CalendarEventDemo
//
//  Created by JmoVxia on 2017/3/18.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CalendarEvent.h"
#import <CommonCrypto/CommonDigest.h>
#import "MJExtension.h"
#import "DateTools.h"
#import <EventKit/EventKit.h>

@interface CalendarEvent ()



@end


@implementation CalendarEvent

MJExtensionCodingImplementation

- (void)removeSucess:(EventAccessSucessBlock)sucess failed:(EventAccessFailedBlock)failed{
    
    NSString *eventId = [[NSUserDefaults standardUserDefaults] objectForKey:[self storedKey]];
    
    if (eventId) {
    
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        EKEvent      *event      = [eventStore eventWithIdentifier:eventId];
        NSError      *error      = nil;
        [eventStore removeEvent:event span:EKSpanThisEvent error:&error];
        if (error) {
            //主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //失败
                failed();
            });
        }else{
            //主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                //成功
                sucess();
 
            });
        }

    }
}

- (BOOL)haveSaved {
    
    NSString *eventId = [[NSUserDefaults standardUserDefaults] objectForKey:[self storedKey]];
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKEvent      *event      = [eventStore eventWithIdentifier:eventId];
    
    if (event) {
        
        return YES;
        
    } else {
        
        return NO;
    }
}

- (CalendarEvent *)readEvent{
    NSString *eventId = [[NSUserDefaults standardUserDefaults] objectForKey:[self storedKey]];
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKEvent      *event      = [eventStore eventWithIdentifier:eventId];
    CalendarEvent *calendarEvent = [CalendarEvent new];
    calendarEvent.eventTitle     = event.title;
    calendarEvent.startDate      = event.startDate;
    calendarEvent.endDate   = event.endDate;
    calendarEvent.eventLocation = event.location;
    calendarEvent.alarmDate = [event.alarms firstObject].absoluteDate;
    calendarEvent.creatDate = self.creatDate;
    return calendarEvent;
}

- (void)saveSucess:(EventAccessSucessBlock)sucess failed:(EventAccessFailedBlock)failed denied:(EventAccessDeniedBlock)denied{
    
    NSParameterAssert(self.eventTitle);
    NSParameterAssert(self.startDate);
    NSParameterAssert(self.endDate);
    
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
        if (granted) {
            //有权限
            EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
            event.calendar  = [eventStore defaultCalendarForNewEvents];
            event.title     = self.eventTitle;
            event.startDate = self.startDate;
            event.endDate   = self.endDate;
            
            self.alarmDate            ? [event addAlarm:[EKAlarm alarmWithAbsoluteDate:self.alarmDate]] : 0;
            self.eventLocation.length ? event.location = self.eventLocation                             : 0;
            
            NSError *savedError = nil;
            if ([eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&savedError]) {
                //主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    //保存成功
                    sucess();
                });
                // 存储事件的键值
                [[NSUserDefaults standardUserDefaults] setObject:event.eventIdentifier forKey:[self storedKey]];
                
            } else {
                //主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    //保存失败
                    failed();
                });
            }
            
        } else {
            //主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                //没有权限
                denied();
            });
        }
    }];
}

- (NSString *)storedKey {
    
    NSParameterAssert(self.eventTitle);
    NSParameterAssert(self.startDate);
    NSParameterAssert(self.endDate);

    NSString *string = [NSString stringWithFormat:@"%@%@%@", self.eventTitle, self.startDate, self.endDate];
    
    return [self md532BitLower:string];
}

- (NSString*)md532BitLower:(NSString *)string {
    
    const char    *cStr = [string UTF8String];
    unsigned char  result[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]] lowercaseString];
}

+ (instancetype)calendarEventWithEventTitle:(NSString *)title startDate:(NSDate *)startDate endDate:(NSDate *)endDate alarmDate:(NSDate *)alarmDate{
    
    CalendarEvent *event = [[self class] new];
    event.eventTitle     = title;
    event.startDate      = startDate;
    event.endDate        = endDate;
    event.alarmDate      = alarmDate;
    NSString *dateString = [[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd"];
    event.creatDate      = [[Tools sharedTools] stringToDate:dateString withDateFormat:@"yyyy-MM-dd"];
    return event;
}

@end
