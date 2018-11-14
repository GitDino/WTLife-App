//
//  WTTextMessageContentView.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/5.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTMessageModel;

@protocol WTTextMessageContentViewDelegate <NSObject>

- (void)onTapText;

- (void)onDeleteText;

- (void)onRevokeText;

@end

@interface WTTextMessageContentView : UIView

@property (nonatomic, weak) id<WTTextMessageContentViewDelegate> delegate;

@property (nonatomic, strong) WTMessageModel *textMessage;

@end
