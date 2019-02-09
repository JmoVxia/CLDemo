//
//  CLLogViewController.m
//  CLDemo
//
//  Created by AUG on 2019/2/8.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLLogViewController.h"
#import "Masonry.h"

@interface CLLogViewController ()<UITableViewDelegate, UITableViewDataSource>
/**tableview*/
@property (nonatomic, strong) UITableView *tableView;
/**数据源*/
@property (nonatomic, strong) NSArray<NSString *> *array;

@end

@implementation CLLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL fileURLWithPath:[Tools.pathDocuments stringByAppendingString:@"/application-0.log"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableArray<NSString *> *array = [NSMutableArray arrayWithArray:[string componentsSeparatedByString:@"\n"]];
    [array removeLastObject];
    self.array = array;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop);
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = self.array[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont clFontOfSize:18];
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor lightGrayColor];
    }else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.selectionStyle = normal;
    return cell;
}

- (UITableView *) tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


@end
