//
//  WTChatGoodsModel.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/27.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTChatGoodsModel.h"

@implementation WTChatGoodsModel

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           @"WTMessageType" : @(103),
                           @"data" : @{
                                   @"goodImg" : self.goodImg,
                                   @"goodName" : self.goodName,
                                   @"goodPrice" : @(self.goodPrice),
                                   @"goodId" : self.goodId,
                                   @"shopId" : self.shopId,
                                   @"shopName" : self.shopName
                                   }
                           };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:0
                                                     error:nil];
    NSString *content = nil;
    if (data)
    {
        content = [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding];
    }
    return content;
}

@end
