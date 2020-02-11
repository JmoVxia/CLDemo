//
//  CLTransitionEnum.h
//  CLDemo
//
//  Created by AUG on 2019/7/19.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#ifndef CLTransitionEnum_h
#define CLTransitionEnum_h

typedef NS_ENUM(NSUInteger,CLInteractiveCoverDirection) {
    CLInteractiveCoverDirectionRightToLeft, //defualt
    CLInteractiveCoverDirectionLeftToRight,
    CLInteractiveCoverDirectionTopToBottom,
    CLInteractiveCoverDirectionBottomToTop
};


typedef NS_ENUM(NSUInteger, CLAnimatedTransitionType) {
    present,
    dismiss,
};




#endif /* CLTransitionEnum_h */
