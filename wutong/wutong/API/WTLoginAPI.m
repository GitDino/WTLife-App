//
//  WTLoginAPI.m
//  wutong
//
//  Created by 魏欣宇 on 2018/7/30.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTLoginAPI.h"

@implementation WTLoginAPI

+ (void)obtainVerifyCodeWithPhone:(NSString *)phone resultBlock:(resultBlock)resultBlock
{
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"tel"] = phone;
    [WTHttpSession JsonPOST:[BASE_URL stringByAppendingString:@"/users/createCode"] requestHeader:nil paraments:paraments completeBlock:^(NSDictionary *object, NSError *error) {
        if (!error)
        {
            resultBlock(object);
        }
        else
        {
            NSLog(@"-----获取验证码接口%@", error);
        }
    }];
}


+ (void)loginAppWithPhone:(NSString *)phone code:(NSString *)code resultBlock:(resultBlock)resultBlock
{
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"tel"] = phone;
    paraments[@"verifycode"] = code;
    [WTHttpSession JsonPOST:[BASE_URL stringByAppendingString:@"/users/loginRegister"] requestHeader:nil paraments:paraments completeBlock:^(NSDictionary *object, NSError *error) {
        if (!error)
        {
            resultBlock(object);
        }
        else
        {
            NSLog(@"-----登录接口%@", error);
        }
    }];
}

+ (void)uploadLoactionWithLatitude:(NSString *)latitude longitude:(NSString *)longitude resultBlock:(resultBlock)resultBlock
{
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"latitude"] = latitude;
    paraments[@"longitude"] = longitude;
    [WTHttpSession DataPOST:[BASE_URL stringByAppendingString:@"/shop/getNearlyShop"] requestHeader:nil paraments:paraments completeBlock:^(NSDictionary *object, NSError *error) {
        if (!error)
        {
            resultBlock(object);
        }
        else
        {
            NSLog(@"-----上传经纬度接口%@", error);
        }
    }];
}

@end
