//
//  WTAccountAPI.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTAccountAPI.h"

@implementation WTAccountAPI

+ (void)obtainAccountInfoWithId:(NSString *)uid resultBlock:(resultBlock)resultBlock
{
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"uid"] = uid;
    [WTHttpSession JsonPOST:[BASE_URL stringByAppendingString:@"/users/view"] requestHeader:[[WTAccountManager sharedManager] token] paraments:paraments completeBlock:^(NSDictionary *object, NSError *error) {
        if (!error)
        {
            resultBlock(object);
        }
        else
        {
            NSLog(@"-----获取用户信息接口%@", error);
        }
    }];
}

+ (void)obtainUserInfoWithId:(NSString *)uid resultBlock:(resultBlock)resultBlock
{
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"uid"] = [[[WTAccountManager sharedManager] currentUser] uid];
    paraments[@"toUid"] = uid;
    [WTHttpSession DataPOST:[BASE_URL stringByAppendingString:@"/users/userinfoview"] requestHeader:[[WTAccountManager sharedManager] token] paraments:paraments completeBlock:^(NSDictionary *object, NSError *error) {
        if (!error)
        {
            resultBlock(object);
        }
        else
        {
            NSLog(@"-----获取用户信息接口%@", error);
        }
    }];
}

+ (void)obtainUserPictureWithUid:(NSString *)uid resultBlock:(resultBlock)resultBlock
{
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"assistantId"] = [[[WTAccountManager sharedManager] currentUser] uid];
    paraments[@"uid"] = uid;
    [WTHttpSession JsonPOST:[BASE_URL stringByAppendingString:@"/users/userView"] requestHeader:@"wtlifeeyJhbGciOiJIUzUxMiJ9.eyJ1aWQiOiIxMiIsInR5cGUiOiJ3dGxpZmVfYXBwIn0.H9hGs4CiaLEMBrcDyj-T6nFr9PSZ8tlAkTphMgD3kpzS4Z8Q0A4-gKVKRHdP-PP0trdusx3EyZIvqq0uSFkLhg" paraments:paraments completeBlock:^(NSDictionary *object, NSError *error) {
        if (!error)
        {
            resultBlock(object);
        }
        else
        {
            NSLog(@"-----查看用户画像接口%@", error);
        }
    }];
}

+ (void)obtainUserOrderWithUid:(NSString *)uid resultBlock:(resultBlock)resultBlock
{
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"assistantId"] = [[[WTAccountManager sharedManager] currentUser] uid];
    paraments[@"uid"] = uid;
    [WTHttpSession JsonPOST:[BASE_URL stringByAppendingString:@"/users/userOrders"] requestHeader:@"wtlifeeyJhbGciOiJIUzUxMiJ9.eyJ1aWQiOiIxMiIsInR5cGUiOiJ3dGxpZmVfYXBwIn0.H9hGs4CiaLEMBrcDyj-T6nFr9PSZ8tlAkTphMgD3kpzS4Z8Q0A4-gKVKRHdP-PP0trdusx3EyZIvqq0uSFkLhg" paraments:paraments completeBlock:^(NSDictionary *object, NSError *error) {
        if (!error)
        {
            resultBlock(object);
        }
        else
        {
            NSLog(@"-----查看历史订单接口%@", error);
        }
    }];
}

@end
