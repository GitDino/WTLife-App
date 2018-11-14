//
//  WTSessionListVC.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/6/27.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <NIMSDK/NIMSDK.h>
#import "WTSessionListVC.h"
#import "WTSessionVC.h"
#import "WTSessionListTableView.h"
#import "WTSession.h"
#import "WTFriendsAPI.h"

@interface WTSessionListVC () <NIMLoginManagerDelegate, NIMConversationManagerDelegate>

@property (nonatomic, strong) WTSessionListTableView *listTableView;

@property (nonatomic, strong) NSMutableArray *wtSessions;

@end

@implementation WTSessionListVC

#pragma mark - Life Cycle
- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    
    extern NSString *const WTIMKitTeamInfoHasUpdatedNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTeamInfoHasUpdatedNotification:) name:WTIMKitTeamInfoHasUpdatedNotification object:nil];
    
    extern NSString *const WTIMKitTeamMembersHasUpdatedNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTeamMembersHasUpdatedNotification:) name:WTIMKitTeamMembersHasUpdatedNotification object:nil];
    
    extern NSString *const WTIMKitUserInfoHasUpdatedNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserInfoHasUpdatedNotification:) name:WTIMKitUserInfoHasUpdatedNotification object:nil];
    
    _wtSessions = [NSMutableArray array];
    
    [self configNav];
//    [self configAboutData];
    [self configSubViews];
    [self configAboutBlock];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configAboutData];
}

#pragma mark - Private Cycle
- (void)configNav
{
    self.navigationController.navigationBar.tintColor = [UIColor wtBlackColor];
    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_sweep"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
//    self.navigationItem.leftBarButtonItem = leftItem;
}

//- (void)leftBarButtonItemAction
//{
//    [[WTNotificationCenter defaultCenter] wtPostNotificationName:GetCameraNotification object:nil];
//}

- (void)configAboutData
{
    NSArray *recentSessions = [NIMSDK sharedSDK].conversationManager.allRecentSessions;
    
    if (self.wtSessions.count)
    {
        [self.wtSessions removeAllObjects];
    }
    for (NIMRecentSession *session in recentSessions)
    {
        WTSession *wtSession = [[WTSession alloc] init];
        wtSession.recentSession = session;
        [_wtSessions addObject:wtSession];
    }
}

- (void)configSubViews
{
    [self.view addSubview:self.listTableView];
}

