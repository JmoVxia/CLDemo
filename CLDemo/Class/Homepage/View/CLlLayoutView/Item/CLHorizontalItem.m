//
//  CLHorizontalItem.m
//  Potato
//
//  Created by AUG on 2019/11/4.
//

#import "CLHorizontalItem.h"
#import "CLHorizontalCell.h"

@implementation CLHorizontalItem
///复用cell类型
- (Class)dequeueReusableCellClass {
    return [CLHorizontalCell class];
}
@end
