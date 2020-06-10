//
//  BasePullFreshSimpleTableViewController.h
//  XiangFeiShu
//
//  Created by tanson on 2020/6/6.
//  Copyright © 2020 XiangFeiShu. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BasePullFreshSimpleTableViewController : BaseViewController

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) CGFloat rowHeight;
@property (nonatomic,assign) CGFloat estimatedRowHeight;
@property (nonatomic,assign) CGFloat sectionHeaderHeight;
@property (nonatomic,assign) CGFloat sectionFooterHeight;

//重写

-(void)getDataWithPage:(NSInteger)page
            completion:(void(^)(NSArray *dataSource,NSInteger limit))completion;

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
              model:(id)model;

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        model:(id)model;

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
           model:(id)model;

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
               model:(id)model;

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
               model:(id)model;

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
           model:(id)model;

-(void)deleteRowByModel:(id)model completion:(void(^)(void))completion;

-(void)showEmptyViewInTableView:(UITableView*)tableview;

@end

NS_ASSUME_NONNULL_END
