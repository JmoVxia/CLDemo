//
//  CLSearchViewController.h
//  CLSearchDemo
//
//  Created by AUG on 2018/10/28.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TapActionBlock)(NSString *name, NSString *bankCode);


@interface CLSearchViewController : UIViewController

/**点击回掉*/
@property (nonatomic, copy) TapActionBlock tapAction;

@end

NS_ASSUME_NONNULL_END
