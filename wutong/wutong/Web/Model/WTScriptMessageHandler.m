//
//  WTScriptMessageHandler.m
//  wutong
//
//  Created by 魏欣宇 on 2018/7/30.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTScriptMessageHandler.h"
#import "WTShareGoodsModel.h"
#import "WTShareManager.h"
#import "WTPayModel.h"
#import "WTChatGoodsModel.h"
#import "WTChatOrderModel.h"
#import "WTContactAccountModel.h"

NSString *HideSession = @"HideSession";
NSString *ScanCode = @"ScanCode";
NSString *jsUploadImage = @"jsUploadImage";

@implementation WTScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    [self dealWithMessage:message];
}

- (void)dealWithMessage:(WKScriptMessage *)message
{
    NSDictionary *dict = [NSDictionary dictWithJsonStr:message.body];
    NSString *action = dict[@"action"];
    if ([action isEqualToString:@"tokenInvalid"])
    {
        [[WTNotificationCenter defaultCenter] wtPostNotificationName:TokenInvalidNotification object:nil];
    }
    else if ([action isEqualToString:@"loginOut"])
    {
        [[WTNotificationCenter defaultCenter] wtPostNotificationName:LogOutNotification object:nil];
    }
    else if ([action isEqualToString:@"otherButton"])
    {
        [[WTNotificationCenter defaultCenter] wtPostNotificationName:HideSessionNotification object:@(YES)];
    }
    else if ([action isEqualToString:@"sendMessage"])
    {
        [[WTNotificationCenter defaultCenter] wtPostNotificationName:HideSessionNotification object:@(NO)];
    }
    else if ([action isEqualToString:@"shareGoodsInfo"])
    {
        WTShareGoodsModel *goodsModel = [WTShareGoodsModel mj_objectWithKeyValues:dict[@"data"]];
        [[WTNotificationCenter defaultCenter] wtPostNotificationName:ShareGoodsInfoNotification object:goodsModel];
    }
    else if ([action isEqualToString:@"getCamera"])
    {
        [[WTNotificationCenter defaultCenter] wtPostNotificationName:GetCameraNotification object:nil];
    }
    else if ([action isEqualToString:@"pay"])
    {
        WTPayModel *payModel = [WTPayModel mj_objectWithKeyValues:dict[@"data"]];
        [[WTNotificationCenter defaultCenter] wtPostNotificationName:PayNotification object:payModel];
    }
    else if ([action isEqualToString:@"uploadImg"])
    {
        [[WTNotificationCenter defaultCenter] wtPostNotificationName:UploadImgNotification object:nil];
    }
    else if ([action isEqualToString:@"sendGood"])
    {
        WTChatGoodsModel *goodsModel = [WTChatGoodsModel mj_objectWithKeyValues:dict[@"data"]];
        [[WTNotificationCenter defaultCenter] wtPostNotificationName:SendGoodNotification object:goodsModel];
    }
    else if ([action isEqualToString:@"sendOrder"])
    {
        WTChatOrderModel *orderModel = [WTChatOrderModel mj_objectWithKeyValues:dict[@"data"]];
        [[WTNotificationCenter defaultCenter] wtPostNotificationName:SendOrderNotification object:orderModel];
    }
    else if ([action isEqualToString:@"contactAdviser"])
    {
        WTContactAccountModel *contactAccountModel = [WTContactAccountModel mj_objectWithKeyValues:dict[@"data"]];
        [[WTNotificationCenter defaultCenter] wtPostNotificationName:ContactAdviserNotification object:contactAccountModel];
    }
    else if ([action isEqualToString:@"contactBuyer"])
    {
        WTContactAccountModel *contactAccountModel = [WTContactAccountModel mj_objectWithKeyValues:dict[@"data"]];
        [[WTNotificationCenter defaultCenter] wtPostNotificationName:ContactBuyerNotification object:contactAccountModel];
    }
    else if ([action isEqualToString:@"latestFeedback"])
    {
        NSString *tel = dict[@"data"][@"tel"];
        [[WTNotificationCenter defaultCenter] wtPostNotificationName:LatestFeedbackNotification object:tel];
    }
    else if ([action isEqualToString:@"backButton"])
    {
        [[WTNotificationCenter defaultCenter] wtPostNotificationName:BackButtonNotification object:nil];
    }
    else if ([action isEqualToString:@"uploadAvator"])
    {
        [[WTNotificationCenter defaultCenter] wtPostNotificationName:UploadAvatorNotification object:nil];
    }
    else
    {
        NSLog(@"%@", message.body);
    }
}

@end
