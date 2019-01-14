//
//  CLPasswordView.h
//  demo
//
//  Created by AUG on 2019/1/14.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLPasswordView : UIView

- (void)passwordEnd:(void(^)(NSString *password))end;


@end

NS_ASSUME_NONNULL_END
