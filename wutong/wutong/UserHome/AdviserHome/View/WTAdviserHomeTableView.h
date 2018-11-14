//
//  WTAdviserHomeTableView.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/6.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTBaseTableView.h"

typedef void(^tapIndexCellBlock)(NSString *tel, NSInteger index);

@interface WTAdviserHomeTableView : WTBaseTableView

@property (nonatomic, copy) tapIndexCellBlock tapIndexCellBlock;

@end
