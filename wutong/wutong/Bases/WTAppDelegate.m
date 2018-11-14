//
//  WTAppDelegate.m
//  wutong
//
//  Created by 魏欣宇 on 2018/7/29.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTAppDelegate.h"
#import "WTLoginVC.h"
#import "WTWebViewVC.h"
#import "WTCustomAttachmentDecoder.h"
#import "WTNotificationCenter.h"
#import "WTAppVersionAPI.h"
#import <AlipaySDK/AlipaySDK.h>
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import <UMPush/UMessage.h>
#import <UserNotifications/UserNotifications.h>
#import <NIMSDK/NIMSDK.h>
#import <Bugly/Bugly.h>
#import "TalkingData.h"
#import "WTGuidePageVC.h"
#import "WXApiObject.h"
#import "WXApi.h"

#define First_Open  @"First_Open"

@interface WTAppDelegate () <NIMLoginManagerDelegate, UNUserNotificationCenterDelegate, WXApiDelegate>

@end

@implementation WTAppDelegate

- (void)dealloc
{
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
    [[WTNotificationCenter defaultCenter] wtRemoveObserver:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //Bug追踪
    [Bugly startWithAppId:@"d3a41b880b"];
    
    //TalkingData统计
    [TalkingData sessionStarted:@"54C627DB7E79478EBAD213E12E3B9D23" withChannelId:@"app store"];
    
    [self registerAPNS];
    
    [self configNIMSDK];
    [self configUMSocialWithOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    [self configRootViewController];
    [self obtainCurrentVersion];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[WTNotificationCenter defaultCenter] wtPostNotificationName:WTForegroundNotification object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSInteger count = [[[NIMSDK sharedSDK] conversationManager] allUnreadCount];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //网易云信注册DeviceToken
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
    //友盟注册DeviceToken
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册deviceToken失败: %@", error);
}

/**
 支付跳转支付宝钱包进行支付，处理支付结果
 */
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    if (!result)
    {
        if ([url.host isEqualToString:@"safepay"])
        {
            //支付结果回掉处理
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                NSInteger status = [resultDic[@"resultStatus"] integerValue];
                switch (status) {
                    case 9000: //支付成功
                        [[WTNotificationCenter defaultCenter] wtPostNotificationName:CompletePaymentNotification object:@(1)];
                        break;
                    case 8000:
                    case 6004:
                        break;
                        
                    default:
                        [[WTNotificationCenter defaultCenter] wtPostNotificationName:CompletePaymentNotification object:@(0)];
                        break;
                }
                
            }];
        }
        else if ([url.scheme isEqualToString:@"wutong"])
        {
            NSLog(@"%@", [url query]);
            NSString *webURL = [url query];
            webURL = [webURL substringWithRange:NSMakeRange(10, webURL.length - 13)];
            [[WTNotificationCenter defaultCenter] wtPostNotificationName:URLSchemesNotification object:webURL];
        }
        else
        {
            [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10)
    {
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - UNUserNotificationCenterDelegate代理方法

/**
 iOS10 处理前台收到通知的代理方法
 */
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"%@", userInfo);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    else
    {
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert);
}

/**
 iOS10 处理后台点击通知的代理方法
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSLog(@"%@", userInfo);
    if (@available(iOS 10.0, *))
    {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
        {
            [UMessage didReceiveRemoteNotification:userInfo];
        }
    }
    
    if ([userInfo[@"alias_type"] isEqualToString:@"user"])
    {
        [[WTNotificationCenter defaultCenter] wtPostNotificationName:UMBackgroundNotification object:nil];
    }
}


#pragma mark - Custom Cycle
/**
 初始化根控制器
 */
- (void)configRootViewController
{
    WTUser *currentUser = [[WTAccountManager sharedManager] currentUser];
    if (currentUser.tel.length && currentUser.wytoken.length)
    {
        NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
        loginData.account = currentUser.tel;
        loginData.token = currentUser.wytoken;
        
        [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
    }
    
    if ([self isFirstOpen])
    {
        WTGuidePageVC *guideVC = [[WTGuidePageVC alloc] init];
        self.window.rootViewController = guideVC;
    }
    else
    {
        WTWebViewVC *webVC = [[WTWebViewVC alloc] init];
        self.window.rootViewController = webVC;
    }
}

- (BOOL)isFirstOpen
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:First_Open])
    {
        return NO;
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:First_Open];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
}

- (void)registerAPNS
{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

/**
 初始化友盟
 */
- (void)configUMSocialWithOptions:(NSDictionary *)launchOptions
{
    [UMConfigure initWithAppkey:@"5b516a928f4a9d5f7f0001b0" channel:@"App Store"];
    [WXApi registerApp:@"wx1394aa93a5c8de6b"];
    [UMConfigure setLogEnabled:YES];
    
    if (@available(iOS 10.0, *))
    {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
    
    //推送配置
    UMessageRegisterEntity *entity = [[UMessageRegisterEntity alloc] init];
    entity.types = UMessageAuthorizationOptionBadge | UMessageAuthorizationOptionAlert | UMessageAuthorizationOptionSound;
    if (@available(iOS 10.0, *))
    {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
    
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted)
        {
            NSLog(@"用户选择了接收push消息");
        }
        else
        {
            NSLog(@"用户拒绝接收push消息");
        }
    }];
    
    
    //分享平台设置
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx1394aa93a5c8de6b" appSecret:@"0da78fa9c99734b29db7b0f3727e46e0" redirectURL:@"https://www.wutonglife.com"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1107466720" appSecret:nil redirectURL:@"https://www.wutonglife.com"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2952578766" appSecret:@"19f0328e9b5189526f2444c521219d23" redirectURL:@"http://open.weibo.com/apps/2952578766/privilege/oauth"];
}

