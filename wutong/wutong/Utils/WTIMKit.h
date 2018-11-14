//
//  WTIMKit.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/11.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTIMInfo.h"
@class NIMSession;

@interface WTIMKit : NSObject

+ (instancetype)sharedKit;

/**
 用户信息变更通知接口

 @param userIds 用户ID集合
 */
- (void)notfiyUserInfoChanged:(NSArray *)userIds;

/**
 群信息变更通知接口

 @param teamIds 群ID集合
 */
- (void)notifyTeamInfoChanged:(NSArray *)teamIds;

/**
 群成员变更通知

 @param teamIds 群ID
 */
- (void)notifyTeamMemebersChanged:(NSArray *)teamIds;

/**
 返回用户信息接口
 */
- (WTIMInfo *)infoByUser:(NSString *)userID session:(NIMSession *)session;

/**
 返回群消息
 */
- (WTIMInfo *)infoByTeam:(NSString *)userID;

@end
