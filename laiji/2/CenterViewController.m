//
//  CenterViewController.m
//  laiji
//
//  Created by xinguang hu on 2019/7/10.
//  Copyright © 2019 hxg. All rights reserved.
//

#import "CenterViewController.h"
#import "AddMemoVC.h"
#import "MemoDetailVC.h"
#import "DataManager.h"
#import "BaseNavigationController.h"

@interface CenterViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *scrollToTopBtn;
@property (nonatomic, strong) NSMutableArray<Memo *> *memoArray;

@end

@implementation CenterViewController

- (void)configRightItem{
    NavRightButton *rightBtn = [[NavRightButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44) imageName:@"add" title:nil font:nil color:nil];
    [rightBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.scrollToTopBtn];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.scrollToTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.equalTo(self.view).with.offset(-15);
        make.size.mas_equalTo(self.scrollToTopBtn.imageView.image.size);
    }];
    
    self.memoArray = [DataManager getMemos];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadList) name:@"RefreshMemoList" object:nil];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorColor = kAppThemeColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
    }
    return _tableView;
}

- (UIButton *)scrollToTopBtn{
    if (!_scrollToTopBtn) {
        _scrollToTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scrollToTopBtn setImage:kImageNamed(@"scroll_to_top") forState:UIControlStateNormal];
        [_scrollToTopBtn addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
        _scrollToTopBtn.hidden = YES;
    }
    return _scrollToTopBtn;
}

- (NSMutableArray *)memoArray{
    if (!_memoArray) {
        _memoArray = [NSMutableArray array];
    }
    return _memoArray;
}

- (void)addAction{
    __weak typeof (self) weakSelf = self;
    AddMemoVC *vc = [[AddMemoVC alloc]initWithAddBlock:^(Memo * _Nonnull m) {
        weakSelf.memoArray = [DataManager getMemos];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.memoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cellID";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.memoArray[indexPath.row].title;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:21];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@    %@",self.memoArray[indexPath.row].time,self.memoArray[indexPath.row].theme];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.textColor = kColorHex(@"666666");
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Memo *memo = self.memoArray[indexPath.row];
        if ([DataManager deleteMemo:memo.mid]) {
            [self.memoArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showTipInWindowWithMessage:@"删除失败" hideDelay:1.5];
        }
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MemoDetailVC *vc = [[MemoDetailVC alloc]init];
    vc.memo = self.memoArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)reloadList{
    [self.tableView reloadData];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
