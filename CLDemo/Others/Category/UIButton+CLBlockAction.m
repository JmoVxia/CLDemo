//
//  UIButton+CLBlockAction.m
//  CLDemo
//
//  Created by AUG on 2018/11/9.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import "UIButton+CLBlockAction.h"
#import <objc/runtime.h>

static void *CLActionBlock = "CLActionBlock";

@implementation UIButton (CLBlockAction)

- (void)addActionBlock:(ActionBlock)block forControlEvents:(UIControlEvents)controlEvents {
    objc_setAssociatedObject(self, CLActionBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(action:) forControlEvents:controlEvents];
}
- (void)addActionBlock:(ActionBlock)block {
    [self addActionBlock:block forControlEvents:UIControlEventTouchUpInside];
}
- (void)action:(UIButton *)button {
    ActionBlock actionBlock = (ActionBlock)objc_getAssociatedObject(self, CLActionBlock);
    if (actionBlock) {
        actionBlock(button);
    }
}
@end
