//
//  UITableView+IndexTip.m
//  CLSearchDemo
//
//  Created by AUG on 2018/10/29.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import "UITableView+IndexTip.h"
#import "Aspects.h"


@implementation UITableView (IndexTip)


//MARK:JmoVxia---添加显示label
-(void)addIndexTipLabel:(UILabel *)label {
    NSObject * delegate = self.delegate;
    if(!delegate) {
        NSException *excp = [NSException exceptionWithName:@"设置TableView代理delegate" reason:@"调用addIndexTip方法之前，UITableView 需要设置delegate" userInfo:nil];
        [excp raise]; // 抛出异常,提示错误
        return;
    }
    if(![delegate respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
        NSException *excp = [NSException exceptionWithName:@"实现TableView代理方法" reason:@"UITableView delegate 需要实现方法sectionIndexTitlesForTableView:" userInfo:nil];
        [excp raise]; // 抛出异常,提示错误
        return;
    }
    if(![delegate respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)]) {
        NSException *excp = [NSException exceptionWithName:@"实现TableView代理方法" reason:@"UITableView delegate 需要实现方法tableView:sectionForSectionIndexTitle:atIndex:" userInfo:nil];
        [excp raise]; // 抛出异常,提示错误
        return;
    }
    //拦截索引代理
    [delegate aspect_hookSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, UITableView *tableView,NSString *title,NSInteger index) {
        [self handleWithIndexTitle:title atIndex:index label:label];
        return index;
    } error:NULL];
}

-(void)handleWithIndexTitle:(NSString *)title atIndex:(NSInteger)index label:(UILabel *)label{
    
    //找出TableView的索引视图UITableViewIndex
    UIView * view = (UIView*)self.subviews.lastObject;
    if(![NSStringFromClass([view class]) isEqualToString:@"UITableViewIndex"]) {
        for(UIView * sview in self.subviews){
            if([NSStringFromClass([sview class]) isEqualToString:@"UITableViewIndex"]) {
                view = sview;
                break;
            }
        }
    }
    CGPoint center = CGPointZero;
    center.x = -(view.frame.origin.x)/2.0;
    center.y = view.frame.size.height/2.0;
    //添加索引提示视图到UITableViewIndex上
    label.center = center;
    if(label.superview != view){
        [view addSubview:label];
    }
    //拦截TableView的索引视图UITableViewIndex的touches事件
    [view aspect_hookSelector:@selector(touchesBegan:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, NSSet *touches,UIEvent *event) {
        //搜索按钮不显示
        if ([title isEqualToString:UITableViewIndexSearch]) {
            label.hidden = YES;
        }else {
            label.hidden = NO;
        }
    } error:NULL];
    [view aspect_hookSelector:@selector(touchesMoved:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, NSSet *touches,UIEvent *event) {
        //搜索按钮不显示
        if ([title isEqualToString:UITableViewIndexSearch]) {
            label.hidden = YES;
        }else {
            label.hidden = NO;
        }
    } error:NULL];
    [view aspect_hookSelector:@selector(touchesEnded:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, NSSet *touches,UIEvent *event) {
        label.hidden = YES;
    } error:NULL];
    [view aspect_hookSelector:@selector(touchesCancelled:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, NSSet *touches,UIEvent *event) {
        label.hidden = YES;
    } error:NULL];
    label.text = title;
}
@end
