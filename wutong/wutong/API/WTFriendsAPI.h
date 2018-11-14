//
//  WTFriendsAPI.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/6.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^friendsBlock)(NSString *imAccount, NSInteger isFirst, NSError * _Nullable error);

typedef void(^resultBlock)(NSDictionary *object);

@interface WTFriendsAPI : NSObject

/**
 添加好友

 @param uid 用户ID
 @param tel 用户电话
 @param friendsBlock 结果回掉
 */
+ (void)addFriendWithUid:(NSString *)uid phone:(NSString *)tel friendsBlock:(friendsBlock)friendsBlock;

/**
 添加备注电话

 @param tel 电话
 @param toUid 被添加人的用户ID
 @param resultBlock 结果回掉
 */
+ (void)addAliasPhone:(NSString *)tel toUid:(NSString *)toUid resultBlock:(resultBlock)resultBlock;

@end
