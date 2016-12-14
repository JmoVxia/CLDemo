//
//  TitleControllerView.h
//  CLDemo
//
//  Created by JmoVxia on 2016/11/21.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleControllerView : UIView

/**
 根据传入参数创建UI

 @param titleArray 标题数组
 @param controllerClassNameArray 控制器类名数组
 @param titleNormalColorArray 标题常态颜色
 @param titleSelectedColorArray 标题选中颜色
 @param fatherController 父控制器
 */
- (void)initWithTitleArray:(NSMutableArray *)titleArray controllerClassNameArray:(NSMutableArray *)controllerClassNameArray titleNormalColorArray:(NSMutableArray *)titleNormalColorArray titleSelectedColorArray:(NSMutableArray *)titleSelectedColorArray fatherController:(UIViewController *)fatherController;

@end
