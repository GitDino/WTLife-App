//
//  WTNotificationCenter.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTNotificationCenter : NSObject

+ (instancetype)defaultCenter;

- (void)wtPostNotificationName:(NSString *)name object:(id)object;

- (void)wtAddObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject;

- (void)wtRemoveObserver:(id)observer;

@end

//即将进入前台
UIKIT_EXTERN NSNotificationName const WTForegroundNotification;
//收到友盟后台通知
UIKIT_EXTERN NSNotificationName const UMBackgroundNotification;
//Scheme跳转
UIKIT_EXTERN NSNotificationName const URLSchemesNotification;

//清除本地相关数据
UIKIT_EXTERN NSNotificationName const CleanLocalDataNotification;
//返回上级页面
UIKIT_EXTERN NSNotificationName const BackButtonNotification;

//Token失效CleanLocalDataNotification
UIKIT_EXTERN NSNotificationName const TokenInvalidNotification;
//退出登录
UIKIT_EXTERN NSNotificationName const LogOutNotification;
//聊天会话
UIKIT_EXTERN NSNotificationName const HideSessionNotification;
//分享商品
UIKIT_EXTERN NSNotificationName const ShareGoodsInfoNotification;
//扫码
UIKIT_EXTERN NSNotificationName const GetCameraNotification;
//支付
UIKIT_EXTERN NSNotificationName const PayNotification;
//完成支付
UIKIT_EXTERN NSNotificationName const CompletePaymentNotification;
//待发货上传图片
UIKIT_EXTERN NSNotificationName const UploadImgNotification;
//发送商品
UIKIT_EXTERN NSNotificationName const SendGoodNotification;
//发送商品
UIKIT_EXTERN NSNotificationName const SendOrderNotification;
//联系顾问
UIKIT_EXTERN NSNotificationName const ContactAdviserNotification;
//联系买家
UIKIT_EXTERN NSNotificationName const ContactBuyerNotification;
//最新反馈
UIKIT_EXTERN NSNotificationName const LatestFeedbackNotification;
//上传头像
UIKIT_EXTERN NSNotificationName const UploadAvatorNotification;
