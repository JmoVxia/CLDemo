//
//  CLLogBridge.h
//  CLDemo-Swift
//
//  Created by JmoVxia on 2025/7/29.
//

#import <Foundation/Foundation.h>

/**
 * @typedef CLLogLevel
 * @brief 定义日志级别的位掩码选项，与 Swift 的 CLLogLevel OptionSet 完全对应。
 */
typedef NS_OPTIONS(NSUInteger, CLLogLevel) {
    CLLogLevelError   = 1 << 0, // 1
    CLLogLevelWarning = 1 << 1, // 2
    CLLogLevelInfo    = 1 << 2, // 4
    CLLogLevelDebug   = 1 << 3, // 8
    CLLogLevelIM   = 1 << 4, // 16
};

/**
 * 这是底层的桥接函数，通常不直接调用。请使用下面的 CLLog 宏。
 */
FOUNDATION_EXPORT void CLLogBridge(NSString *format, CLLogLevel level, const char *file, const char *function, int line, ...);

/**
 * @brief 用于从 Objective-C 代码中记录日志的宏。
 * @discussion 它会自动捕获文件名、函数名和行号，并将所有参数传递给日志系统。
 *
 * @param level 日志级别，例如 CLLogLevelError 或 (CLLogLevelWarning | CLLogLevelDebug)。
 * @param fmt   格式化字符串，与 NSLog 相同。
 * @param ...   可变参数。
 *
 * @example
 * CLLog(@"用户ID: %@", CLLogLevelInfo, userID);
 */
#define CLLog(fmt, level, ...) CLLogBridge(fmt, level, __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__)
