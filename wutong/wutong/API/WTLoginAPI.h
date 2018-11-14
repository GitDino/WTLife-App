//
//  WTLoginAPI.h
//  wutong
//
//  Created by 魏欣宇 on 2018/7/30.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^resultBlock)(NSDictionary *object);

@interface WTLoginAPI : NSObject

/**
 通过手机号获取验证码
 
 @param phone 手机号
 @param resultBlock 结果回掉
 */
+ (void)obtainVerifyCodeWithPhone:(NSString *)phone resultBlock:(resultBlock)resultBlock;

/**
 手机号 + 验证码 登录

 @param phone 手机号
 @param code 验证码
 @param resultBlock 结果回掉
 */
+ (void)loginAppWithPhone:(NSString *)phone code:(NSString *)code resultBlock:(resultBlock)resultBlock;

/**
 上传经纬度

 @param latitude 经度
 @param longitude 纬度
 @param resultBlock 结果回掉
 */
+ (void)uploadLoactionWithLatitude:(NSString *)latitude longitude:(NSString *)longitude resultBlock:(resultBlock)resultBlock;

@end
