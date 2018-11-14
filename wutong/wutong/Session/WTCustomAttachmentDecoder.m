//
//  WTCustomAttachmentDecoder.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/8.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTCustomAttachmentDecoder.h"
#import "WTChartletModel.h"
#import "WTChatGoodsModel.h"
#import "WTChatOrderModel.h"

@implementation WTCustomAttachmentDecoder

- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content
{
    id<NIMCustomAttachment> attachment = nil;
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            NSInteger customeType = [dict jsonInteger:WTType];
            NSDictionary *result = [dict jsonDict:WTData];
            switch (customeType) {
                case WTCustomMessageTypeChartlet:   //超级表情
                {
                    attachment = [[WTChartletModel alloc] init];
                    ((WTChartletModel *)attachment).chartletCatalog = [result jsonString:WTCatalog];
                    ((WTChartletModel *)attachment).chartletID = [result jsonString:WTChartlet];
                    attachment = [self checkAttachment:attachment] ? attachment : nil;
                }
                    break;
                case WTCustomMessageTypeGoods:      //发送商品
                {
                    attachment = [[WTChatGoodsModel alloc] init];
                    ((WTChatGoodsModel *)attachment).goodImg = [result jsonString:@"goodImg"];
                    ((WTChatGoodsModel *)attachment).goodName = [result jsonString:@"goodName"];
                    ((WTChatGoodsModel *)attachment).goodPrice = [[result jsonString:@"goodPrice"] floatValue];
                    ((WTChatGoodsModel *)attachment).goodId = [result jsonString:@"goodId"];
                    ((WTChatGoodsModel *)attachment).shopId = [result jsonString:@"shopId"];
                    ((WTChatGoodsModel *)attachment).shopName = [result jsonString:@"shopName"];
                }
                    break;
                case WTCustomMessageTypeOrder:      //发送订单
                {
                    attachment = [[WTChatOrderModel alloc] init];
                    ((WTChatOrderModel *)attachment).orderNo = [result jsonString:@"orderNo"];
                    ((WTChatOrderModel *)attachment).orderState = [[result jsonString:@"orderState"] integerValue];
                    ((WTChatOrderModel *)attachment).orderTime = [[result jsonString:@"orderTime"] integerValue];
                    ((WTChatOrderModel *)attachment).orderPrice = [[result jsonString:@"orderPrice"] integerValue];
                    ((WTChatOrderModel *)attachment).orderId = [result jsonString:@"orderId"];
                    ((WTChatOrderModel *)attachment).goodsImg = [result jsonString:@"goodsImg"];
                    ((WTChatOrderModel *)attachment).goodsName = [result jsonString:@"goodsName"];
                    ((WTChatOrderModel *)attachment).goodsPrice = [[result jsonString:@"goodsPrice"] floatValue];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    return attachment;
}

- (BOOL)checkAttachment:(id<NIMCustomAttachment>) attachment
{
    BOOL check = NO;
    if ([attachment isKindOfClass:[WTChartletModel class]])
    {
        NSString *chartletCatalog = ((WTChartletModel *)attachment).chartletCatalog;
        NSString *chartletId =((WTChartletModel *)attachment).chartletID;
        check = chartletCatalog.length && chartletId.length ? YES : NO;
    }
    return check;
}

@end
