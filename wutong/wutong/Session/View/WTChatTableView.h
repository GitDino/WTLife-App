//
//  WTChatTableView.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTChatTableViewProtcol.h"

@interface WTChatTableView : UITableView

@property (nonatomic, weak) id<WTChatTableViewProtcol> interactor;

- (void)refreshMessages:(NSMutableArray *)messages;

@end
