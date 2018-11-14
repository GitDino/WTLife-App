//
//  WTAccountManager.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTUser : NSObject

/**
 手机号
 */
@property (nonatomic, copy) NSString *tel;

/**
 网易Token
 */
@property (nonatomic, copy) NSString *wytoken;

/**
 用户ID
 */
@property (nonatomic, copy) NSString *uid;

/**
 店铺ID
 */
@property (nonatomic, assign) NSInteger shopId;

/**
 店铺名
 */
@property (nonatomic, copy) NSString *shopName;

/**
 店铺ID
 */
@property (nonatomic, assign) NSInteger lastShopId;

/**
 店铺名
 */
@property (nonatomic, copy) NSString *lastShopName;

/**
 角色类型
 1 : 顾问
 2 : 普通用户
 3 : 后台管理员
 */
@property (nonatomic, assign) NSInteger userType;

/**
 账号状态
 0 : 废弃
 1 : 可用
 */
@property (nonatomic, assign) NSInteger status;

@end

@interface WTAccountManager : NSObject

@property (nonatomic, strong) WTUser *currentUser;

@property (nonatomic, copy) NSString *token;

+ (instancetype)sharedManager;

@end
