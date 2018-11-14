//
//  WTCommonMessageCellView.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/5.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTMessageModel.h"
@class WTBubbleImageView;

@protocol WTCommonMessageCellViewDelegate <NSObject>

- (void)onTapHeadIconWithSessionId:(NSString *)sessionId;

- (void)onRetryMessage:(NIMMessage *)message;

- (void)onDeleteMessage;

- (void)onRevokeMessage;

- (void)onTapTextMessage;

- (void)onTapImageMessageWithView:(WTBubbleImageView *)bubbleImage;

- (void)onTapAudioMessage;

- (void)onTapVideoMessage;

- (void)onTapGoodsMessage;

- (void)onTapOrderMessage;

@end

@interface WTCommonMessageCellView : UIView

@property (nonatomic, weak) id<WTCommonMessageCellViewDelegate> delegate;

@property (nonatomic, strong) WTMessageModel *messageModel;

/**
 重新下载或发送
 */
- (void)onRetryMessage:(NIMMessage *)message;

/**
 父类刷新方法
 */
- (void)refreshCellViewWithMessageModel:(WTMessageModel *)messageModel;

@end
