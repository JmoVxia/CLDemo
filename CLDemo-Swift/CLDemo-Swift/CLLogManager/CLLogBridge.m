//
//  CLLogBridge.m
//  CLDemo-Swift
//
//  Created by JmoVxia on 2025/7/29.
//

#import "CLLogBridge.h"
#import "CLDemo_Swift-Swift.h" // 确保你的项目名正确，例如 "YourProjectName-Swift.h"

void _CLLogInternal(CLLogLevel level, const char *file, const char *function, int line, NSString *format, ...) {
    // 处理可变参数
    va_list args;
    va_start(args, format);
    // 使用 initWithFormat:arguments: 安全地处理可变参数
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    // 健壮性保护：安全地将 C 字符串转换为 NSString
    NSString *fileName = file ? [[NSString alloc] initWithUTF8String:file] : @"<Unknown File>";
    NSString *functionName = function ? [[NSString alloc] initWithUTF8String:function] : @"<Unknown Function>";

    // 直接调用Swift暴露的OC方法
    [CLLogManager logForObjectiveC:message
                             level:level
                              file:fileName
                          function:functionName
                              line:line];
}
