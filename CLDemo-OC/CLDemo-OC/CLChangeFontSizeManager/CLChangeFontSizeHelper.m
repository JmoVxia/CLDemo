//
//  CLChangeFontSizeManager.m
//  CLDemo
//
//  Created by AUG on 2018/11/12.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *CLChangeFontSizeKey = @"CLChangeFontSize";


#import "CLChangeFontSizeHelper.h"

@implementation CLChangeFontSizeHelper

+ (void)setFontSizeCoefficient:(NSInteger )coefficient {
    [[NSUserDefaults standardUserDefaults] setInteger:coefficient forKey:CLChangeFontSizeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)fontSizeCoefficient {
    NSInteger coefficient = [[NSUserDefaults standardUserDefaults] integerForKey:CLChangeFontSizeKey];
    if (coefficient == 0) {
        //返回默认2
        return 2;
    }
    return  coefficient;
}

+ (float)scaleCoefficient {
    NSInteger coefficient =[CLChangeFontSizeHelper fontSizeCoefficient];
    return 0.075 * (coefficient - 2) + 1;
}

@end
