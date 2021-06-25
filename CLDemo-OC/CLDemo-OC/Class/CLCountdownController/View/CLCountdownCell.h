//
//  CLCountdownCell.h
//  CLDemo
//
//  Created by AUG on 2019/6/6.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLCountdownModel;


NS_ASSUME_NONNULL_BEGIN

@interface CLCountdownCell : UITableViewCell

///model
@property (nonatomic, strong) CLCountdownModel *model;

@end

NS_ASSUME_NONNULL_END
