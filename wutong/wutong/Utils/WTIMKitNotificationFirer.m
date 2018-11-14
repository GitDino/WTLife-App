//
//  WTIMKitNotificationFirer.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/23.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTIMKitNotificationFirer.h"

NSString *const WTIMKitUserInfoHasUpdatedNotification      = @"WTIMKitUserInfoHasUpdatedNotification";
NSString *const WTIMKitTeamInfoHasUpdatedNotification      = @"WTIMKitTeamInfoHasUpdatedNotification";
NSString *const WTIMKitTeamMembersHasUpdatedNotification   = @"WTIMKitTeamMembersHasUpdatedNotification";
NSString *const WTIMKitInfoKey                             = @"InfoId";

@implementation WTIMKitNotificationFirer

- (instancetype)init
{
    if (self = [super init])
    {
        _timer = [[WTIMKitTimerHolder alloc] init];
        _timeInterval = 1.0f;
        _cachedInfo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addFireInfo:(WTIMKitFirerInfo *)info
{
    if (!self.cachedInfo.count)
    {
        [self.timer startTimer:self.timeInterval delegate:self repeats:NO];
    }
    [self.cachedInfo setObject:info forKey:info.saveIdentity];
}

#pragma mark - WTIMKitTimerHolderDelegate代理方法
- (void)onTimerFired:(WTIMKitTimerHolder *)holder
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (WTIMKitFirerInfo *info in self.cachedInfo.allValues)
    {
        NSMutableArray *fireInfos = dict[info.notificationName];
        if (!fireInfos)
        {
            fireInfos = [NSMutableArray array];
            dict[info.notificationName] = fireInfos;
        }
        if (info.fireObject)
        {
            [fireInfos addObject:info.fireObject];
        }
    }
    
    for (NSString *notificationName in dict)
    {
        NSDictionary *userInfo = dict[notificationName] ? @{WTIMKitInfoKey : dict[notificationName]} : nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:userInfo];
    }
    
    [self.cachedInfo removeAllObjects];
}

@end

@implementation WTIMKitFirerInfo

- (NSObject *)fireObject
{
    if (self.session)
    {
        return self.session.sessionId;
    }
    return [NSNull null];
}

- (NSString *)saveIdentity
{
    if (self.session)
    {
        return [NSString stringWithFormat:@"%@-%zd", self.session.sessionId, self.session.sessionType];
    }
    return self.notificationName;
}

@end
