//
//  AddShortNoteVC.m
//  laiji
//
//  Created by xinguang hu on 2019/7/10.
//  Copyright © 2019 hxg. All rights reserved.
//

#import "AddShortNoteVC.h"
#import "ShortNote.h"
#import "DataManager.h"
#import "SectionHeaderView.h"

@interface AddShortNoteVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addItemBtn;
@property (nonatomic, strong) ShortNote *note;
@property (nonatomic, copy  ) AddNoteBlock block;

@end

@implementation AddShortNoteVC

- (instancetype)initWithAddBlock:(AddNoteBlock)block{
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

-(void)configLeftItem{
    NavLeftButton *btn = [[NavLeftButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44) imageName:nil title:@"取消" font:[UIFont systemFontOfSize:17] color:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

-(void)configRightItem{
    NavRightButton *btn = [[NavRightButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44) imageName:nil title:@"保存" font:[UIFont systemFontOfSize:17] color:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"新便签";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addItemBtn];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.addItemBtn.mas_top);
    }];
    [self.addItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-kAppTabbarSafeBottomMargin);
        make.height.mas_equalTo(40);
    }];
   
}

- (ShortNote *)note{
    if (!_note) {
        _note = [[ShortNote alloc]init];
        _note.title = @"便签标题（点击编辑）";
        for (int i=0; i<3; i++) {
            NoteItem *item = [[NoteItem alloc]init];
            item.content = [NSString stringWithFormat:@"第%d条内容（侧滑删除）",i+1];
            item.sequence = i;
            [_note.items addObject:item];
        }
    }
    return _note;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorColor = kAppThemeColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)addItemBtn{
    if (!_addItemBtn) {
        _addItemBtn = [[UIButton alloc]init];
        _addItemBtn.backgroundColor = kAppThemeColor;
        [_addItemBtn setTitle:@"添加一条" forState:UIControlStateNormal];
        _addItemBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_addItemBtn addTarget:self action:@selector(addItem) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addItemBtn;
}

- (void)addItem{
    NoteItem *item = [[NoteItem alloc]init];
    item.content = [NSString stringWithFormat:@"第%d条内容（侧滑删除）",(int)self.note.items.count+1];
    item.sequence = (int)self.note.items.count;
    [self.note.items addObject:item];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.note.items.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveAction{
    self.note.create_time = (int)[[NSDate date] timeIntervalSince1970];
    [DataManager addShortNote:self.note];
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.block) {
            self.block(self.note);
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.note.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellID";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = kAppThemeColor;
    cell.textLabel.text = self.note.items[indexPath.row].content;
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        if (self.note.items.count > 1) {
            [self.note.items removeObjectAtIndex:[indexPath row]];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [tableView reloadData];
        }else{
            [MBProgressHUD showTipInWindowWithMessage:@"便签至少一条内容哦^_^" hideDelay:1.5];
        }
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NoteItem *item = self.note.items[indexPath.row];
    __weak typeof (self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"编辑" message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [weakSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
        UITextField *textField = alert.textFields.firstObject;
        NSString *content = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (content.length > 0) {
            item.content = textField.text;
            [weakSelf.tableView reloadData];
        }else{
            [MBProgressHUD showTipInWindowWithMessage:@"内容不能为空" hideDelay:1.5];
        }
        
    }]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.text = item.content;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *sectionHeaderID = @"SectionHeaderID";
    SectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderID];
    if (!headerView) {
        headerView = [[SectionHeaderView alloc]initWithReuseIdentifier:sectionHeaderID];
    }
    headerView.tag = section;
    headerView.titleLabel.text = self.note.title;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTapAction:)];
    [headerView addGestureRecognizer:tap];
    
    return headerView;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)headerTapAction:(UIGestureRecognizer *)recognizer{
    __weak typeof (self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"编辑" message:@"请输入标题" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *textField = alert.textFields.firstObject;
        NSString *content = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (content.length > 0) {
            weakSelf.note.title = textField.text;
            [weakSelf.tableView reloadData];
        }else{
            [MBProgressHUD showTipInWindowWithMessage:@"标题不能为空" hideDelay:1.5];
        }
        
    }]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.text = weakSelf.note.title;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
