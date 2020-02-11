//
//  CLCustomTabbar.h
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

//自定义tabbar


#import <UIKit/UIKit.h>

@interface CLCustomTabbar : UITabBar

@property(nonatomic, copy) void (^bulgeCallBack) (void);

@end
