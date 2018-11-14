//
//  WTUserTagCell.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTUserHomeCellModel;

@protocol WTUserTagCellDelegate <NSObject>

- (void)addCustomTag;

@end

@interface WTUserTagCell : UITableViewCell

@property (nonatomic, weak) id<WTUserTagCellDelegate> delegate;

@property (nonatomic, strong) WTUserHomeCellModel *cellModel;

+ (instancetype)userTagCellWithTableView:(UITableView *)tableView;

@end
