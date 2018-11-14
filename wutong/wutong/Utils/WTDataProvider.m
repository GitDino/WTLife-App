//
//  WTDataProvider.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/11.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTDataProvider.h"
#import "WTIMKit.h"

@interface WTDataRequest : NSObject

@property (nonatomic, strong) NSMutableSet *failedUserID;
@property (nonatomic, assign) NSInteger maxMergeCount;

- (void)requestUserID:(NSArray *)userIDArray;

@end

@implementation WTDataRequest
{
    NSMutableArray *_requestUserIDArray;
    BOOL _isRequesting;
}

#pragma mark - Life Cycle
- (instancetype)init
{
    if (self = [super init])
    {
        _failedUserID = [[NSMutableSet alloc] init];
        _requestUserIDArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public Cycle
- (void)requestUserID:(NSArray *)userIDArray
{
    for (NSString *userId in userIDArray)
    {
        if (![_requestUserIDArray containsObject:userId] && ![_failedUserID containsObject:userId])
        {
            [_requestUserIDArray addObject:userId];
        }
    }
    [self request];
}

#pragma mark - Private Cycle
- (void)request
{
    static NSUInteger MaxBatchReuqestCount = 10;
    if (_isRequesting || [_requestUserIDArray count] == 0)
    {
        return;
    }
    _isRequesting = YES;
    NSArray *userIDArray = [_requestUserIDArray count] > MaxBatchReuqestCount ?
    [_requestUserIDArray subarrayWithRange:NSMakeRange(0, MaxBatchReuqestCount)] : [_requestUserIDArray copy];
    
    __weak typeof(self) weakSelf = self;
    [[NIMSDK sharedSDK].userManager fetchUserInfos:userIDArray completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
        [weakSelf afterReuquest:userIDArray];
        if (!error && users.count)
        {
            //请求成功处理
            [[WTIMKit sharedKit] notfiyUserInfoChanged:userIDArray];
        }
        else if ([weakSelf shouldAddToFailedUsers:error])
        {
            [weakSelf.failedUserID addObjectsFromArray:userIDArray];
        }
    }];
}

- (void)afterReuquest:(NSArray *)userIDArray
{
    _isRequesting = NO;
    [_requestUserIDArray removeObjectsInArray:userIDArray];
    [self request];
}

- (BOOL)shouldAddToFailedUsers:(NSError *)error
{
    return error.code != NIMRemoteErrorCodeTimeoutError || !error;
}

@end


@interface WTDataProvider () <NIMUserManagerDelegate, NIMTeamManagerDelegate, NIMLoginManagerDelegate>

@property (nonatomic, strong) UIImage *defaultUserAvatat;

@property (nonatomic, strong) UIImage *defaultTeamAvatat;

@property (nonatomic, strong) WTDataRequest *request;

@end

@implementation WTDataProvider

#pragma mark - Life Cycle
- (void)dealloc
{
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
    [[NIMSDK sharedSDK].teamManager removeDelegate:self];
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
}

- (instancetype)init
{
    if (self = [super init])
    {
        _request = [[WTDataRequest alloc] init];
        _request.maxMergeCount = 20;
        
        [[NIMSDK sharedSDK].userManager addDelegate:self];
        [[NIMSDK sharedSDK].teamManager addDelegate:self];
        [[NIMSDK sharedSDK].loginManager addDelegate:self];
    }
    return self;
}

#pragma mark - Public Cycle
- (WTIMInfo *)obtainInfoByUser:(NSString *)userId session:(NIMSession *)session
{
    return [self infoByUser:userId session:session];
}

- (WTIMInfo *)obtainInfoByTeam:(NSString *)teamId
{
    NIMTeam *team    = [[NIMSDK sharedSDK].teamManager teamById:teamId];
    WTIMInfo *info = [[WTIMInfo alloc] init];
    info.showName    = team.teamName;
    info.infoID      = teamId;
    info.avatarImage = self.defaultTeamAvatat;
    info.avatarURL = team.thumbAvatarUrl;
    return info;
}


#pragma mark - Private Cycle
- (WTIMInfo *)infoByUser:(NSString *)userID session:(NIMSession *)session
{
    NIMSessionType sessionType = session.sessionType;
    WTIMInfo *info;
    switch (sessionType) {
        case NIMSessionTypeP2P:
            info = [self userInfoByP2P:userID];
            break;
        case NIMSessionTypeTeam:
            info = [self userInfo:userID inTeam:session.sessionId];
            break;
            
        default:
            break;
    }
    if (!info)
    {
        if (userID.length)
        {
            [self.request requestUserID:@[userID]];
        }
        info = [[WTIMInfo alloc] init];
        info.infoID = userID;
        info.showName = userID;
        info.avatarImage = self.defaultUserAvatat;
    }
    return info;
}

/**
 获取P2P用户信息
 */
- (WTIMInfo *)userInfoByP2P:(NSString *)userID
{
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:userID];
    NIMUserInfo *userInfo = user.userInfo;
    WTIMInfo *info;
    if (userInfo)
    {
        info = [[WTIMInfo alloc] init];
        info.infoID = userID;
        NSString *name = [self nickName:user memberInfo:nil];
        info.showName = name?:userID;
        info.avatarURL = userInfo.thumbAvatarUrl;
        info.userType = [[NSDictionary dictWithJsonStr:userInfo.ext] objectForKey:@"userTpye"];
        info.uid = [[NSDictionary dictWithJsonStr:userInfo.ext] objectForKey:@"uid"];
    }
    return info;
}

