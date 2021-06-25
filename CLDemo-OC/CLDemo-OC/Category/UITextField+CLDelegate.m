//
//  UITextField+CLDelegate.m
//  demo
//
//  Created by AUG on 2019/1/14.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "UITextField+CLDelegate.h"
#import <objc/runtime.h>

@implementation UITextField (CLDelegate)

+ (void)load {
    //交换2个方法中的IMP
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"deleteBackward"));
    Method method2 = class_getInstanceMethod([self class], @selector(cl_deleteBackward));
    method_exchangeImplementations(method1, method2);
}
- (void)cl_deleteBackward {
    [self cl_deleteBackward];
    if ([self.delegate respondsToSelector:@selector(textFieldDidDeleteBackward:)]) {
        id <CLTextFieldDelegate> delegate  = (id<CLTextFieldDelegate>)self.delegate;
        [delegate textFieldDidDeleteBackward:self];
    }
}

@end
