//
//  CLHomepageModel.h
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/4/28.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLHomepageModel : NSObject

@property (nonatomic, copy, readonly) NSString *name;

@property (nonatomic, assign, readonly) Class controllerClass;


- (instancetype)initName: (NSString *)name controllerClass: (Class)controllerClass;


@end

NS_ASSUME_NONNULL_END
