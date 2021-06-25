//
//  CLHomepageModel.m
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/4/28.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

#import "CLHomepageModel.h"

@interface CLHomepageModel ()
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) Class controllerClass;
@end


@implementation CLHomepageModel
- (instancetype)initName: (NSString *)name controllerClass: (Class)controllerClass {
    if (self = [super init]) {
        self.name = name;
        self.controllerClass = controllerClass;
    }
    return  self;
}
@end
