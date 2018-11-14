//
//  WTSessionListCell.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/6/27.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTSession;

@interface WTSessionListCell : UITableViewCell

@property (nonatomic, strong) WTSession *wtSession;

+ (instancetype)sessionListCellWithTableView:(UITableView *) tableView;

@end
