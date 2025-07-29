//
//  CLLogBridge.m
//  CLDemo-Swift
//
//  Created by JmoVxia on 2025/7/29.
//

#import "CLLogBridge.h"
#import "CLDemo_Swift-Swift.h"

void CLLogBridge(NSString *format, CLLogLevel level, const char *file, const char *function, int line, ...) {
    va_list L;
    va_start(L, line);
    NSString *message = [[NSString alloc] initWithFormat:format arguments: L];
    va_end(L);

    NSString *fileName = [[NSString alloc] initWithUTF8String:file];
    NSString *functionName = [[NSString alloc] initWithUTF8String:function];

    [CLLogManager CLLogForOC:message
                  level:level
                   file:fileName
               function:functionName
                   line:line];
}
