//
//  AppDelegate.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "AppDelegate.h"
#import "CLTabbarController.h"
#import "FPSDisplay.h"
#import "CLDemo-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    CLTabbarController *tbc = [[CLTabbarController alloc] init];
    self.window.rootViewController = tbc;
    [self.window makeKeyAndVisible];
    [self registerLocalNotification];
//    [FPSDisplay shareFPSDisplay];
    return YES;
}
- (void)registerLocalNotification{
    
    /**
     *iOS 8之后需要向系统注册通知，让用户开放权限
     */
    if (CurrenVersiongreaterThan(@"8.0")) {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    //    UIAlertView  *alert = [[UIAlertView alloc]initWithTitle:@"接收到本地通知" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //    [alert show];
    
    // 查看当前的状态出于(前台: 0)/(后台: 2)/(从后台进入前台: 1)
    CLLog(@"applicationState.rawValue: %zd", application.applicationState);
    
    // 执行响应操作
    // 如果当前App在前台,执行操作
    if (application.applicationState == UIApplicationStateActive) {
        CLLog(@"执行前台对应的操作");
    } else if (application.applicationState == UIApplicationStateInactive) {
        // 后台进入前台
        CLLog(@"执行后台进入前台对应的操作");
        CLLog(@"*****%@", notification.userInfo);
    } else if (application.applicationState == UIApplicationStateBackground) {
        // 当前App在后台
        
        CLLog(@"执行后台对应的操作");
    }
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if ([application.keyWindow isKindOfClass:[CLPopupManagerWindow class]]) {
        return application.keyWindow.rootViewController.supportedInterfaceOrientations;
    }
    return UIInterfaceOrientationMaskPortrait;
}




@end
