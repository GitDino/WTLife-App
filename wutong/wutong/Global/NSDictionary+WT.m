//
//  NSDictionary+WT.m
//  wutong
//
//  Created by 魏欣宇 on 2018/7/31.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "NSDictionary+WT.h"

@implementation NSDictionary (WT)

+ (NSDictionary *)dictWithJsonStr:(NSString *)jsonStr
{
    if (![NSString isBlankString:jsonStr])
    {
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        if (jsonObject != nil && error == nil)
        {
            return jsonObject;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
    return  [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
}

- (NSInteger)jsonInteger:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object integerValue];
    }
    return 0;
}

- (NSDictionary *)jsonDict:(NSString *)key
{
    id object = [self objectForKey:key];
    return [object isKindOfClass:[NSDictionary class]] ? object : nil;
}

- (NSString *)jsonString:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]])
    {
        return object;
    }
    else if([object isKindOfClass:[NSNumber class]])
    {
        return [object stringValue];
    }
    return nil;
}

@end
