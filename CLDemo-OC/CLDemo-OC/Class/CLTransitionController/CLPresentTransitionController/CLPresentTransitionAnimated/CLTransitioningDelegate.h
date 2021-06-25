//
//  CLTransitioningDelegate.h
//  CLDemo
//
//  Created by AUG on 2019/7/19.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLTransitionEnum.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLTransitioningDelegate : NSObject<UIViewControllerTransitioningDelegate>

-(instancetype)initWithPresentDirection:(CLInteractiveCoverDirection)presentDirection dissmissDirection:(CLInteractiveCoverDirection)dissmissDirection dissmissInteractiveController:(UIViewController *)dissmissInteractiveController;

@end

NS_ASSUME_NONNULL_END
