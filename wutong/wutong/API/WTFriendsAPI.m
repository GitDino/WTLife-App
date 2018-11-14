//
//  WTFriendsAPI.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/6.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTFriendsAPI.h"

@implementation WTFriendsAPI

+ (void)addFriendWithUid:(NSString *)uid phone:(NSString *)tel friendsBlock:(friendsBlock)friendsBlock
{
    if (![[NIMSDK sharedSDK].userManager isMyFriend:tel])
    {
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"uid"] = [[[WTAccountManager sharedManager] currentUser] uid];
        paraments[@"toUid"] = uid;
        [WTHttpSession DataPOST:[BASE_URL stringByAppendingString:@"/friend/insert"] requestHeader:[[WTAccountManager sharedManager] token] paraments:paraments completeBlock:^(NSDictionary *object, NSError *error) {
            if (!error)
            {
                friendsBlock(uid, 1, nil);
            }
            else
            {
                friendsBlock(nil, 2, error);
            }
        }];
    }
    else
    {
        friendsBlock(uid, 0, nil);
    }
}

+ (void)addAliasPhone:(NSString *)tel toUid:(NSString *)toUid resultBlock:(resultBlock)resultBlock
{
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"uid"] = [[[WTAccountManager sharedManager] currentUser] uid];
    paraments[@"toUid"] = toUid;
    paraments[@"tel"] = tel;
    [WTHttpSession DataPOST:[BASE_URL stringByAppendingString:@"/friend/addRemarks"] requestHeader:[[WTAccountManager sharedManager] token] paraments:paraments completeBlock:^(NSDictionary *object, NSError *error) {
        if (!error)
        {
            resultBlock(object);
        }
        else
        {
            NSLog(@"-----添加备注电话接口%@", error);
        }
    }];
}

@end
