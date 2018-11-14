//
//  WTUserHomeTableView.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/5.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTUserHomeTableView.h"
#import "WTUserFunctionSectionView.h"
#import "WTUserHomeCellModel.h"
#import "WTHeadIconCell.h"
#import "WTInfoNormalCell.h"
#import "WTUserPictureCell.h"
#import "WTUserTagCell.h"
#import "WTUserOrderCell.h"

@interface WTUserHomeTableView () <WTUserFunctionSectionViewDelegate, WTUserTagCellDelegate>

@end

@implementation WTUserHomeTableView

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
    else if ([cellModel.className isEqualToString:@"WTInfoNormalCell"])
    {
        WTInfoNormalCell *cell = [WTInfoNormalCell infoNormalCellWithTableView:tableView];
        cell.cellModel = cellModel;
        return cell;
    }
    else if ([cellModel.className isEqualToString:@"WTUserPictureCell"])
    {
        WTUserPictureCell *cell = [WTUserPictureCell userPictureCellWithTableView:tableView];
        cell.cellModel = cellModel;
        return cell;
    }
    else if ([cellModel.className isEqualToString:@"WTUserTagCell"])
    {
        WTUserTagCell *cell = [WTUserTagCell userTagCellWithTableView:tableView];
        cell.delegate = self;
        cell.cellModel = cellModel;
        return cell;
    }
    else
    {
        WTUserOrderCell *orderCell = [WTUserOrderCell userOrderCellWithTableView:tableView];
        orderCell.cellModel = cellModel;
        return orderCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTUserHomeCellModel *cellModel = [self obtainDataArray][indexPath.section][indexPath.row];
    return cellModel.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 3:
            return 37;
            break;
            
        default:
            return 10;
            break;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 3:
        {
            WTUserFunctionSectionView *sectionView = [WTUserFunctionSectionView userFunctionSectionView];
            sectionView.delegate = self;
            sectionView.sectionTagArray = self.sectionTagArray;
            return sectionView;
        }
            break;
            
        default:
            return [[UIView alloc] init];
            break;
    }
}

#pragma mark - WTUserFunctionSectionViewDelegate代理方法
- (void)onTapFunctionWithTag:(NSInteger)functionTag
{
    if (self.tapIndexFunctionBlock)
    {
        self.tapIndexFunctionBlock(functionTag);
    }
}

#pragma mark - WTUserTagCellDelegate代理方法
- (void)addCustomTag
{
    if (self.tapAddCustomTagBlock)
    {
        self.tapAddCustomTagBlock();
    }
}

@end
