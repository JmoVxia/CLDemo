//
//  NSDate+CLExtension.m
//  CLDemo
//
//  Created by AUG on 2019/6/8.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "NSDate+CLExtension.h"
#import <sys/sysctl.h>

@implementation NSDate (CLExtension)

///系统当前运行了多长时间
///因为两个参数都会受用户修改时间的影响，因此它们想减的值是不变的
+ (NSTimeInterval)uptimeSinceLastBoot {
    //获取当前设备时间时间戳 受用户修改时间影响
    struct timeval now;
    struct timezone tz;
    gettimeofday(&now, &tz);
    
    //获取系统上次重启的时间戳 受用户修改时间影响
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    
    double uptime = -1;
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0) {
        //获取上次启动时间成功
        //秒
        uptime = now.tv_sec - boottime.tv_sec;
        //微秒
        uptime += (double)(now.tv_usec - boottime.tv_usec) / 1000000.0;
    }
    return uptime;
}

@end
