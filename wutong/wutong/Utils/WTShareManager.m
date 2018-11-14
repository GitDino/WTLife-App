//
//  WTShareManager.m
//  wutong
//
//  Created by 魏欣宇 on 2018/7/31.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTShareManager.h"
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>

@implementation WTShareManager

+ (void)wtShareWithTitle:(NSString *)title description:(NSString *)description thuImage:(NSString *)imageStr webURL:(NSString *)webURL completion:(void(^)(id result, NSError *error)) completion
{
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformType:UMSocialPlatformType_Sina];
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformType:UMSocialPlatformType_Tim];
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformType:UMSocialPlatformType_WechatFavorite];
//    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformType:UMSocialPlatformType_Qzone];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareMiniProgramObject *miniProgramShareObject;
        UMShareWebpageObject *shareWebObject;
        switch (platformType) {
            case UMSocialPlatformType_WechatSession:
                miniProgramShareObject = [UMShareMiniProgramObject shareObjectWithTitle:title descr:description thumImage:imageStr];
                miniProgramShareObject.webpageUrl = [webURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                miniProgramShareObject.userName = @"gh_8e69f5789bf5";
                miniProgramShareObject.path = [NSString stringWithFormat:@"/pages/goodsDetail/goodsDetail?goodId=%@&uid=%@&gid=%@&gname=%@", [[[NSString getParamsWithUrlString:webURL] objectAtIndex:1] objectForKey:@"id"], [[[WTAccountManager sharedManager] currentUser] uid], [[[NSString getParamsWithUrlString:webURL] objectAtIndex:1] objectForKey:@"adviserId"], [[[NSString getParamsWithUrlString:webURL] objectAtIndex:1] objectForKey:@"adviserName"]];
                miniProgramShareObject.miniProgramType = UShareWXMiniProgramTypeRelease;
                messageObject.shareObject = miniProgramShareObject;
                break;
                
            default:
                shareWebObject = [UMShareWebpageObject shareObjectWithTitle:title descr:description thumImage:imageStr];
                shareWebObject.webpageUrl = [webURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                messageObject.shareObject = shareWebObject;
                break;
        }
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
            if (completion)
            {
                completion(result, error);
            }
        }];
    }];
}

@end
