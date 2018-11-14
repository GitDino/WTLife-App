//
//  WTTagAPI.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTTagAPI.h"

@implementation WTTagAPI

+ (void)addCustomTagName:(NSString *)tags withUid:(NSString *)uid resultBlock:(resultBlock)resultBlock
{
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"assistantId"] = [[[WTAccountManager sharedManager] currentUser] uid];
    paraments[@"uid"] = uid;
    paraments[@"tags"] = tags;
    [WTHttpSession JsonPOST:[BASE_URL stringByAppendingString:@"/users/insertTags"] requestHeader:[[WTAccountManager sharedManager] token] paraments:paraments completeBlock:^(NSDictionary *object, NSError *error) {
        if (!error)
        {
            resultBlock(object);
        }
        else
        {
            NSLog(@"-----添加自定义标签接口%@", error);
        }
    }];
}

@end
