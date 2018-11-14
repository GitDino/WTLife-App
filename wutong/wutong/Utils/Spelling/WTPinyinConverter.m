//
//  WTPinyinConverter.m
//  wutong
//
//  Created by 魏欣宇 on 2018/9/19.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTPinyinConverter.h"

@implementation WTPinyinConverter

+ (WTPinyinConverter *)sharedInstance
{
    static WTPinyinConverter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WTPinyinConverter alloc] init];
    });
    return instance;
}

- (NSString *)toPinyin:(NSString *)source
{
    if ([source length] == 0)
    {
        return nil;
    }
    NSMutableString *pinyin = [NSMutableString stringWithString:source];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformToLatin, false);
    NSString *py = [pinyin stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [py stringByReplacingOccurrencesOfString:@"'" withString:@""];
}

@end
