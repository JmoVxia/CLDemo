//
//  CLLogForOC.m
//  CLDemo
//
//  Created by JmoVxia on 2020/6/28.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

#import "CLLogForOC.h"
#import "CLDemo-Swift.h"

@implementation CLLogForOC

void CLLogWithFile(NSString *format, ...) {
    va_list L;
    va_start(L, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:L];
    va_end(L);
    [CLLogManager CLLogMessage:message];
}

@end
