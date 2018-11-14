//
//  WTHeadIconCell.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/5.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTUserHomeCellModel;

@interface WTHeadIconCell : UITableViewCell

@property (nonatomic, strong) WTUserHomeCellModel *cellModel;

+ (instancetype)headIconCellWithTableView:(UITableView *)tableView;

@end
