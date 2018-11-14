//
//  CLLogManager.m
//  CLDemo
//
//  Created by AUG on 2018/11/13.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import "CLLogManager.h"
#import <sys/time.h>

@implementation CLLogManager

static NSFileHandle *TGLogFileHandle()
{
    static NSFileHandle *fileHandle = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      NSFileManager *fileManager = [[NSFileManager alloc] init];
                      
                      NSString *documentsDirectory = [Tools pathDocuments];
                      
                      NSString *currentFilePath = [documentsDirectory stringByAppendingPathComponent:@"application-0.log"];
                      NSString *oldestFilePath = [documentsDirectory stringByAppendingPathComponent:@"application-30.log"];
                      
                      if ([fileManager fileExistsAtPath:oldestFilePath])
                          [fileManager removeItemAtPath:oldestFilePath error:nil];
                      
                      for (int i = 60 - 1; i >= 0; i--)
                      {
                          NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"application-%d.log", i]];
                          NSString *nextFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"application-%d.log", i + 1]];
                          if ([fileManager fileExistsAtPath:filePath])
                          {
                              [fileManager moveItemAtPath:filePath toPath:nextFilePath error:nil];
                          }
                      }
                      
                      [fileManager createFileAtPath:currentFilePath contents:nil attributes:nil];
                      fileHandle = [NSFileHandle fileHandleForWritingAtPath:currentFilePath];
                      [fileHandle truncateFileAtOffset:0];
                  });
    
    return fileHandle;
}

void CLLogWithFile(NSString *format, ...)
{
    va_list L;
    va_start(L, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:L];
    NSLog(@"%@", message);
    // 开启异步子线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileHandle *output = TGLogFileHandle();
        if (output != nil) {
            time_t rawtime;
            struct tm timeinfo;
            char buffer[64];
            time(&rawtime);
            localtime_r(&rawtime, &timeinfo);
            struct timeval curTime;
            gettimeofday(&curTime, NULL);
            int milliseconds = curTime.tv_usec / 1000;
            strftime(buffer, 64, "%Y-%m-%d %H:%M", &timeinfo);
            char fullBuffer[128] = { 0 };
            snprintf(fullBuffer, 128, "%s:%2d.%.3d ", buffer, timeinfo.tm_sec, milliseconds);
            [output writeData:[[[NSString alloc] initWithCString:fullBuffer encoding:NSASCIIStringEncoding] dataUsingEncoding:NSUTF8StringEncoding]];
            [output writeData:[message dataUsingEncoding:NSUTF8StringEncoding]];
            static NSData *returnData = nil;
            if (returnData == nil)
                returnData = [@"\n" dataUsingEncoding:NSUTF8StringEncoding];
            [output writeData:returnData];
        }
    });
    va_end(L);
}



@end

