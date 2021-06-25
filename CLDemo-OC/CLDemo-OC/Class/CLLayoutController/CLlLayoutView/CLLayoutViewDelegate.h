//
//  CLLayoutViewDelegate.h
//  Potato
//
//  Created by AUG on 2019/11/3.
//

#import <Foundation/Foundation.h>
@class CLLayoutView;

NS_ASSUME_NONNULL_BEGIN

@protocol CLLayoutViewDelegate <NSObject>

@optional
- (void)layoutView:(CLLayoutView *)layoutView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
