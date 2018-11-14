//
//  WTSessionUtil.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/6/28.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTSessionUtil : NSObject

/**
 配置Tip信息
 */
+ (NIMMessage *)configTipMessage:(NSString *)tip;

+ (NSString *)showTime:(NSTimeInterval)lastTime detail:(BOOL)showDetail;

+ (NSString *)showNick:(NSString *)uid inSession:(NIMSession *)session;

+ (NSString *)messageContent:(NIMMessage *)lastMessage;

+ (NSString *)tipOnMessageRevoked:(NIMRevokeMessageNotification *)notificaton;

+ (NSString *)matchOrderState:(NSInteger)orderState;

+ (CGSize)contentSizeWithMessage:(NIMMessage *)message;

+ (CGSize)matchAudioDuration:(NIMMessage *)message;

@end
