//
//  CLGCDTimer.m
//  CLDemo
//
//  Created by AUG on 2019/3/25.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLGCDTimer.h"

@interface CLGCDTimer ()

/**队列*/
@property (nonatomic, strong) dispatch_queue_t  serialQueue;
/**定时器*/
@property (nonatomic, strong) dispatch_source_t timer;
/**执行时间*/
@property (nonatomic, assign) NSTimeInterval    timeInterval;
/**延迟时间*/
@property (nonatomic, assign) NSTimeInterval    delaySecs;
/**是否重复*/
@property (nonatomic, assign) BOOL              repeat;
/**是否正在运行*/
@property (nonatomic, assign) BOOL              isRuning;
/**响应次数*/
@property (nonatomic, assign) NSInteger         actionTimes;
/**响应*/
@property (nonatomic, copy) void (^action) (NSInteger actionTimes);

@end

@implementation CLGCDTimer

- (instancetype)initWithInterval:(NSTimeInterval)interval
                       delaySecs:(NSTimeInterval)delaySecs
                           queue:(dispatch_queue_t)queue
                         repeats:(BOOL)repeats
                          action:(nullable void(^)(NSInteger actionTimes))action {
    if (self = [super init]) {
        self.timeInterval = interval;
        self.delaySecs    = delaySecs;
        self.repeat       = repeats;
        self.action       = action;
        self.isRuning     = NO;
        self.serialQueue  = dispatch_queue_create([[NSString stringWithFormat:@"CLGCDTimer.%p", self] cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_SERIAL);
        self.timer      = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.serialQueue);
        dispatch_set_target_queue(self.serialQueue, queue);
    }
    return self;
}
- (void)replaceOldAction:(void(^)(NSInteger actionTimes))action {
    if (action) {
        self.action = action;
    }
}
/**开始定时器*/
- (void)startTimer {
    dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, (NSInteger)(self.delaySecs * NSEC_PER_SEC)),(NSInteger)(self.timeInterval * NSEC_PER_SEC), 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        self.actionTimes ++;
        if (self.action) {
            self.action(self.actionTimes);
        }
        if (!self.repeat) {
            [self cancelTimer];
        }
    });
    [self resumeTimer];
}
/**执行一次定时器响应*/
- (void)responseOnceTimer {
    self.actionTimes ++;
    self.isRuning    = YES;
    if (self.action) {
        self.action(self.actionTimes);
    }
    self.isRuning = NO;
}
/**取消定时器*/
- (void)cancelTimer {
    if (!self.isRuning) {
        [self resumeTimer];
    }
    dispatch_source_cancel(self.timer);
}
/**暂停定时器*/
- (void)suspendTimer {
    if (self.isRuning) {
        dispatch_suspend(self.timer);
        self.isRuning = NO;
    }
}
/**恢复定时器*/
- (void)resumeTimer {
    if (!self.isRuning) {
        dispatch_resume(self.timer);
        self.isRuning = YES;
    }
}
-(void)dealloc {
    [self cancelTimer];
}

@end
