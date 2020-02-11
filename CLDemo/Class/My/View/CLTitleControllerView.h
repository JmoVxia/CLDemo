//
//  CLTitleControllerView.h
//  CLDemo
//
//  Created by JmoVxia on 2016/11/21.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLTitleControllerView : UIView

/**
 根据传入参数创建UI

 @param titleArray 标题数组
 @param controllerClassNameArray 控制器类名数组
 @param titleNormalColorArray 标题常态颜色
 @param titleSelectedColorArray 标题选中颜色
 @param number  可见标题个数
 @param fatherController 父控制器
 */
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSMutableArray *)titleArray controllerClassNameArray:(NSMutableArray *)controllerClassNameArray titleNormalColorArray:(NSMutableArray *)titleNormalColorArray titleSelectedColorArray:(NSMutableArray *)titleSelectedColorArray number:(NSInteger)number fatherController:(UIViewController *)fatherController;



@end
