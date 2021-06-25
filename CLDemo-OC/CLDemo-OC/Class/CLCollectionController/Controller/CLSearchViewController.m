//
//  CLSearchViewController.m
//  CLSearchDemo
//
//  Created by AUG on 2018/10/28.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import "CLSearchViewController.h"
#import "BankModel.h"
#import "MJExtension.h"
#import "NSString+PinYin.h"
#import "UITableView+IndexTip.h"
#import "Masonry.h"
#import "UIFont+CLFont.h"
#import "UIButton+CLBlockAction.h"

@interface CLSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

/**tableView*/
@property (nonatomic, strong) UITableView *tableView;
/**数据源*/
@property (nonatomic, strong) NSArray *arrayDS;
/**关闭按钮*/
@property (nonatomic, strong) UIButton *closeButton;
/**标题*/
@property (nonatomic, strong) UILabel *titleLabel;
/**seachVC*/
@property (nonatomic, strong) UISearchBar *searchBar;
/*搜索后数据数组*/
@property (nonatomic, strong) NSMutableArray *searchedArray;
/*字典数组*/
@property (nonatomic, strong) NSDictionary *allKeysDict;
/*搜素数据数组*/
@property (nonatomic, strong) NSMutableArray *searchDataArray;
/*数据模型*/
@property (nonatomic, strong) BankModel *model;
/**是否正在搜索*/
@property (nonatomic, assign) BOOL active;
/**提示label*/
@property (nonatomic, strong) UILabel *indexTipLabel;

@end

