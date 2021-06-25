//
//  NSDate+CLExtension.h
//  CLDemo
//
//  Created by AUG on 2019/6/8.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (CLExtension)

///系统当前运行了多长时间
+ (NSTimeInterval)uptimeSinceLastBoot;

@end

NS_ASSUME_NONNULL_END
