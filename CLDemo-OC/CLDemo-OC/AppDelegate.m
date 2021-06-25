//
//  AppDelegate.m
//  CLDemo-OC
//
//  Created by Chen JmoVxia on 2021/6/21.
//

#import "AppDelegate.h"
#import "CLTabbarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CLTabbarController *tabbarController = [[CLTabbarController alloc] init];
    self.window.rootViewController = tabbarController;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
