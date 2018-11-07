//
//  AppDelegate.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "AppDelegate.h"
#import "CLTabbarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    CLTabbarController *tbc = [[CLTabbarController alloc] init];
    self.window.rootViewController = tbc;
    [self.window makeKeyAndVisible];
    [self registerLocalNotification];

    
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
    NSLog(@"applicationState.rawValue: %zd", application.applicationState);
    
    // 执行响应操作
    // 如果当前App在前台,执行操作
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"执行前台对应的操作");
    } else if (application.applicationState == UIApplicationStateInactive) {
        // 后台进入前台
        NSLog(@"执行后台进入前台对应的操作");
        NSLog(@"*****%@", notification.userInfo);
    } else if (application.applicationState == UIApplicationStateBackground) {
        // 当前App在后台
        
        NSLog(@"执行后台对应的操作");
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
