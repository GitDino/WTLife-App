//
//  WTInfoNormalCell.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/5.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTUserHomeCellModel;

@interface WTInfoNormalCell : UITableViewCell

@property (nonatomic, strong) WTUserHomeCellModel *cellModel;

+ (instancetype)infoNormalCellWithTableView:(UITableView *)tableView;

@end