@implementation CLSearchViewController
//MARK:JmoVxia---将要出现
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//MARK:JmoVxia---将要消失
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除键盘通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
//MARK:JmoVxia---键盘弹出
- (void) keyboardWillShow:(NSNotification *)notification {
    //主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        //获取键盘高度，在不同设备上，以及中英文下是不同的
        CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
        double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        //将视图上移计算好的偏移
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view).mas_offset(-kbHeight);
        }];
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
        }];
    });
}
//MARK:JmoVxia---键盘消失
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }];
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
        }];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //保证在UISearchController在激活状态下用户push到下一个view controller之后search bar不会仍留在界面上
    self.definesPresentationContext = YES;

    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
    
    [self mas_makeConstraints];
    
    [self initData];
}
//MARK:JmoVxia---约束
- (void)mas_makeConstraints {
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo([UIApplication sharedApplication].statusBarFrame.size.height);
        make.width.height.mas_equalTo(50);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.closeButton);
        make.centerX.mas_equalTo(0);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(self.closeButton.mas_bottom);
    }];
}
//MARK:JmoVxia---创建数据
- (void)initData {
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bank" ofType:@"json"]];
    NSString *receiveStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [receiveStr mj_JSONObject];
    
    self.model = [BankModel mj_objectWithKeyValues:dict];
    self.allKeysDict = [self createCharacterDictionaryWithArray:self.model.data];
    self.arrayDS = [self sortCharacterWithArray:self.allKeysDict.allKeys];
    self.searchedArray = [NSMutableArray arrayWithArray:[self sortCharacterWithArray:self.allKeysDict.allKeys]];
    [self.tableView reloadData];
}
//MARK:JmoVxia---将要开始搜索
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.active = YES;
    [searchBar setShowsCancelButton:YES animated:YES];
}
//MARK:JmoVxia---将要结束搜索
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.active = NO;
    [searchBar setShowsCancelButton:NO animated:YES];
}
//MARK:JmoVxia---搜索文字变化
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // 开启异步子线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray<BankDataModel *> *array = [self filterFuzzySearchFromArray:self.searchDataArray withWildcards:searchText];
        self.allKeysDict = [self createCharacterDictionaryWithArray:array];
        self.arrayDS = [self sortCharacterWithArray:self.allKeysDict.allKeys];
        self.searchedArray = [NSMutableArray arrayWithArray:[self sortCharacterWithArray:self.allKeysDict.allKeys]];
        // 主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            //解决设置偏移无效
            [self.tableView layoutIfNeeded];
            [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
        });
    });
}
//MARK:JmoVxia---点击取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [self searchBar:searchBar textDidChange:@""];
    [searchBar resignFirstResponder];
}
//MARK:JmoVxia---点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}
//MARK:JmoVxia---tableView右侧索引
- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView {
    //增加搜索
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.arrayDS];
    [array insertObject:UITableViewIndexSearch atIndex:0];
    return array;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if ([title isEqualToString:UITableViewIndexSearch]) {
        //搜索
        [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
        return NSNotFound;
    }else {
        return (index - 1);
    }
}
//MARK:JmoVxia---tableView头部视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont clFontOfSize:16];
    NSString *string;
    if (!self.active) {
        string = self.arrayDS[section];
    }else{
        string = self.searchedArray[section];
    }
    label.text = string;
    return label;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.active) {
        return self.arrayDS.count;
    }else{
        return self.searchedArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.active) {
        return [(NSArray*)self.allKeysDict[self.arrayDS[section]] count];
    }else{
        if (self.searchedArray.count != 0) {
            return [(NSArray*)self.allKeysDict[self.searchedArray[section]] count];
        }else{
            return 0;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.font = [UIFont clFontOfSize:16];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!self.active) {
        NSArray *stringArray = [[self.allKeysDict[self.arrayDS[indexPath.section]] objectAtIndex:indexPath.row] componentsSeparatedByString:@"+"];
        cell.textLabel.text = [stringArray firstObject];
    }else{
        NSArray *stringArray = [[self.allKeysDict[self.searchedArray[indexPath.section]] objectAtIndex:indexPath.row] componentsSeparatedByString:@"+"];
        cell.textLabel.text = [stringArray firstObject];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *stringArray = [[self.allKeysDict[self.arrayDS[indexPath.section]] objectAtIndex:indexPath.row] componentsSeparatedByString:@"+"];
    NSString *name = (NSString *)[stringArray firstObject];
    NSString *bankCode = (NSString *)[stringArray lastObject];
    //主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.tapAction) {
            self.tapAction(name, bankCode);
        }
        [self closeAction];
    });
}
//MARK:JmoVxia---按照字母排序
- (NSArray *)sortCharacterWithArray:(NSArray *)array {
    NSArray *tempArray = [NSArray arrayWithArray:array];
    tempArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(NSString *letter1, NSString *letter2) {
        if ((letter2 == nil || [letter2 isEqual:[NSNull null]] || letter2.length <= 0)) {
            return NSOrderedDescending;
        }else if ([letter1 characterAtIndex:0] < [letter2 characterAtIndex:0]) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    return tempArray;
}
//MARK:JmoVxia---创建以首字母为Key的字典数组
- (NSDictionary *)createCharacterDictionaryWithArray:(NSArray<BankDataModel *> *)array {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (BankDataModel *model in array) {
        NSArray *stringArray = [model.name componentsSeparatedByString:@"+"];
        NSString *string = [NSString stringWithFormat:@"%@+%@",[stringArray firstObject],model.bankCode];
        if ([string length]) {
            //大写字符串
            NSString *uppercaseString = [[string pinyinForSort:YES] uppercaseString];
            NSMutableArray *subArray = [dict objectForKey:[uppercaseString substringToIndex:1]];
            if (!subArray) {
                subArray = [NSMutableArray array];
                [dict setObject:subArray forKey:[uppercaseString substringToIndex:1]];
            }
            [subArray addObject:string];
        }
    }
    return dict;
}
//MARK:JmoVxia---模糊搜索
- (NSArray<BankDataModel *> *)filterFuzzySearchFromArray:(NSArray<BankDataModel *>*)sourceArray withWildcards:(NSString*)wildcards {
    NSMutableString *searchWithWildcards = [@"*" mutableCopy];
    [wildcards enumerateSubstringsInRange:NSMakeRange(0, [wildcards length])
                                  options:NSStringEnumerationByComposedCharacterSequences
                               usingBlock:^(NSString *substring, NSRange __unused substringRange, NSRange __unused enclosingRange, BOOL __unused*stop) {
                                   [searchWithWildcards appendString:substring];
                                   [searchWithWildcards appendString:@"*"];
                               }];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE[cd] %@", searchWithWildcards];
    NSArray<BankDataModel *> *filteredArray = [sourceArray filteredArrayUsingPredicate:predicate];
    return filteredArray;
}
//MARK:JmoVxia---关闭按钮响应
- (void)closeAction {
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

//MARK:JmoVxia---懒加载

/**seachVC*/
- (UISearchBar *)searchBar {
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.tintColor = [UIColor blackColor];
        _searchBar.backgroundImage = [[UIImage alloc] init];
        _searchBar.backgroundColor = [UIColor colorWithRed:247.1/255.0 green:247.3/255.0 blue:247.2/255.0 alpha:255.0/255.0];
        [_searchBar sizeToFit];
    }
    return _searchBar;
}
/**tableView*/
- (UITableView *) tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 44;
        _tableView.showsVerticalScrollIndicator = NO;
        //修改右边索引字体的颜色
        _tableView.sectionIndexColor = [UIColor blackColor];
        //解决开启索引导致左移
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:self.searchBar.frame];
        [_tableView.tableHeaderView addSubview:self.searchBar];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [_tableView addIndexTipLabel:self.indexTipLabel];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
