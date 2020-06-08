//
//  LeftViewController.m
//  laiji
//
//  Created by xinguang hu on 2019/7/10.
//  Copyright © 2019 hxg. All rights reserved.
//

#import "LeftViewController.h"
#import "AddShortNoteVC.h"
#import "DataManager.h"
#import "ShortNote.h"
#import "SectionHeaderView.h"
#import "BaseNavigationController.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NavRightButton *addBtn;
@property (nonatomic, strong) NavRightButton *doneBtn;
@property (nonatomic, strong) NavLeftButton *editBtn;
@property (nonatomic, strong) NavLeftButton *cancelBtn;
@property (nonatomic, strong) UIBarButtonItem *leftItem;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *scrollToTopBtn;
@property (nonatomic, assign) int editMode;//删除模式(0)移动模式(1)
@property (nonatomic, strong) NSMutableArray<ShortNote *> *noteArray;
@property (nonatomic, strong) NSMutableArray<NoteItem *> *insertItems;
@property (nonatomic, strong) NSMutableArray<ShortNote *> *needUpdateNotes;

@end

@implementation LeftViewController

- (NavRightButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [[NavRightButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44) imageName:@"add" title:nil font:nil color:nil];
        [_addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (NavRightButton *)doneBtn{
    if (!_doneBtn) {
        _doneBtn = [[NavRightButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44) imageName:nil title:@"完成" font:[UIFont systemFontOfSize:17] color:[UIColor whiteColor]];
        [_doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
}

- (NavLeftButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [[NavLeftButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44) imageName:@"edit" title:nil font:nil color:nil];
        [_editBtn addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (NavLeftButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[NavLeftButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44) imageName:nil title:@"取消" font:[UIFont systemFontOfSize:17] color:[UIColor whiteColor]];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIBarButtonItem *)leftItem{
    if (!_leftItem) {
        _leftItem = [[UIBarButtonItem alloc]init];
    }
    return _leftItem;
}

- (UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc]init];
    }
    return _rightItem;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorColor = kAppThemeColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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

- (NSMutableArray<ShortNote *> *)noteArray{
    if (!_noteArray) {
        _noteArray = [NSMutableArray array];
    }
    return _noteArray;
}

- (NSMutableArray<NoteItem *> *)insertItems{
    if (!_insertItems) {
        _insertItems = [NSMutableArray array];
    }
    return _insertItems;
}

- (NSMutableArray<ShortNote *> *)needUpdateNotes{
    if (!_needUpdateNotes) {
        _needUpdateNotes = [NSMutableArray array];
    }
    return _needUpdateNotes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftItem.customView = self.editBtn;
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    self.rightItem.customView = self.addBtn;
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.scrollToTopBtn];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.scrollToTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.equalTo(self.view).with.offset(-15);
        make.size.mas_equalTo(self.scrollToTopBtn.imageView.image.size);
    }];
    
    self.noteArray = [DataManager getShortNotes];
    self.editMode = 0;
    
}

- (void)scrollToTop{
    CGPoint off = self.tableView.contentOffset;
    off.y = 0 - self.tableView.contentInset.top;
    [self.tableView setContentOffset:off animated:YES];
}

