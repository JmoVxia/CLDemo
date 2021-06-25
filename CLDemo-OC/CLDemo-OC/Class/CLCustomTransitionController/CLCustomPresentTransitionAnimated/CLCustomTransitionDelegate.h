//
//  CLCustomTransitionDelegate.h
//  CLDemo
//
//  Created by AUG on 2019/8/31.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLCustomTransitionDelegate : NSObject<UIViewControllerTransitioningDelegate>

///present时间
@property (nonatomic, assign) CGFloat presentDuration;

///dissmiss时间
@property (nonatomic, assign) CGFloat dissmissDuration;

@end

NS_ASSUME_NONNULL_END
