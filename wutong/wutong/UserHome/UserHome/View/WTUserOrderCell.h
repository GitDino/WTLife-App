//
//  WTUserOrderCell.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTUserHomeCellModel;

@interface WTUserOrderCell : UITableViewCell

@property (nonatomic, strong) WTUserHomeCellModel *cellModel;

+ (instancetype)userOrderCellWithTableView:(UITableView *)tableView;

@end
