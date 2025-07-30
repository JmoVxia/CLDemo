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
    CLLogLevelError   = 1 << 0,
    CLLogLevelWarning = 1 << 1,
    CLLogLevelMessage = 1 << 2,
    CLLogLevelDebug   = 1 << 3,
    CLLogLevelIM      = 1 << 4,
};

/**
 * 内部桥接函数，请勿直接调用。
 */
FOUNDATION_EXPORT void _CLLogInternal(CLLogLevel level, const char *file, const char *function, int line, NSString *format, ...);


// MARK: - 便捷宏 (Convenience Macros)

/**
 * @brief 记录【错误】级别的日志。
 * @param fmt 格式化字符串及参数。
 * @example CLLogError(@"认证失败: %@", error);
 */
#define CLLogError(fmt, ...)   _CLLogInternal(CLLogLevelError,   __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__)

/**
 * @brief 记录【警告】级别的日志。
 * @param fmt 格式化字符串及参数。
 * @example CLLogWarning(@"API 即将废弃: %@", apiName);
 */
#define CLLogWarning(fmt, ...) _CLLogInternal(CLLogLevelWarning, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__)

/**
 * @brief 记录【信息】级别的日志。
 * @param fmt 格式化字符串及参数。
 * @example CLLogMessage(@"用户 %@ 已登录", username);
 */
#define CLLogMessage(fmt, ...) _CLLogInternal(CLLogLevelMessage, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__)

/**
 * @brief 记录【调试】级别的日志。
 * @param fmt 格式化字符串及参数。
 * @example CLLogDebug(@"当前视图控制器的状态: %@", state);
 */
#define CLLogDebug(fmt, ...)   _CLLogInternal(CLLogLevelDebug,   __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__)

/**
 * @brief 记录【聊天】级别的日志。
 * @param fmt 格式化字符串及参数。
 * @example CLLogIM(@"收到一条新消息: %@", messageModel);
 */
#define CLLogIM(fmt, ...)      _CLLogInternal(CLLogLevelIM,      __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__)


// MARK: - 高级宏 (Advanced Macro)

/**
 * @brief 用于记录一个或多个组合日志级别的日志。
 * @discussion 当你需要同时指定多个级别时使用此宏。
 *
 * @param level 日志级别，可以使用 | (位或) 操作符组合，例如 (CLLogLevelWarning | CLLogLevelDebug)。
 * @param fmt   格式化字符串及参数。
 *
 * @example
 * CLLog(CLLogLevelWarning | CLLogLevelIM, @"一条重要的警告聊天消息: %@", message);
 */
#define CLLog(level, fmt, ...) _CLLogInternal(level, __FILE__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__)
