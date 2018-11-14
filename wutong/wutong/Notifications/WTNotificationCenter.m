//
//  WTNotificationCenter.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTNotificationCenter.h"

NSNotificationName const WTForegroundNotification = @"WTForegroundNotification";
NSNotificationName const UMBackgroundNotification = @"UMBackgroundNotification";
NSNotificationName const URLSchemesNotification = @"URLSchemesNotification";

NSNotificationName const CleanLocalDataNotification = @"CleanLocalDataNotification";
NSNotificationName const BackButtonNotification = @"BackButtonNotification";

NSNotificationName const TokenInvalidNotification = @"TokenInvalidNotification";
NSNotificationName const LogOutNotification = @"LogOutNotification";
NSNotificationName const HideSessionNotification = @"HideSessionNotification";
NSNotificationName const ShareGoodsInfoNotification = @"ShareGoodsInfoNotification";
NSNotificationName const GetCameraNotification = @"GetCameraNotification";
NSNotificationName const PayNotification = @"PayNotification";
NSNotificationName const CompletePaymentNotification = @"CompletePaymentNotification";
NSNotificationName const UploadImgNotification = @"UploadImgNotification";

NSNotificationName const SendGoodNotification = @"SendGoodNotification";
NSNotificationName const SendOrderNotification = @"SendOrderNotification";
NSNotificationName const ContactAdviserNotification = @"ContactAdviserNotification";
NSNotificationName const ContactBuyerNotification = @"ContactBuyerNotification";
NSNotificationName const LatestFeedbackNotification = @"LatestFeedbackNotification";
NSNotificationName const UploadAvatorNotification = @"UploadAvatorNotification";

@implementation WTNotificationCenter

+ (instancetype)defaultCenter
{
    static WTNotificationCenter *center = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[WTNotificationCenter alloc] init];
    });
    return center;
}

- (void)wtPostNotificationName:(NSString *)name object:(id)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
}

- (void)wtAddObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:aName object:anObject];
}

- (void)wtRemoveObserver:(id)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

@end