/**arrayDS*/
- (NSArray *) arrayDS {
    if (_arrayDS == nil) {
        _arrayDS = [[NSArray alloc] init];
    }
    return _arrayDS;
}
/**searchDataArray*/
- (NSMutableArray *) searchDataArray {
    if (_searchDataArray == nil) {
        _searchDataArray = [[NSMutableArray alloc] init];
        NSArray *tempArray = [NSArray arrayWithArray:_model.data];
        [tempArray enumerateObjectsUsingBlock:^(BankDataModel * _Nonnull model, NSUInteger __unused idx, BOOL * _Nonnull __unused stop) {
            NSString *pinYinString = [model.name pinyinForSort:YES];
            model.name = [NSString stringWithFormat:@"%@+%@+yinhang",model.name,pinYinString];
            [self->_searchDataArray addObject:model];
        }];
    }
    return _searchDataArray;
}
/**closeButton*/
- (UIButton *) closeButton {
    if (_closeButton == nil) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"btn_x"] forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"btn_x"] forState:UIControlStateSelected];
        _closeButton.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
        __weak __typeof(self) weakSelf = self;
        [_closeButton addActionBlock:^(UIButton *button) {
            __typeof(&*weakSelf) strongSelf = weakSelf;
            [strongSelf closeAction];
        }];
        [self.view addSubview:_closeButton];
    }
    return _closeButton;
}
/**titleLabel*/
- (UILabel *) titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"选择银行";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont clFontOfSize:18];
        [self.view addSubview:_titleLabel];
    }
    return _titleLabel;
}
-(UILabel *)indexTipLabel {
    if(_indexTipLabel == nil) {
        _indexTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _indexTipLabel.layer.masksToBounds = YES;
        _indexTipLabel.layer.cornerRadius = 5;
        _indexTipLabel.backgroundColor = [UIColor colorWithRed:192.6/255.0 green:254.6/255.0 blue:61.7/255.0 alpha:255.0/255.0];
        _indexTipLabel.textAlignment = NSTextAlignmentCenter;
        _indexTipLabel.textColor = [UIColor whiteColor];
        _indexTipLabel.font = [UIFont clFontOfSize:24];
    }
    return _indexTipLabel;
}

-(void)dealloc {
    NSLog(@"银行卡选择页面销毁了");
}

@end
