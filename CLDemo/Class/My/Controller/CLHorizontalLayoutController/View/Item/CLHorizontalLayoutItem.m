//
//  CLHorizontalLayoutItem.m
//  CLDemo
//
//  Created by AUG on 2019/11/2.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLHorizontalLayoutItem.h"
#import "CLHorizontalLayoutItemProtocol.h"
#import "CLHorizontalLayoutCell.h"

@interface CLHorizontalLayoutItem ()<CLHorizontalLayoutItemProtocol>

@end

@implementation CLHorizontalLayoutItem

///复用cell类型
- (Class)dequeueReusableCellClass {
    return [CLHorizontalLayoutCell class];
}

@end
