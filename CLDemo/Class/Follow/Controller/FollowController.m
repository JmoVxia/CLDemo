//
//  FollowController.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "FollowController.h"
#import "CalendarManger.h"
@interface FollowController ()

@end

@implementation FollowController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.title = @"收藏";
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [[CalendarManger sharedManger] calendarEventWithEventTitle:@"测试" startDate:[NSDate dateWithTimeIntervalSinceNow:80] endDate:[NSDate dateWithTimeIntervalSinceNow:90] alarmDate:[NSDate dateWithTimeIntervalSinceNow:5] eventIdKey:@"key"];
}



@end
