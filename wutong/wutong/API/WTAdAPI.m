//
//  WTAdAPI.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/6.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTAdAPI.h"

@implementation WTAdAPI

+ (void)obtainAdDataWithResultBlock:(resultBlock)resultBlock
{
    [WTHttpSession JsonPOST:[BASE_URL stringByAppendingString:@"/adBanner/view"] requestHeader:nil paraments:nil completeBlock:^(NSDictionary *object, NSError *error) {
        if (!error)
        {
            resultBlock(object);
        }
        else
        {
            NSLog(@"-----获取广告页数据接口%@", error);
        }
    }];
}

@end