- (void)addAction{
    __weak typeof (self) weakSelf = self;
    AddShortNoteVC *vc =[[AddShortNoteVC alloc]initWithAddBlock:^(ShortNote *note) {
        weakSelf.noteArray = [DataManager getShortNotes];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)doneAction{
    self.title = @"便签";
    if (![DataManager addNoteItems:self.insertItems]) {
        [MBProgressHUD showErrorInWindowWithMessage:@"插入失败" hideDelay:1.5];
    }
    
    for (ShortNote *note in self.needUpdateNotes) {
        [DataManager updateItemsOfShortNote:note];
    }
    
    [self.insertItems removeAllObjects];
    [self.needUpdateNotes removeAllObjects];
    self.noteArray = [DataManager getShortNotes];

    self.editMode = 0;
    [self.tableView setEditing:NO animated:YES];
    self.leftItem.customView = self.editBtn;
    self.rightItem.customView = self.addBtn;
    
    [self.tableView reloadData];
    
}

- (void)editAction{
    self.title = @"编辑便签";
    self.editMode = 1;
    [self.tableView setEditing:YES animated:YES];
    self.leftItem.customView = self.cancelBtn;
    self.rightItem.customView = self.doneBtn;
}

- (void)cancelAction{
    self.title = @"便签";
    [self.insertItems removeAllObjects];
    self.editMode = 0;
    [self.tableView setEditing:NO animated:YES];
    self.leftItem.customView = self.editBtn;
    self.rightItem.customView = self.addBtn;
    self.noteArray = [DataManager getShortNotes];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.noteArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.noteArray[section].items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cellID";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = kAppThemeColor;
    cell.textLabel.text = self.noteArray[indexPath.section].items[indexPath.row].content;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ShortNote *note = self.noteArray[indexPath.section];
        NoteItem *item = note.items[indexPath.row];
        if (note.items.count > 1) {
            // 删除item
            if ([DataManager deleteNoteItem:item.itemId]) {
                [note.items removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView reloadData];
            }else{
                [MBProgressHUD showErrorInViewWithMessage:@"删除失败，请重试" hideDelay:1.5];
            }
        }else{
            // 删除note
            if ([DataManager deleteShortNote:item.snid]) {
                [self.noteArray removeObjectAtIndex:indexPath.section];
                [self.tableView reloadData];
            }
            
        }
        
    }else if (editingStyle == UITableViewCellEditingStyleInsert){
        ShortNote *note = self.noteArray[indexPath.section];
        NoteItem *item = [[NoteItem alloc]init];
        item.content = @"新内容";
        [note.items insertObject:item atIndex:indexPath.row];
        [self.insertItems addObject:item];
        if (![self.needUpdateNotes containsObject:note]) {
            [self.needUpdateNotes addObject:note];
        }
    
        for (int i=0; i<note.items.count; i++) {
            note.items[i].snid = note.snid;
            note.items[i].sequence = i;
        }
        [self.tableView reloadData];
    }
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    // 同一组内移动
    if (sourceIndexPath.section == destinationIndexPath.section) {
        
        ShortNote *note = self.noteArray[sourceIndexPath.section];
        NoteItem *sourceItem = note.items[sourceIndexPath.row];
        NSInteger currentIndex = sourceIndexPath.row;
        if (sourceIndexPath.row <= destinationIndexPath.row) {
            for (NSInteger i=sourceIndexPath.row; i<destinationIndexPath.row; i++) {
                currentIndex = [note.items indexOfObject:sourceItem];
                if (currentIndex < destinationIndexPath.row) {
                    [note.items exchangeObjectAtIndex:currentIndex withObjectAtIndex:currentIndex + 1];
                    currentIndex++;
                }
            }
        }else{
            for (NSInteger i=sourceIndexPath.row; i>destinationIndexPath.row; i--) {
                currentIndex = [note.items indexOfObject:sourceItem];
                if (currentIndex > destinationIndexPath.row) {
                    [note.items exchangeObjectAtIndex:currentIndex withObjectAtIndex:currentIndex - 1];
                    currentIndex--;
                }
            }
        }
        //更改排序
        for (int i=0; i<note.items.count; i++) {
            NoteItem *item = note.items[i];
            item.sequence = i;
        }
        
        if (sourceIndexPath.row != destinationIndexPath.row) {
            if (![self.needUpdateNotes containsObject:note]) {
                [self.needUpdateNotes addObject:note];
            }
        }
        
    }else{
        
        ShortNote *sourceNote = self.noteArray[sourceIndexPath.section];
        NoteItem *sourceItem = sourceNote.items[sourceIndexPath.row];
        [sourceNote.items removeObjectAtIndex:sourceIndexPath.row];

        ShortNote *destinationNote = self.noteArray[destinationIndexPath.section];
        [destinationNote.items insertObject:sourceItem atIndex:destinationIndexPath.row];
        for (int i=0; i<sourceNote.items.count; i++) {
            NoteItem *item = sourceNote.items[i];
            item.sequence = i;
        }
        for (int i=0; i<destinationNote.items.count; i++) {
            NoteItem *item = destinationNote.items[i];
            item.snid = destinationNote.snid;
            item.sequence = i;
        }
        
        if (![self.needUpdateNotes containsObject:sourceNote]) {
            [self.needUpdateNotes addObject:sourceNote];
        }
        if (![self.needUpdateNotes containsObject:destinationNote]) {
            [self.needUpdateNotes addObject:destinationNote];
        }
    
    }

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.editMode == 0) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleInsert;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.editMode == 0) {
        return @"删除";
    }else{
        return @"";
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NoteItem *item = self.noteArray[indexPath.section].items[indexPath.row];
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
            [DataManager updateNoteItem:item];
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

////只允许组内调整顺序
//- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
//    if (sourceIndexPath.section == proposedDestinationIndexPath.section) {
//        return proposedDestinationIndexPath;
//    }else{
//        [MBProgressHUD showWarningInViewWithMessage:@"只能在当前便签调整顺序哦" hideDelay:1.5];
//        return sourceIndexPath;
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    headerView.titleLabel.text = self.noteArray[section].title;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTapAction:)];
    [headerView addGestureRecognizer:tap];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(headerLongPressAction:)];
    [headerView addGestureRecognizer:longPress];
    
    
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    static NSString *sectionFooterID = @"sectionFooterID";
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionFooterID];
    if (!footerView) {
        footerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:sectionFooterID];
    }
    return footerView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > scrollView.bounds.size.height/2) {
        self.scrollToTopBtn.hidden = NO;
    }else{
        self.scrollToTopBtn.hidden = YES;
    }
}

- (void)headerTapAction:(UITapGestureRecognizer *)recognizer{

    ShortNote *note = self.noteArray[recognizer.view.tag];
    __weak typeof (self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"编辑" message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *textField = alert.textFields.firstObject;
        NSString *content = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (content.length > 0) {
            note.title = textField.text;
            [DataManager updateShortNoteTitle:note];
            [weakSelf.tableView reloadData];
        }else{
            [MBProgressHUD showTipInWindowWithMessage:@"内容不能为空" hideDelay:1.5];
        }
        
    }]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.text = note.title;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)headerLongPressAction:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        ShortNote *note = self.noteArray[recognizer.view.tag];
        __weak typeof (self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否要删除便签？" message:@"选择“删除”会移除该便签所有的内容" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.noteArray removeObjectAtIndex:recognizer.view.tag];
            [DataManager deleteShortNote:note.snid];
            [weakSelf.tableView reloadData];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
    
        [self presentViewController:alert animated:YES completion:nil];

    }
    
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
