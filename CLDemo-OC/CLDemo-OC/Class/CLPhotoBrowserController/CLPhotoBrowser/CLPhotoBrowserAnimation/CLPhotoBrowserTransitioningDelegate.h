//
//  CLPhotoBrowserTransitioningDelegate.h
//  Potato
//
//  Created by AUG on 2019/6/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLPhotoBrowserTransitioningDelegate : NSObject<UIViewControllerTransitioningDelegate>

///透明度
@property (nonatomic, assign) CGFloat alpha;

@end

NS_ASSUME_NONNULL_END
