//
//  CLLogManager.h
//  CLDemo
//
//  Created by AUG on 2018/11/13.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLLogManager : NSObject

/**
 自定义打印，会自动写文件
 */
void CLLogWithFile(NSString *format, ...);

@end

NS_ASSUME_NONNULL_END
