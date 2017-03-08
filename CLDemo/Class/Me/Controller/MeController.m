

//
//  MeController.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "MeController.h"

@interface MeController ()<UITableViewDataSource,UITableViewDelegate>

/**tableView*/
@property (nonatomic,strong) UITableView *tableView;
/**数据源*/
@property (nonatomic,strong) NSMutableArray *arrayDS;


@end

@implementation MeController


- (UITableView *) tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayDS = [NSMutableArray array];
    self.view.backgroundColor = [UIColor greenColor];
    self.navigationItem.title = @"朋友圈";
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayDS.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"aaa";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    return cell;
}




























@end
