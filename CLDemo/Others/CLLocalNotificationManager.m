//
//  CLLocalNotificationManager.m
//  CLDemo
//
//  Created by JmoVxia on 2017/3/22.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLLocalNotificationManager.h"
#import <CommonCrypto/CommonDigest.h>
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
    
    NSString *notificationID = [self storedKeyWithFireDate:model.fireDate title:model.title];
    
    //新增前先清楚已注册的相同ID的本地推送
    [self deleteLocadNotificationWithModel:model dateBase:YES];
    
    //初始化
    UILocalNotification * localNotification = [[UILocalNotification alloc] init];
    
    //设置开火时间(演示为当前时间5秒后)
    localNotification.fireDate = [NSDate dateWithString:model.fireDate formatString:@"yyyy-MM-dd HH:mm:ss"];
    
    //设置时区，取手机系统默认时区
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    //重复次数 kCFCalendarUnitEra为不重复
    localNotification.repeatInterval = kCFCalendarUnitEra;
    
    //通知的主要内容
    localNotification.alertBody = model.title;
    
    //小提示
//    localNotification.alertAction = @"查看详情";
    
    //设置音效，系统默认为电子音，在系统音效中标号为1015
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    //or localNotification.soundName = @"send.caf" 自己的音频文件
    
    //localNotification.applicationIconBadgeNumber = 1; Icon上的红点和数字
    
    //查找本地系统通知的标识
    localNotification.userInfo = @{KEY_NOTIFICATION: notificationID};
    
    //提交到系统服务中，系统限制一个APP只能注册64条通知，已经提醒过的通知可以清除掉
    /**
     *64条是重点，必需mark一下
     */
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    model.isLocalNotification = YES;
    //添加id保存到数据库
    [self.localArray addObject:model];
    [self.cache setObject:self.localArray forKey:CLLocalArray];
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
    return [[UIApplication sharedApplication] scheduledLocalNotifications];
}

#pragma mark - 对比，是否过期

- (void)compareFiretime:(UILocalNotification *)notification needRemove:(void(^)(UILocalNotification * item))needRemove{
    
    NSComparisonResult result = [notification.fireDate compare:[NSDate date]];
    
    if (result == NSOrderedAscending) {
        needRemove(notification);
    }
    
}

#pragma mark - 注销一条本地推送(用于更新同一个ID的推送)

- (void)deleteLocadNotificationWithModel:(CLLocalNotificationModel *)model dateBase:(BOOL)dateBase{
    
    UILocalNotification * notification = [self queryNotificationWithNotificatioID:model.identifier];
    
    if (notification) {
        //删除通知中心
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
        //本地存在
        if (dateBase) {
            //从数据库删除
            [self.localArray removeObject:model];
        }else{
            //不删除数据库
            //取出对应模型替换
            NSInteger index = [self.localArray indexOfObject:model];
            model.isLocalNotification = NO;
            [self.localArray replaceObjectAtIndex:index withObject:model];
        }
        [self.cache setObject:self.localArray forKey:CLLocalArray];
    }
}


- (NSString *)storedKeyWithFireDate:(NSString *)fireDate title:(NSString *)title{
    
    NSString *string = [NSString stringWithFormat:@"%@%@", fireDate, title];
    
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












@end
