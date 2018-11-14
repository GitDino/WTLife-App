//
//  WTMessageCell.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTTimestampModel, WTMessageModel, NIMMessage, WTBubbleImageView;

@protocol WTMessageCellDelegate <NSObject>

- (void)onTapHeadIconWithSessionId:(NSString *)sessionId;

- (void)onRetryMessage:(NIMMessage *)message;

- (void)onDeleteMessage:(NIMMessage *)message;

- (void)onRevokeMessage:(NIMMessage *)message;

- (void)onTapTextMessage:(NIMMessage *)message;

- (void)onTapImageMessage:(NIMMessage *)message bubbleImage:(WTBubbleImageView *)bubbleImage;

- (void)onTapAudioMessage:(NIMMessage *)message;

- (void)onTapVideoMessage:(NIMMessage *)message;

- (void)onTapGoodsMessage:(NIMMessage *)message;

- (void)onTapOrderMessage:(NIMMessage *)message;

@end

@interface WTMessageCell : UITableViewCell

@property (nonatomic, weak) id<WTMessageCellDelegate> delegate;

@property (nonatomic, strong) WTTimestampModel *timestampModel;

@property (nonatomic, strong) WTMessageModel *messageModel;

+ (instancetype)messageCellWithTableView:(UITableView *)tableView;

@end
