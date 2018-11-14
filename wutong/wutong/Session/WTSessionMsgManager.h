//
//  WTSessionMsgManager.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTSessionMsgManager : NSObject

@property (nonatomic, strong) NSMutableArray *items;

- (instancetype)initWithSession:(NIMSession *) session;

- (void)resetMessages:(void(^)(NSUInteger count)) handler;

- (void)addNewMessages:(NSArray *)messages;

- (void)deleteMessage:(NIMMessage *)message;

- (void)updateMessage:(NIMMessage *)message;

- (void)insertTipMessages:(NSArray *)messages;

- (void)loadHistoryMessagesWithComplete:(void(^)(NSUInteger count)) handler;

@end
