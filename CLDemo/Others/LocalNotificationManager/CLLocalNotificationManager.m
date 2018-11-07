//
//  CLLocalNotificationManager.m
//  CLDemo
//
//  Created by JmoVxia on 2017/3/22.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLLocalNotificationManager.h"
#import "YYCache.h"
#import "DateTools.h"

#define CLLocalArray  @"CLLocalArray"

#define KEY_NOTIFICATION @"this is a key for notification"


static CLLocalNotificationManager * manger = nil;

@interface CLLocalNotificationManager ()

/**cache*/
@property (nonatomic,strong) YYCache *cache;
/**localArray*/
@property (nonatomic,strong) NSMutableArray<CLLocalNotificationModel *> *localArray;


@end


@implementation CLLocalNotificationManager


+ (CLLocalNotificationManager *)sharedManger{
    // 线程锁
    @synchronized(self) {
        // 保证对象其唯一
        if(manger == nil){
            manger = [[CLLocalNotificationManager alloc] init];
        }
    }
    return manger;
}
- (instancetype)init{
    if (self = [super init]) {
        NSString *path = [[Tools pathDocuments] stringByAppendingPathComponent:@"CLLocalNotificationManager"];
        self.cache = [[YYCache alloc] initWithPath:path];
        NSMutableArray<CLLocalNotificationModel *> *array = (NSMutableArray *)[self.cache objectForKey:CLLocalArray];
        if (array) {
            self.localArray = array;
        }else{
            self.localArray  = [NSMutableArray array];
        }
    }
    return self;
}

- (void)insertLocalNotificationWithModel:(CLLocalNotificationModel *)model{
    
    //新增前先清楚已注册的相同ID的本地推送
    [self deleteLocadNotificationWithModel:model dateBase:YES];
    
    //初始化
    UILocalNotification * localNotification = [[UILocalNotification alloc] init];
    
    //设置开火时间(演示为当前时间5秒后)
    localNotification.fireDate = model.fireDate;
    
    //设置时区，取手机系统默认时区
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    //重复次数 kCFCalendarUnitEra为不重复
    localNotification.repeatInterval = 0;
    
    //通知的主要内容
    localNotification.alertBody = model.title;
    
    //小提示
    localNotification.alertAction = @"查看详情";
    
    //设置音效，系统默认为电子音，在系统音效中标号为1015
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    //or localNotification.soundName = @"send.caf" 自己的音频文件
    
    //localNotification.applicationIconBadgeNumber = 1; Icon上的红点和数字
    
    //查找本地系统通知的标识
    localNotification.userInfo = @{KEY_NOTIFICATION: model.identifier};
    
    //提交到系统服务中，系统限制一个APP只能注册64条通知，已经提醒过的通知可以清除掉
    /**
     *64条是重点，必需mark一下
     */
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    model.isLocalNotification = YES;
    //添加id保存到数据库
    [self.localArray addObject:model];
    [self.cache setObject:self.localArray forKey:CLLocalArray];
    NSArray *array = [self queryAllSystemNotifications];
    CLlog(@"+++%lu+++",(unsigned long)array.count);
}


#pragma mark - 查询符合条件的本地推送

- (UILocalNotification *)queryNotificationWithNotificatioID:(NSString *)notificatioID{
    
    NSArray * notifications = [self queryAllSystemNotifications];
    __block UILocalNotification * localnotification = nil;
    
    if (notifications.count > 0) {
        [notifications enumerateObjectsUsingBlock:^(UILocalNotification  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //查找符合条件的本地推送
            if ([obj.userInfo[KEY_NOTIFICATION] isEqualToString:notificatioID]) {
                localnotification = obj;
                *stop = YES;
            }
        }];
    }
    return localnotification;
}

#pragma mark - 查询所有已注册的本地推送

- (NSArray *)queryAllSystemNotifications{
    NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
    return array;
}

#pragma mark - 注销一条本地推送(用于更新同一个ID的推送)

- (void)deleteLocadNotificationWithModel:(CLLocalNotificationModel *)model dateBase:(BOOL)dateBase{
    
    UILocalNotification * notification = [self queryNotificationWithNotificatioID:model.identifier];
    if (notification) {        
        //删除通知中心
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
        NSArray *array = [self queryAllSystemNotifications];
        CLlog(@"---%lu---",(unsigned long)array.count);
    }
    if (dateBase) {
        //从数据库删除
        [self.localArray removeObject:model];
    }else{
        //不删除数据库
        model.isLocalNotification = NO;
    }
    [self.cache setObject:self.localArray forKey:CLLocalArray];
}

- (void)deleteAllLocalNotification{
    //删除所有
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self.localArray removeAllObjects];
    [self.cache setObject:self.localArray forKey:CLLocalArray];
}












@end
