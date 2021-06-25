//
//  CLMailBoxTextView.h
//  CLDemo
//
//  Created by AUG on 2019/8/3.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLMailBoxTextView;

NS_ASSUME_NONNULL_BEGIN

@protocol CLMailBoxTextViewDelegate <NSObject>

@optional
///开始输入
- (void)textViewBeginEditing:(CLMailBoxTextView *)texteView;
///结束输入
- (void)textViewEndEditing:(CLMailBoxTextView *)texteView;
///输入改变
- (void)textViewDidChange:(CLMailBoxTextView *)texteView;

@end

@interface CLMailBoxTextViewConfigure : NSObject

///匹配邮箱数组
@property (nonatomic, strong) NSArray<NSString *> *mailMatchingArray;
///边距
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
///字体大小
@property (nonatomic, strong) UIFont *font;
///输入文字颜色
@property (nonatomic, strong) UIColor *textColor;
///补全后缀文字颜色
@property (nonatomic, strong) UIColor *suffixColor;

@end


@interface CLMailBoxTextView : UIView
///代理
@property (nonatomic, weak) id<CLMailBoxTextViewDelegate> delegate;
///输入的文字
@property (nonatomic, copy, readonly, nullable) NSString *text;

///更新基本配置，block不会造成循环引用
- (void)updateWithConfigure:(void(^)(CLMailBoxTextViewConfigure *configure))configureBlock;

///清除文字
- (void)clearText;


@end

NS_ASSUME_NONNULL_END
