//
//  WTChatTableViewProtcol.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/5.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NIMMessage, WTBubbleImageView;

@protocol WTChatTableViewProtcol <NSObject>

- (void)didScrollOffetY:(CGFloat)y;

- (void)onTapHeadIconWithSessionId:(NSString *)sessionId;

- (void)onTapResignFirstResponder;

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