/**
 获取群组用户信息
 */
- (WTIMInfo *)userInfo:(NSString *)userID inTeam:(NSString *)teamID
{
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:userID];
    NIMUserInfo *userInfo = user.userInfo;
    NIMTeamMember *member =  [[NIMSDK sharedSDK].teamManager teamMember:userID
                                                                 inTeam:teamID];
    WTIMInfo *info;
    if (userInfo || member)
    {
        info = [[WTIMInfo alloc] init];
        info.infoID = userID;
        NSString *name = [self nickName:user memberInfo:member];
        info.showName = name?:userID;
        info.avatarURL = userInfo.thumbAvatarUrl;
        info.avatarImage = self.defaultTeamAvatat;
    }
    return info;
}

/**
 备注优先
 */
- (NSString *)nickName:(NIMUser *)user memberInfo:(NIMTeamMember *)memberInfo
{
    NSString *name = nil;
    do {
        if ([user.alias length])
        {
            name = user.alias;
            break;
        }
        if (memberInfo && [memberInfo.nickname length])
        {
            name = memberInfo.nickname;
            break;
        }
        if ([user.userInfo.nickName length])
        {
            name = user.userInfo.nickName;
            break;
        }
    } while (0);
    return name;
}

- (void)notifyUser:(NIMUser *)user
{
    if (user)
    {
        [[WTIMKit sharedKit] notfiyUserInfoChanged:@[user.userId]];
    }
}

- (void)notifyTeamMember:(NIMTeam *)team
{
    if (team.teamId.length)
    {
        [[WTIMKit sharedKit] notifyTeamMemebersChanged:@[team.teamId]];
    }
}

#pragma mark - NIMUserManagerDelegate代理方法
- (void)onFriendChanged:(NIMUser *)user
{
    [self notifyUser:user];
}

- (void)onUserInfoChanged:(NIMUser *)user
{
    [self notifyUser:user];
}

#pragma mark - NIMTeamManagerDelegate代理方法
- (void)onTeamAdded:(NIMTeam *)team
{
    [self notifyTeamMember:team];
}

- (void)onTeamUpdated:(NIMTeam *)team
{
    [self notifyTeamMember:team];
}

- (void)onTeamRemoved:(NIMTeam *)team
{
    [self notifyTeamMember:team];
}

- (void)onTeamMemberChanged:(NIMTeam *)team
{
    [self notifyTeamMember:team];
}

#pragma mark - NIMLoginManagerDelegate代理方法
- (void)onLogin:(NIMLoginStep)step
{
    if (step == NIMLoginStepSyncOK)
    {
        [[WTIMKit sharedKit] notifyTeamInfoChanged:nil];
        [[WTIMKit sharedKit] notifyTeamMemebersChanged:nil];
    }
}

#pragma mark - Getter Cycle
- (UIImage *)defaultUserAvatat
{
    if (!_defaultUserAvatat)
    {
        _defaultUserAvatat = [UIImage imageNamed:@"icon_default_head"];
    }
    return _defaultUserAvatat;
}

- (UIImage *)defaultTeamAvatat
{
    if (!_defaultTeamAvatat)
    {
        _defaultTeamAvatat = [UIImage imageNamed:@"icon_default_head"];
    }
    return _defaultTeamAvatat;
}


@end
