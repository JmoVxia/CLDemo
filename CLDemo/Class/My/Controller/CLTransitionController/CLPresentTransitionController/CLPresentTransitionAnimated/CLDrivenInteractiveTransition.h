//
//  CLDrivenInteractiveTransition.h
//  CLDemo
//
//  Created by AUG on 2019/7/19.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTransitionEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign, readonly) BOOL interactioning;

-(instancetype)initWithDissmissDirection:(CLInteractiveCoverDirection)dissmissDirection dissmissInteractiveController:(UIViewController *)dissmissInteractiveController;

@end

NS_ASSUME_NONNULL_END
