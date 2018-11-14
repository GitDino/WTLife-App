//
//  WTSessionListTableView.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/6/27.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTBaseTableView.h"

typedef void(^tapDeleteSessionCellBlock)(NIMRecentSession *recentSession);

@interface WTSessionListTableView : WTBaseTableView

@property (nonatomic, copy) tapDeleteSessionCellBlock tapDeleteSessionCellBlock;

@end
