//
//  CLPassWordInputView.m
//  CLDemo
//
//  Created by AUG on 2019/1/15.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLPassWordInputView.h"
#import "UIColor+CLHex.h"
static NSString  * const MONEYNUMBERS = @"0123456789";

@implementation CLPassWordInputViewConfigure

+ (instancetype)defaultConfig {
    CLPassWordInputViewConfigure *configure = [[CLPassWordInputViewConfigure alloc] init];
    configure.squareWidth = 50;
    configure.passWordNum = 6;
    configure.pointRadius = 9 * 0.5;
    configure.spaceMultiple = 5;
    configure.rectColor = [UIColor colorWithRGBHex:0xb2b2b2];
    configure.pointColor = [UIColor blackColor];
    return configure;
}

@end

@interface CLPassWordInputView ()

@property (nonatomic, strong) CLPassWordInputViewConfigure *configure;
@property (strong, nonatomic) NSMutableString *textStore;//保存密码的字符串

@end


@implementation CLPassWordInputView

- (CLPassWordInputViewConfigure *) configure{
    if (_configure == nil){
        _configure = [CLPassWordInputViewConfigure defaultConfig];
    }
    return _configure;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textStore = [NSMutableString string];
        self.backgroundColor = [UIColor whiteColor];
        [self becomeFirstResponder];
    }
    return self;
}

- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}

- (BOOL)becomeFirstResponder {
    if ([self.delegate respondsToSelector:@selector(passWordBeginInput:)]) {
        [self.delegate passWordBeginInput:self];
    }
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    if ([self.delegate respondsToSelector:@selector(passWordEndInput:)]) {
        [self.delegate passWordEndInput:self];
    }
    return [super resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
}
- (void)updateWithConfig:(void(^)(CLPassWordInputViewConfigure *config))configBlock {
    if (configBlock) {
        configBlock(self.configure);
    }
    [self setNeedsDisplay];
}
#pragma mark - UIKeyInput

- (BOOL)hasText {
    return self.textStore.length > 0;
}

- (void)insertText:(NSString *)text {
    if (self.textStore.length < self.configure.passWordNum) {
        //判断是否是数字
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:MONEYNUMBERS] invertedSet];
        NSString*filtered = [[text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [text isEqualToString:filtered];
        if(basicTest) {
            [self.textStore appendString:text];
            if ([self.delegate respondsToSelector:@selector(passWordDidChange:)]) {
                [self.delegate passWordDidChange:self];
            }
            if (self.textStore.length == self.configure.passWordNum) {
                if ([self.delegate respondsToSelector:@selector(passWordCompleteInput:)]) {
                    [self.delegate passWordCompleteInput:self];
                }
            }
            [self setNeedsDisplay];
        }
    }
}

- (void)deleteBackward {
    if (self.textStore.length > 0) {
        [self.textStore deleteCharactersInRange:NSMakeRange(self.textStore.length - 1, 1)];
        if ([self.delegate respondsToSelector:@selector(passWordDidChange:)]) {
            [self.delegate passWordDidChange:self];
        }
    }
    if ([self.delegate respondsToSelector:@selector(passWordDidDeleteBackward:)]) {
        [self.delegate passWordDidDeleteBackward:self];
    }
    [self setNeedsDisplay];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
    CGFloat middleSpace = (width - self.configure.passWordNum * self.configure.squareWidth) / (self.configure.passWordNum - 1 + self.configure.spaceMultiple * 2);
    CGFloat leftSpace = middleSpace * self.configure.spaceMultiple;
    CGFloat y = (height - self.configure.squareWidth) * 0.5;
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画外框
    for (int i = 0; i < self.configure.passWordNum; i++) {
        CGContextAddRect(context, CGRectMake(leftSpace + i * self.configure.squareWidth + i * middleSpace, y, self.configure.squareWidth, self.configure.squareWidth));
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, self.configure.rectColor.CGColor);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextSetFillColorWithColor(context, self.configure.pointColor.CGColor);
    //画黑点
    for (int i = 1; i <= self.textStore.length; i++) {
        CGContextAddArc(context,  leftSpace + i * self.configure.squareWidth + (i - 1) * middleSpace - self.configure.squareWidth * 0.5, y + self.configure.squareWidth * 0.5, self.configure.pointRadius, 0, M_PI * 2, YES);
        CGContextDrawPath(context, kCGPathFill);
    }
}

@end