/**
 初始化网易云信
 */
- (void)configNIMSDK
{
    NIMSDKOption *option = [NIMSDKOption optionWithAppKey:NIM_AppKey];
    #ifdef DEBUG
    option.apnsCername = @"WTTestPush";
    #else
    option.apnsCername = @"WTReleasePush";
    #endif
    [[NIMSDK sharedSDK] registerWithOption:option];
    
    //注册自定义消息解析器
    [NIMCustomObject registerCustomDecoder:[WTCustomAttachmentDecoder new]];
    
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
}

/**
 版本更新
 */
- (void)obtainCurrentVersion
{
    [WTAppVersionAPI obtainCurrentVersionWithResultBlock:^(NSDictionary *object) {
        NSLog(@"%@", object);
        if ([object[@"code"] integerValue] == 200)
        {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            CFShow((__bridge CFTypeRef)(infoDictionary));
            // app版本
//            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            // app Build版本
            NSString *app_Build = [infoDictionary objectForKey:@"CFBundleVersion"];
            if ([object[@"data"][@"code"] integerValue] > [app_Build integerValue])
            {
                NSLog(@"提示更新");
                WTAlertManager *alertManager = [[WTAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:@"发现新版本" message:nil];
                if ([object[@"data"][@"isForced"] integerValue] == 0)
                {
                    [alertManager cancelActionWithTitle:@"取消" destructiveIndex:-2 otherTitle:@"确定", nil];
                }
                else
                {
                    [alertManager cancelActionWithTitle:nil destructiveIndex:-2 otherTitle:@"确定", nil];
                }
                [alertManager showAlertFromController:self.window.rootViewController actionBlock:^(NSInteger actionIndex) {
                    switch (actionIndex) {
                        case 0:
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:object[@"data"][@"url"]]];
                            break;
                            
                        default:
                            break;
                    }
                }];
            }
        }
    }];
}


#pragma mark - NIMLoginManagerDelegate代理方法
- (void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
    NSString *reason = @"你被踢下线";
    switch (code) {
        case NIMKickReasonByClient:
        case NIMKickReasonByClientManually:
        {
            NSString *clientName;
            switch (clientType) {
                case NIMLoginClientTypeAOS:
                    clientName = @"安卓手机";
                    break;
                case NIMLoginClientTypeiOS:
                    clientName = @"苹果手机";
                    break;
                default:
                    break;
                    
            }
            reason = clientName.length ? [NSString stringWithFormat:@"你的帐号被%@端踢出下线，请注意帐号信息安全",clientName] : @"你的帐号被踢出下线，请注意帐号信息安全";
            break;
        }
        case NIMKickReasonByServer:
            reason = @"你被服务器踢下线";
            break;
        default:
            break;
    }
    
    WTAlertManager *alertManager = [[WTAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:nil message:reason];
    [alertManager cancelActionWithTitle:nil destructiveIndex:-2 otherTitle:@"确定", nil];
    [alertManager showAlertFromController:self.window.rootViewController actionBlock:^(NSInteger actionIndex) {
        switch (actionIndex) {
            case 0:
            {
                [[WTNotificationCenter defaultCenter] wtPostNotificationName:CleanLocalDataNotification object:nil];
                WTLoginVC *loginVC = [[WTLoginVC alloc] init];
                WTBaseNavigationController *loginNav = [[WTBaseNavigationController alloc] initWithRootViewController:loginVC];
                [self.window.rootViewController presentViewController:loginNav animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
    }];
}

- (void)onAutoLoginFailed:(NSError *)error
{
    NSString *message = [NSString stringWithFormat:@"自动登录失败 %@",error];
    NSString *domain = error.domain;
    NSInteger code = error.code;
    if ([domain isEqualToString:NIMLocalErrorDomain])
    {
        if (code == NIMLocalErrorCodeAutoLoginRetryLimit)
        {
            message = @"自动登录错误次数超限，请检查网络后重试";
        }
    }
    else if([domain isEqualToString:NIMRemoteErrorDomain])
    {
        if (code == NIMRemoteErrorCodeInvalidPass)
        {
            message = @"密码错误";
        }
        else if(code == NIMRemoteErrorCodeExist)
        {
            message = @"当前已经其他设备登录，请使用手动模式登录";
        }
    }
    
    WTAlertManager *alertManager = [[WTAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:@"自动登录失败" message:message];
    [alertManager cancelActionWithTitle:nil destructiveIndex:-2 otherTitle:@"确定", nil];
    [alertManager showAlertFromController:self.window.rootViewController actionBlock:^(NSInteger actionIndex) {
        switch (actionIndex) {
            case 0:
            {
                [[WTNotificationCenter defaultCenter] wtPostNotificationName:CleanLocalDataNotification object:nil];
                WTLoginVC *loginVC = [[WTLoginVC alloc] init];
                WTBaseNavigationController *loginNav = [[WTBaseNavigationController alloc] initWithRootViewController:loginVC];
                [self.window.rootViewController presentViewController:loginNav animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark - WXApiDelegate代理方法
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess://支付成功
                [[WTNotificationCenter defaultCenter] wtPostNotificationName:CompletePaymentNotification object:@(1)];
                break;
                
            default://支付失败
                [[WTNotificationCenter defaultCenter] wtPostNotificationName:CompletePaymentNotification object:@(0)];
                break;
        }
    }
}

@end
