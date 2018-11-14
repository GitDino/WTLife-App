//
//  WTChatOrderModel.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/27.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTChatOrderModel.h"

@implementation WTChatOrderModel

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           @"WTMessageType" : @(104),
                           @"data" : @{
                                   @"orderNo" : self.orderNo,
                                   @"orderState" : @(self.orderState),
                                   @"orderTime" : @(self.orderTime),
                                   @"orderPrice" : @(self.orderPrice),
                                   @"orderId" : self.orderId,
                                   @"goodsImg" : self.goodsImg,
                                   @"goodsName" : self.goodsName,
                                   @"goodsPrice" : @(self.goodsPrice)
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