- (void)configAboutBlock
{
    __weak typeof(self) weakSelf = self;
    self.listTableView.clickIndexCellBlock = ^(NSIndexPath *indexPath, NSMutableArray *data_array) {
       
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NIMRecentSession *recentSession = [data_array[indexPath.row] recentSession];
        NIMSession *session = [NIMSession session:recentSession.session.sessionId type:NIMSessionTypeP2P];
        strongSelf.rt_navigationController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        WTSessionVC *sessionVC = [[WTSessionVC alloc] initWithSession:session];
        sessionVC.hidesBottomBarWhenPushed = YES;
        sessionVC.isPush = YES;
        [strongSelf.rt_navigationController pushViewController:sessionVC animated:YES complete:nil];
    };
    
    self.listTableView.tapDeleteSessionCellBlock = ^(NIMRecentSession *recentSession) {
//        [[NIMSDK sharedSDK].conversationManager deleteRecentSession:recentSession];
        WTAlertManager *alertManager = [[WTAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:nil message:@"删除后，将清空该聊天的消息记录"];
        [alertManager cancelActionWithTitle:@"取消" destructiveIndex:-2 otherTitle:@"确定", nil];
        [alertManager showAlertFromController:weakSelf actionBlock:^(NSInteger actionIndex) {
            switch (actionIndex) {
                case 0:
                {
                    [weakSelf deleteSession:recentSession];
                }
                    break;
                    
                default:
                    break;
            }
        }];
    };
    
    
}

- (void)refreshData
{
    if (!self.wtSessions.count)
    {
        //隐藏TableView
    }
    else
    {
        //显示TableView
    }
    [self.listTableView refreshData:self.wtSessions];
}

- (void)sortSessions
{
    [self.wtSessions sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        WTSession *session1 = obj1;
        WTSession *session2 = obj2;
        NIMRecentSession *item1 = session1.recentSession;
        NIMRecentSession *item2 = session2.recentSession;
        if (item1.lastMessage.timestamp < item2.lastMessage.timestamp)
        {
            return NSOrderedDescending;
        }
        if (item1.lastMessage.timestamp > item2.lastMessage.timestamp)
        {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

- (NSInteger)findInsertPlace:(NIMRecentSession *)recentSession
{
    __block NSUInteger matchIdx = 0;
    __block BOOL find = NO;
    [self.wtSessions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WTSession *wtSession = obj;
        NIMRecentSession *item = wtSession.recentSession;
        if (item.lastMessage.timestamp <= recentSession.lastMessage.timestamp)
        {
            *stop = YES;
            find = YES;
            matchIdx = idx;
        }
    }];
    if (find)
    {
        return matchIdx;
    }
    else
    {
        return self.wtSessions.count;
    }
}

- (void)deleteSession:(NIMRecentSession *)recentSession
{
    NIMDeleteMessagesOption *option = [[NIMDeleteMessagesOption alloc] init];
    option.removeSession = YES;
    [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:recentSession.session option:option];
//    [[NIMSDK sharedSDK].userManager deleteFriend:recentSession.session.sessionId completion:^(NSError * _Nullable error) {
//        if (!error)
//        {
//            NSLog(@"删除好友成功%@", recentSession.session.sessionId);
//        }
//    }];
}

#pragma mark - NIMLoginManagerDelegate代理方法
- (void)onLogin:(NIMLoginStep)step
{
    if (step == NIMLoginStepSyncOK)
    {
        [self refreshData];
    }
}

#pragma mark - NIMConversationManagerDelegate代理方法
- (void)didAddRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount
{
    [[NIMSDK sharedSDK].userManager myFriends];
    WTSession *wtSession = [[WTSession alloc] init];
    wtSession.recentSession = recentSession;
    [self.wtSessions addObject:wtSession];
    [self sortSessions];
    [self refreshData];
}

- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount
{
    for (WTSession *wtSession in self.wtSessions)
    {
        NIMRecentSession *recent = wtSession.recentSession;
        if ([recentSession.session.sessionId isEqualToString:recent.session.sessionId])
        {
            [self.wtSessions removeObject:wtSession];
            break;
        }
    }
    NSInteger insertIndex = [self findInsertPlace:recentSession];
    WTSession *wtSession = [[WTSession alloc] init];
    wtSession.recentSession = recentSession;
    [self.wtSessions insertObject:wtSession atIndex:insertIndex];
    [self refreshData];
}

- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount
{
    [[NIMSDK sharedSDK].userManager myFriends];
    for (WTSession *wtSession in self.wtSessions)
    {
        NIMRecentSession *item = wtSession.recentSession;
        if ([item.session.sessionId isEqualToString:recentSession.session.sessionId])
        {
            NSInteger index = [self.wtSessions indexOfObject:wtSession];
            [self.wtSessions removeObjectAtIndex:index];
            break;
        }
    }
    //删除服务器会话
    [[NIMSDK sharedSDK].conversationManager deleteRemoteSessions:@[recentSession.session]
                                                      completion:nil];
    [self refreshData];
}

- (void)allMessagesRead
{
    [self configAboutData];
    [self refreshData];
}

/**
 删除某个会话内所有消息
 */
- (void)messagesDeletedInSession:(NIMSession *)session{}

/**
 清理所有消息回调
 */
- (void)allMessagesDeleted{}

#pragma mark - Observe Cycle
- (void)onUserInfoHasUpdatedNotification:(NSNotification *)notification
{
    [self.listTableView reloadData];
}

- (void)onTeamInfoHasUpdatedNotification:(NSNotification *)notification
{
    [self.listTableView reloadData];
}

- (void)onTeamMembersHasUpdatedNotification:(NSNotification *)notification
{
    [self.listTableView reloadData];
}

#pragma mark - Getter Cycle
- (WTSessionListTableView *)listTableView
{
    if (!_listTableView)
    {
        _listTableView = [[WTSessionListTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.wt_width, self.view.wt_height)];
        _listTableView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
        _listTableView.rowHeight = 68.0;
    }
    return _listTableView;
}

@end
