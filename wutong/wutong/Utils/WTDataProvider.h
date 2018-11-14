//
//  WTDataProvider.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/11.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WTIMInfo, NIMSession;

@interface WTDataProvider : NSObject

/**
 提供用户信息的接口
 @return 用户信息模型
 */
- (WTIMInfo *)obtainInfoByUser:(NSString *)userId session:(NIMSession *)session;

/**
 上层提供群组信息的接口
 @return 群组信息
 */
- (WTIMInfo *)obtainInfoByTeam:(NSString *)teamId;

@end
