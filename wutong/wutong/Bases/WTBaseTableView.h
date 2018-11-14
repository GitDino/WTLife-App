//
//  WTBaseTableView.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/6/27.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewProtocol.h"

typedef void(^clickIndexCellBlock)(NSIndexPath *indexPath, NSMutableArray *data_array);

@interface WTBaseTableView : UITableView <BaseTableViewProtocol>

@property (nonatomic, copy) clickIndexCellBlock clickIndexCellBlock;

@end
