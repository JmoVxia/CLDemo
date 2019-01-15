//
//  CLPasswordInputView.m
//  CLDemo
//
//  Created by AUG on 2019/1/15.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLPasswordInputView.h"
#import "UIColor+CLHex.h"
static NSString  * const MONEYNUMBERS = @"0123456789";

@implementation CLPasswordInputViewConfigure

+ (instancetype)defaultConfig {
    CLPasswordInputViewConfigure *configure = [[CLPasswordInputViewConfigure alloc] init];
    configure.squareWidth = 50;
    configure.passwordNum = 6;
    configure.pointRadius = 9 * 0.5;
    configure.spaceMultiple = 5;
    configure.rectColor = [UIColor colorWithRGBHex:0xb2b2b2];
    configure.pointColor = [UIColor blackColor];
    return configure;
}

@end

@interface CLPasswordInputView ()

@property (nonatomic, strong) CLPasswordInputViewConfigure *configure;

@property (nonatomic, strong) NSMutableString *password;

@end


@implementation CLPasswordInputView

- (CLPasswordInputViewConfigure *) configure{
    if (_configure == nil){
        _configure = [CLPasswordInputViewConfigure defaultConfig];
    }
    return _configure;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.password = [NSMutableString string];
        self.backgroundColor = [UIColor whiteColor];
        [self becomeFirstResponder];
    }
    return self;
}

- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}

- (BOOL)becomeFirstResponder {
    if ([self.delegate respondsToSelector:@selector(passwordBeginInput:)]) {
        [self.delegate passwordBeginInput:self];
    }
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    if ([self.delegate respondsToSelector:@selector(passwordEndInput:)]) {
        [self.delegate passwordEndInput:self];
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
- (void)updateWithConfig:(void(^)(CLPasswordInputViewConfigure *config))configBlock {
    if (configBlock) {
        configBlock(self.configure);
    }
    [self setNeedsDisplay];
}
#pragma mark - UIKeyInput

- (BOOL)hasText {
    return self.password.length > 0;
}

- (void)insertText:(NSString *)text {
    if (self.password.length < self.configure.passwordNum) {
        //判断是否是数字
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:MONEYNUMBERS] invertedSet];
        NSString*filtered = [[text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [text isEqualToString:filtered];
        if(basicTest) {
            [self.password appendString:text];
            if ([self.delegate respondsToSelector:@selector(passwordDidChange:)]) {
                [self.delegate passwordDidChange:self];
            }
            if (self.password.length == self.configure.passwordNum) {
                if ([self.delegate respondsToSelector:@selector(passwordCompleteInput:)]) {
                    [self.delegate passwordCompleteInput:self];
                }
            }
            [self setNeedsDisplay];
        }
    }
}

- (void)deleteBackward {
    if (self.password.length > 0) {
        [self.password deleteCharactersInRange:NSMakeRange(self.password.length - 1, 1)];
        if ([self.delegate respondsToSelector:@selector(passwordDidChange:)]) {
            [self.delegate passwordDidChange:self];
        }
    }
    if ([self.delegate respondsToSelector:@selector(passwordDidDeleteBackward:)]) {
        [self.delegate passwordDidDeleteBackward:self];
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
    CGFloat squareWidth = MAX(MIN(height, self.configure.squareWidth), (self.configure.pointRadius * 4));
    CGFloat middleSpace = (width - self.configure.passwordNum * squareWidth) / (self.configure.passwordNum - 1 + self.configure.spaceMultiple * 2);
    CGFloat leftSpace = middleSpace * self.configure.spaceMultiple;
    CGFloat y = (height - squareWidth) * 0.5;
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画外框
    for (int i = 0; i < self.configure.passwordNum; i++) {
        CGContextAddRect(context, CGRectMake(leftSpace + i * squareWidth + i * middleSpace, y, squareWidth, squareWidth));
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, self.configure.rectColor.CGColor);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextSetFillColorWithColor(context, self.configure.pointColor.CGColor);
    //画黑点
    for (int i = 1; i <= self.password.length; i++) {
        CGContextAddArc(context,  leftSpace + i * squareWidth + (i - 1) * middleSpace - squareWidth * 0.5, y + squareWidth * 0.5, self.configure.pointRadius, 0, M_PI * 2, YES);
        CGContextDrawPath(context, kCGPathFill);
    }
}

@end
