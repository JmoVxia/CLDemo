//
//  CLLogView.m
//  CLDemo-Swift
//
//  Created by 菜鸽途讯 on 2025/7/29.
//

#import "CLLogView.h"
#import "CLLogBridge.h"

@implementation CLLogView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CLLog(CLLogLevelMessage | CLLogLevelDebug, @"OC调用日志");
    }
    return self;
}

@end
