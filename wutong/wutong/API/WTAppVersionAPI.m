//
//  WTAppVersionAPI.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTAppVersionAPI.h"

@implementation WTAppVersionAPI

+ (void)obtainCurrentVersionWithResultBlock:(resultBlock)resultBlock
{
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"clientType"] = @(2);
    [WTHttpSession DataPOST:[BASE_URL stringByAppendingString:@"/appVersion/newestversion"] requestHeader:[[WTAccountManager sharedManager] token] paraments:paraments completeBlock:^(NSDictionary *object, NSError *error) {
        if (!error)
        {
            resultBlock(object);
        }
        else
        {
            NSLog(@"-----获取当前服务器版本接口%@", error);
        }
    }];
}

@end
