//
//  WTUserPictureCell.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTUserHomeCellModel;

@interface WTUserPictureCell : UITableViewCell

@property (nonatomic, strong) WTUserHomeCellModel *cellModel;

+ (instancetype)userPictureCellWithTableView:(UITableView *)tableView;

@end
