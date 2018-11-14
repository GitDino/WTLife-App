//
//  WTAccountAPI.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^resultBlock)(NSDictionary *object);

@interface WTAccountAPI : NSObject

/**
 根据uid获取账户信息

 @param uid 用户ID
 @param resultBlock 结果回掉
 */
+ (void)obtainAccountInfoWithId:(NSString *)uid resultBlock:(resultBlock)resultBlock;

/**
 根据uid获取账户信息

 @param uid 目标用户ID
 @param resultBlock 结果回掉
 */
+ (void)obtainUserInfoWithId:(NSString *)uid resultBlock:(resultBlock)resultBlock;

/**
 查看用户画像

 @param uid 目标用户ID
 @param resultBlock 结果回掉
 */
+ (void)obtainUserPictureWithUid:(NSString *)uid resultBlock:(resultBlock)resultBlock;

/**
 查看历史订单
 
 @param uid 目标用户ID
 @param resultBlock 结果回掉
 */
+ (void)obtainUserOrderWithUid:(NSString *)uid resultBlock:(resultBlock)resultBlock;

@end
