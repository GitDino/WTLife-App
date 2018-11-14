//
//  WTBaseTableView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/6/27.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTBaseTableView.h"

@interface WTBaseTableView ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WTBaseTableView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _dataArray = [NSMutableArray array];
        
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

#pragma mark - BaseTableViewProtocol协议方法
- (void)refreshData:(NSArray *)data_array
{
    if (self.dataArray == nil)
    {
        [self.dataArray addObjectsFromArray:data_array];
    }
    else
    {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:data_array];
    }
    [self reloadData];
}

- (id)obtainDataWithIndex:(NSIndexPath *)indexPath
{
    return self.dataArray[indexPath.row];
}

- (NSArray *)obtainDataArray
{
    return self.dataArray;
}

#pragma mark - UITableViewDataSource数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"BaseTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

#pragma mark - UITableViewDelegate代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.clickIndexCellBlock)
    {
        self.clickIndexCellBlock(indexPath, self.dataArray);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 6.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

@end
