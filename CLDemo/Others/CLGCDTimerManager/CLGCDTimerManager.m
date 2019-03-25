//
//  CLGCDTimerManager.m
//  CLDemo
//
//  Created by AUG on 2019/3/25.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLGCDTimerManager.h"

@interface CLGCDTimer ()

/**队列*/
@property (nonatomic, strong) dispatch_queue_t queue;
/**定时器*/
@property (nonatomic, strong) dispatch_source_t timer;
/**执行时间*/
@property (nonatomic, assign) NSTimeInterval interval;
/**延迟时间*/
@property (nonatomic, assign) NSTimeInterval delaySecs;
/**是否重复*/
@property (nonatomic, assign) BOOL repeat;
/**是否正在运行*/
@property (nonatomic, assign) BOOL isRuning;
/**响应次数*/
@property (nonatomic, assign) NSInteger actionTimes;
///名称
@property (nonatomic, copy) NSString *name;
/**响应*/
@property (nonatomic, copy) void (^action) (NSInteger actionTimes);

@end

@implementation CLGCDTimer

- (instancetype _Nonnull)initWithName:(NSString *)name
                             interval:(NSTimeInterval)interval
                            delaySecs:(NSTimeInterval)delaySecs
                                queue:(dispatch_queue_t _Nullable)queue
                              repeats:(BOOL)repeats
                               action:(void(^ _Nullable)(NSInteger actionTimes))action {
    CLGCDTimer *timer = [self initWithInterval:interval
                                     delaySecs:delaySecs
                                         queue:queue
                                       repeats:repeats
                                        action:action];
    timer.name = name;
    return timer;
}
- (instancetype _Nonnull)initWithInterval:(NSTimeInterval)interval
                                delaySecs:(NSTimeInterval)delaySecs
                                    queue:(dispatch_queue_t _Nullable)queue
                                  repeats:(BOOL)repeats
                                   action:( void(^ _Nullable)(NSInteger actionTimes))action {
    if (self = [super init]) {
        if (queue == nil) {
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        }
        self.interval = interval;
        self.delaySecs = delaySecs;
        self.repeat = repeats;
        self.action = action;
        self.isRuning = NO;
        self.queue = dispatch_queue_create([[NSString stringWithFormat:@"CLGCDTimer.%p", self] cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_SERIAL);
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
        dispatch_set_target_queue(self.queue, queue);
    }
    return self;
}
- (void)replaceOldAction:(void(^ _Nonnull)(NSInteger actionTimes))action {
    if (action) {
        self.action = action;
    }
}
/**开始定时器*/
- (void)start {
    dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, (NSInteger)(self.delaySecs * NSEC_PER_SEC)),(NSInteger)(self.interval * NSEC_PER_SEC), 0 * NSEC_PER_SEC);
    __weak __typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        __typeof(&*weakSelf) strongSelf = weakSelf;
        strongSelf.actionTimes ++;
        if (strongSelf.action) {
            strongSelf.action(strongSelf.actionTimes);
        }
        if (!strongSelf.repeat) {
            [strongSelf cancel];
        }
    });
    [self resume];
}
/**执行一次定时器响应*/
- (void)responseOnce {
    self.actionTimes ++;
    self.isRuning = YES;
    if (self.action) {
        self.action(self.actionTimes);
    }
    self.isRuning = NO;
}
/**取消定时器*/
- (void)cancel {
    if (!self.isRuning) {
        [self resume];
    }
    dispatch_source_cancel(self.timer);
}
/**暂停定时器*/
- (void)suspend {
    if (self.isRuning) {
        dispatch_suspend(self.timer);
        self.isRuning = NO;
    }
}
/**恢复定时器*/
- (void)resume {
    if (!self.isRuning) {
        dispatch_resume(self.timer);
        self.isRuning = YES;
    }
}
-(void)dealloc {
    [self cancel];
}

@end

@interface CLGCDTimerManager ()

/**CLGCDTimer字典*/
@property (nonatomic, strong) NSMutableDictionary *timerObjectCache;
/**信号*/
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation CLGCDTimerManager

