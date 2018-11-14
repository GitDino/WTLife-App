//
//  WTSessionListTableView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/6/27.
//  Copyright © 2018年 wutonglife. All rights reserved.
//
#import <NIMSDK/NIMSDK.h>
#import "WTSessionListTableView.h"
#import "WTSessionListCell.h"
#import "WTSession.h"

@implementation WTSessionListTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTSessionListCell *cell = [WTSessionListCell sessionListCellWithTableView:tableView];
    WTSession *wtSession = [self obtainDataWithIndex:indexPath];
    cell.wtSession = wtSession;
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        WTSession *wtSession = [self obtainDataWithIndex:indexPath];
        NIMRecentSession *recentSession = wtSession.recentSession;
        if (self.tapDeleteSessionCellBlock)
        {
            self.tapDeleteSessionCellBlock(recentSession);
        }
        [tableView setEditing:NO animated:YES];
    }];
    return @[delete];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
