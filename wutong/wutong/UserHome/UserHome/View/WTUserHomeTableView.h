//
//  WTUserHomeTableView.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/5.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTBaseTableView.h"

typedef void(^tapIndexCellBlock)(NSString *tel, NSInteger index);
typedef void(^tapIndexFunctionBlock)(NSInteger functionTag);
typedef void(^tapAddCustomTagBlock)(void);

@interface WTUserHomeTableView : WTBaseTableView

@property (nonatomic, copy) tapIndexCellBlock tapIndexCellBlock;

@property (nonatomic, copy) tapIndexFunctionBlock tapIndexFunctionBlock;

@property (nonatomic, copy) tapAddCustomTagBlock tapAddCustomTagBlock;

@property (nonatomic, strong) NSArray *sectionTagArray;

@end