#pragma mark - 初始化
//第1步: 存储唯一实例
static CLGCDTimerManager *_manager = nil;
//第2步: 分配内存空间时都会调用这个方法. 保证分配内存alloc时都相同.
+ (id)allocWithZone:(struct _NSZone *)zone {
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [super allocWithZone:zone];
    });
    return _manager;
}
//第3步: 保证init初始化时都相同
+ (instancetype)sharedManager {
    return [[self alloc] init];
}
- (id)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [super init];
        self.timerObjectCache = [NSMutableDictionary dictionary];
        self.semaphore = dispatch_semaphore_create(0);
        dispatch_semaphore_signal(self.semaphore);
    });
    return _manager;
}
//第4步: 保证copy时都相同
- (id)copyWithZone:(NSZone __unused*)zone {
    return _manager;
}
//第五步: 保证mutableCopy时相同
- (id)mutableCopyWithZone:(NSZone __unused*)zone {
    return _manager;
}
//MARK:JmoVxia---创建定时器
+ (void)scheduledTimerWithName:( NSString * _Nonnull)name
                      interval:(NSTimeInterval)interval
                     delaySecs:(NSTimeInterval)delaySecs
                         queue:(dispatch_queue_t _Nullable)queue
                       repeats:(BOOL)repeats
                        action:(void(^ _Nullable)(NSInteger actionTimes))action {
    __strong NSString *string = name;
    CLGCDTimer *GCDTimer = [self timer:string];
    if (GCDTimer) {
        return;
    }
    GCDTimer = [[CLGCDTimer alloc] initWithName:string
                                       interval:interval
                                      delaySecs:delaySecs
                                          queue:queue
                                        repeats:repeats
                                         action:action];
    [self setTimer:GCDTimer name:string];
}
//MARK:JmoVxia---开始定时器
+ (void)start:(NSString *_Nonnull)name {
    __strong NSString *string = name;
    CLGCDTimer *GCDTimer = [self timer:string];
    if (GCDTimer) {
        [GCDTimer start];
    }
}
//MARK:JmoVxia---执行一次定时器响应
+ (void)responseOnce:(NSString *_Nonnull)name {
    __strong NSString *string = name;
    CLGCDTimer *GCDTimer = [self timer:string];
    if (GCDTimer) {
        [GCDTimer responseOnce];
    }
}
//MARK:JmoVxia---取消定时器
+ (void)cancel:(NSString *_Nonnull)name {
    __strong NSString *string = name;
    CLGCDTimer *GCDTimer = [self timer:string];
    if (GCDTimer) {
        [GCDTimer cancel];
        [self removeTimer:name];
    }
}
//MARK:JmoVxia---暂停定时器
+ (void)suspend:(NSString *_Nonnull)name {
    __strong NSString *string = name;
    CLGCDTimer *GCDTimer = [self timer:string];
    if (GCDTimer) {
        [GCDTimer suspend];
    }
}
//MARK:JmoVxia---恢复定时器
+ (void)resume:(NSString *_Nonnull)name {
    __strong NSString *string = name;
    CLGCDTimer *GCDTimer = [self timer:string];
    if (GCDTimer) {
        [GCDTimer resume];
    }
}
//MARK:JmoVxia---获取定时器
+ (CLGCDTimer *_Nullable)timer:(NSString *_Nonnull)name {
    dispatch_semaphore_wait([CLGCDTimerManager sharedManager].semaphore, DISPATCH_TIME_FOREVER);
    __strong NSString *string = name;
    CLGCDTimer *GCDTimer = [[CLGCDTimerManager sharedManager].timerObjectCache objectForKey:string];
    dispatch_semaphore_signal([CLGCDTimerManager sharedManager].semaphore);
    return GCDTimer;
}
//MARK:JmoVxia---储存定时器
+ (void)setTimer:(CLGCDTimer *_Nonnull)timer name:(NSString *_Nonnull)name {
    dispatch_semaphore_wait([CLGCDTimerManager sharedManager].semaphore, DISPATCH_TIME_FOREVER);
    [[CLGCDTimerManager sharedManager].timerObjectCache setObject:timer forKey:name];
    dispatch_semaphore_signal([CLGCDTimerManager sharedManager].semaphore);
}
//MARK:JmoVxia---移除定时器
+ (void)removeTimer:(NSString *_Nonnull)name {
    dispatch_semaphore_wait([CLGCDTimerManager sharedManager].semaphore, DISPATCH_TIME_FOREVER);
    [[CLGCDTimerManager sharedManager].timerObjectCache removeObjectForKey:name];
    dispatch_semaphore_signal([CLGCDTimerManager sharedManager].semaphore);
}
@end
