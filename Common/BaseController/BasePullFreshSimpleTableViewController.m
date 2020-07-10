//
//  BasePullFreshSimpleTableViewController.m
//  XiangFeiShu
//
//  Created by tanson on 2020/6/6.
//  Copyright © 2020 XiangFeiShu. All rights reserved.
//

#import "BasePullFreshSimpleTableViewController.h"

#define minPage 1

@interface BasePullFreshSimpleTableViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,assign) NSInteger  page;

@end

@implementation BasePullFreshSimpleTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _rowHeight = -1;
    _estimatedRowHeight = 0;
    _sectionHeaderHeight = 0.000001;
    _sectionFooterHeight = 0.000001;
    _page = minPage;
    
    [self.view addSubview:self.tableView];
    @weakify(self);
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.page = minPage;
        [self getData];
    }];
    ((MJRefreshStateHeader*)self.tableView.mj_header).lastUpdatedTimeLabel.hidden = YES;
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.page ++;
        [self getData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGRect frame = self.view.bounds;
    if (@available(iOS 11.0, *)) {
        frame.size.height -= self.view.safeAreaInsets.bottom;
    }
    self.tableView.frame = frame;
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 0;
        if(_estimatedRowHeight > 0){
            _tableView.rowHeight = UITableViewAutomaticDimension;
            _tableView.estimatedRowHeight = _estimatedRowHeight;
        }
    }
    return _tableView;
}

-(void)setEstimatedRowHeight:(CGFloat)estimatedRowHeight{
    _estimatedRowHeight = estimatedRowHeight;
    self.tableView.estimatedRowHeight = estimatedRowHeight;
    [self.tableView reloadData];
}

-(BOOL)_isMutilSection{
    return _sectionHeaderHeight >0.000001 || _sectionFooterHeight > 0.000001;
}

-(id)_modelFromIndex:(NSIndexPath*)index{
    if([self _isMutilSection]){
        return self.dataSource[index.section];
    }
    return self.dataSource[index.row];
}

-(void)_deleteByIndex:(NSIndexPath*)index{
    Weakself
    [self deleteRowByModel:[self _modelFromIndex:index] completion:^{
        if([weakSelf _isMutilSection]){
            [weakSelf.dataSource removeObjectAtIndex:index.section];
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView deleteSection:index.section withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.tableView endUpdates];
        }else{
            [weakSelf.dataSource removeObjectAtIndex:index.row];
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView deleteRowAtIndexPath:index withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.tableView endUpdates];
        }
    }];
}

-(void)getData{
    @weakify(self)
    [self getDataWithPage:_page completion:^(NSArray * dataSource,NSInteger limit) {
        @strongify(self)
        
        if(self.page <= minPage){
            self.dataSource = dataSource.mutableCopy;
            [self.tableView reloadData];
        }else if([self _isMutilSection]){
            NSRange range = NSMakeRange(self.dataSource.count, dataSource.count);
            NSIndexSet * inset = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.dataSource addObjectsFromArray:dataSource];
            [self.tableView beginUpdates];
            [self.tableView insertSections:inset withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }else{
            NSMutableArray * paths = @[].mutableCopy;
            for (int i=0; i<dataSource.count; ++i) {
                NSIndexPath * p = [NSIndexPath indexPathForRow:self.dataSource.count+i inSection:0];
                [paths addObject:p];
            }
            [self.dataSource addObjectsFromArray:dataSource];
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
        
        if(self.dataSource.count <= 0){
            [self showEmptyViewInTableView:self.tableView];
        }else{
            self.tableView.backgroundView = nil;
            self.tableView.scrollEnabled = YES;
        }
        dataSource.count<limit? [self.tableView.mj_footer endRefreshingWithNoMoreData]:[self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}


#pragma mark- 重写

-(void)deleteRowByModel:(id)model completion:(void(^)(void))completion{
    completion();
}

-(void)getDataWithPage:(NSInteger)page completion:(void(^)(NSArray *dataSource,NSInteger limit))completion{
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
              model:(id)model{
    if(self.rowHeight > 0)return self.rowHeight;
    return 44;
}

-(void)showEmptyViewInTableView:(UITableView*)tableview{
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        model:(id)model{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
           model:(id)model{
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
               model:(id)model{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
               model:(id)model{
    return nil;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
           model:(id)model{
    return NO;
}

#pragma mark-

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(!self.dataSource)return 0;
    return [self _isMutilSection]? [self.dataSource count]:1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(!self.dataSource)return 0;
    return [self _isMutilSection]? 1:[self.dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath model:[self _modelFromIndex:indexPath]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self tableView:tableView heightForRowAtIndexPath:indexPath model:[self _modelFromIndex:indexPath]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.sectionHeaderHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.sectionFooterHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    id model = [self _isMutilSection]? self.dataSource[section]:nil;
    return [self tableView:tableView viewForHeaderInSection:section model:model];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    id model = [self _isMutilSection]? self.dataSource[section]:nil;
    return [self tableView:tableView viewForFooterInSection:section model:model];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self tableView:tableView didSelectRowAtIndexPath:indexPath model:[self _modelFromIndex:indexPath]];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self tableView:tableView canEditRowAtIndexPath:indexPath model:[self _modelFromIndex:indexPath]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self _deleteByIndex:indexPath];
    }
}
// ios11 +
- ( UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    Weakself
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [tableView setEditing:NO animated:YES];
        completionHandler (YES);
        [weakSelf _deleteByIndex:indexPath];
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    config.performsFirstActionWithFullSwipe = NO;
    return config;
}

@end
