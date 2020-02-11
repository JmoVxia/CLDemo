//
//  CLVerticalItem.m
//  CLDemo
//
//  Created by AUG on 2019/11/21.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLVerticalItem.h"
#import "CLVerticalCell.h"

@implementation CLVerticalItem
///复用cell类型
- (Class)dequeueReusableCellClass {
    return [CLVerticalCell class];
}
@end
