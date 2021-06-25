//
//  CLBubbleViewController.m
//  CLDemo
//
//  Created by AUG on 2019/3/18.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLBubbleViewController.h"
#import "CLBubbleView.h"
#import "UIView+CLSetRect.h"

@interface CLBubbleViewController ()

@property (nonatomic, strong) CLBubbleView *bubbleView;

@end

@implementation CLBubbleViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, self.view.cl_width, 200)];
    backgroundView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:backgroundView];
    
    self.bubbleView = [[CLBubbleView alloc] initWithFrame:CGRectMake(99, 99, 90, 90)];
    self.bubbleView.cl_centerX = backgroundView.cl_width * 0.5;
    self.bubbleView.cl_centerY = backgroundView.cl_height * 0.5;
    self.bubbleView.textColor = [UIColor whiteColor];
    self.bubbleView.font = [UIFont systemFontOfSize:24];
    self.bubbleView.text = @"1";

    [backgroundView addSubview:self.bubbleView];
}




@end
