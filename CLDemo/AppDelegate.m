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
//    [FPSDisplay shareFPSDisplay];
    return YES;
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if ([application.keyWindow isKindOfClass:[CLPopupManagerWindow class]]) {
        CLPopupManagerController *controller = (CLPopupManagerController *)application.keyWindow.rootViewController;
        UIInterfaceOrientationMask mask = controller.supportedInterfaceOrientations;
        return mask;
    }else {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}


@end
