//
//  CLCardController.m
//  CLDemo
//
//  Created by AUG on 2019/2/26.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLCardController.h"
#import "CLCardView.h"

@interface CLCardController ()
///卡片视图
@property (nonatomic, strong) CLCardView *cardView;
@end

@implementation CLCardController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (CLCardView *) cardView{
    if (_cardView == nil){
        _cardView = [[CLCardView alloc] init];
    }
    return _cardView;
}


@end
