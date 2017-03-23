//
//  Define.h
//  CLDemo
//
//  Created by JmoVxia on 2016/12/13.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#ifndef Define_h
#define Define_h


#define CLRandomColor [UIColor colorWithRed:arc4random_uniform(256.0)/255.0 green:arc4random_uniform(256.0)/255.0 blue:arc4random_uniform(256.0)/255.0 alpha:1.0]

#define ButtonTag    1132


#define CurrenVersiongreaterThan(X) ([[[UIDevice currentDevice] systemVersion] compare:X options:NSNumericSearch] != NSOrderedAscending)




#endif /* Define_h */
