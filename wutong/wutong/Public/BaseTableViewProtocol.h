//
//  BaseTableViewProtocol.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/6/27.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseTableViewProtocol <NSObject, UITableViewDataSource, UITableViewDelegate>

- (void)refreshData:(NSArray *) data_array;

- (id)obtainDataWithIndex:(NSIndexPath *) indexPath;

- (NSArray *)obtainDataArray;

@end
