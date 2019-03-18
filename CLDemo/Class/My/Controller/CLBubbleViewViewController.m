//
//  CLBubbleViewViewController.m
//  CLDemo
//
//  Created by AUG on 2019/3/18.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLBubbleViewViewController.h"
#import "CLBubbleView.h"

@interface CLBubbleViewViewController ()

@property (nonatomic, strong) CLBubbleView *bubbleView;

@end

@implementation CLBubbleViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, self.view.cl_width, 200)];
    backgroundView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:backgroundView];
    
    self.bubbleView = [[CLBubbleView alloc] initWithFrame:CGRectMake(99, 99, 90, 90) superView:backgroundView];
    [backgroundView addSubview:self.bubbleView];
}




@end
