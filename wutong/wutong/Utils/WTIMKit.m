//
//  WTIMKit.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/11.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTIMKit.h"
#import "WTDataProvider.h"
#import "WTIMKitTimerHolder.h"
#import "WTIMKitNotificationFirer.h"

extern NSString *const WTIMKitUserInfoHasUpdatedNotification;
extern NSString *const WTIMKitTeamInfoHasUpdatedNotification;

@interface WTIMKit ()

@property (nonatomic, strong) WTIMKitNotificationFirer *firer;
@property (nonatomic, strong) WTDataProvider *provider;

@end

@implementation WTIMKit

#pragma mark - Life Cycle
+ (instancetype)sharedKit
{
    static WTIMKit *sharedKit = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedKit = [[WTIMKit alloc] init];
    });
    return sharedKit;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _firer = [[WTIMKitNotificationFirer alloc] init];
        _provider = [[WTDataProvider alloc] init];
    }
    return self;
}

#pragma mark - Private Cycle
- (void)notifyTeam:(NSString *)teamId
{
    WTIMKitFirerInfo *info = [[WTIMKitFirerInfo alloc] init];
    if (teamId.length)
    {
        NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
        info.session = session;
    }
    info.notificationName = WTIMKitTeamInfoHasUpdatedNotification;
    [self.firer addFireInfo:info];
}

- (void)notifyTeamMemebers:(NSString *)teamId
{
    WTIMKitFirerInfo *info = [[WTIMKitFirerInfo alloc] init];
    if (teamId.length)
    {
        NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
        info.session = session;
    }
    extern NSString *WTIMKitTeamMembersHasUpdatedNotification;
    info.notificationName = WTIMKitTeamMembersHasUpdatedNotification;
    [self.firer addFireInfo:info];
}

#pragma mark - Public Cycle
- (void)notfiyUserInfoChanged:(NSArray *)userIds
{
    if (!userIds.count)
    {
        return;
    }
    for (NSString *userID in userIds)
    {
        NIMSession *session = [NIMSession session:userID type:NIMSessionTypeP2P];
        WTIMKitFirerInfo *info = [[WTIMKitFirerInfo alloc] init];
        info.session = session;
        info.notificationName = WTIMKitUserInfoHasUpdatedNotification;
        [self.firer addFireInfo:info];
    }
}

- (void)notifyTeamInfoChanged:(NSArray *)teamIds
{
    if (teamIds.count)
    {
        for (NSString *teamID in teamIds)
        {
            [self notifyTeam:teamID];
        }
    }
    else
    {
        [self notifyTeam:nil];
    }
}

- (void)notifyTeamMemebersChanged:(NSArray *)teamIds
{
    if (teamIds.count)
    {
        for (NSString *teamID in teamIds)
        {
            [self notifyTeamMemebers:teamID];
        }
    }
    else
    {
        [self notifyTeamMemebers:nil];
    }
}

- (WTIMInfo *)infoByUser:(NSString *)userID session:(NIMSession *)session
{
    return [self.provider obtainInfoByUser:userID session:session];
}

- (WTIMInfo *)infoByTeam:(NSString *)userID
{
    return [self.provider obtainInfoByTeam:userID];
}

@end
