//
//  WTAdviserHomeTableView.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/6.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTAdviserHomeTableView.h"
#import "WTHeadIconCell.h"
#import "WTInfoNormalCell.h"
#import "WTUserHomeCellModel.h"

@implementation WTAdviserHomeTableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WTUserHomeCellModel *cellModel = [[[self obtainDataArray] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if ([cellModel.cellTitle isEqualToString:@"设置备注名和电话"] &&  self.tapIndexCellBlock)
    {
        self.tapIndexCellBlock(nil, 0);
    }
    else if ([cellModel.cellTitle isEqualToString:@"电话号码"] &&  self.tapIndexCellBlock)
    {
        self.tapIndexCellBlock(cellModel.cellContent, 1);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self obtainDataArray] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *targetArray = [self obtainDataArray][section];
    return targetArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTUserHomeCellModel *cellModel = [self obtainDataArray][indexPath.section][indexPath.row];
    if ([cellModel.className isEqualToString:@"WTHeadIconCell"])
    {
        WTHeadIconCell *cell = [WTHeadIconCell headIconCellWithTableView:tableView];
        cell.cellModel = cellModel;
        return cell;
    }
    else
    {
        WTInfoNormalCell *cell = [WTInfoNormalCell infoNormalCellWithTableView:tableView];
        cell.cellModel = cellModel;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTUserHomeCellModel *cellModel = [self obtainDataArray][indexPath.section][indexPath.row];
    return cellModel.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

@end
