//
//  WTSessionVC.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/6/18.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <TZImagePickerController.h>
#import <WTSmallVideoVC.h>
#import <WTSessionBoxVC.h>
#import "WTSessionVC.h"
#import "WTChatCustomWebViewVC.h"
#import "WTUserHomeVC.h"
#import "WTAdviserHomeVC.h"
#import "WTPlayVideoVC.h"
#import "WTChatTableView.h"
#import "WTRefreshHeader.h"
#import "WTMediaItem.h"
#import "WTSessionBoxProtocol.h"
#import "WTSessionUtil.h"
#import "WTSessionMsgManager.h"
#import "WTAuthorityManager.h"
#import "WTChartletModel.h"
#import "WTChatGoodsModel.h"
#import "WTChatOrderModel.h"
#import "WTIMKit.h"
#import <YBImageBrowser.h>

#define WT_SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@interface WTSessionVC () <WTSessionBoxVCDelegate, WTSessionBoxProtocol, WTChatTableViewProtcol, NIMChatManagerDelegate, NIMConversationManagerDelegate, NIMMediaManagerDelegate>

#pragma mark - UI相关
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) WTSessionBoxVC *sessionBoxVC;

@property (nonatomic, strong) WTChatTableView *chatTableView;

@property (nonatomic, strong) WTRefreshHeader *refreshHeader;

@property (nonatomic, assign, getter=isRefreshing) BOOL refreshing;

#pragma mark - 业务功能
@property (nonatomic, copy) NSString *sessionTitle;

@property (nonatomic, strong) WTSessionMsgManager *messageManager;

@end

@implementation WTSessionVC

#pragma mark - Life Cycle
- (void)dealloc
{
    [self removeAboutDeleagte];
    NSLog(@"%s", __FUNCTION__);
}

- (instancetype)initWithSession:(NIMSession *) session
{
    if (self = [super init])
    {
        _session = session;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.sessionTitle;
    self.viewHeight = self.view.wt_height - 64;
    
    extern NSString *const WTIMKitUserInfoHasUpdatedNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserInfoHasUpdatedNotification:) name:WTIMKitUserInfoHasUpdatedNotification object:nil];
    
    [self addAboutDelegate];
    
    [self markIsRead];
    
    [self configSubViews];
    [self configNav];
    
    __weak typeof(self) weakSelf = self;
    [self.messageManager resetMessages:^(NSUInteger count) {
        [weakSelf.chatTableView refreshMessages:weakSelf.messageManager.items];
        if (count == 15)
        {
            weakSelf.chatTableView.tableHeaderView = weakSelf.refreshHeader;
            weakSelf.refreshHeader.hidden = YES;
        }
        
        [weakSelf scrollBottomAnimation:NO];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NIMSDK sharedSDK].mediaManager stopRecord];
    [[NIMSDK sharedSDK].mediaManager stopPlay];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NIMSDK sharedSDK].mediaManager removeDelegate:self];
}

#pragma mark - Private Cycle
- (void)addAboutDelegate
{
    //相关代理
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
}

- (void)removeAboutDeleagte
{
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
}

- (void)configSubViews
{
    self.chatTableView.interactor = self;
    [self.view addSubview:self.chatTableView];
    
    [self.view addSubview:self.sessionBoxVC.view];
    [self addChildViewController:self.sessionBoxVC];
}

- (void)configNav
{
    self.navigationController.navigationBar.tintColor = [UIColor wtBlackColor];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_personInfo"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)leftBarButtonItemAction
{
    if (self.isPush)
    {
        self.rt_navigationController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, WTIsiPhoneX ? SCREEN_HEIGHT - 49 - 34 : SCREEN_HEIGHT - 49);
        [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightBarButtonItemAction
{
    [self checkUserHomeViewWithSessionId:self.session.sessionId];
}


/**
 下拉加载更多
 */
- (void)pullDownRefresh
{
    self.refreshHeader.hidden = NO;
    self.refreshing = YES;
    [self.refreshHeader startAnimating];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.messageManager loadHistoryMessagesWithComplete:^(NSUInteger count) {
            [weakSelf.chatTableView refreshMessages:weakSelf.messageManager.items];
            [weakSelf.refreshHeader stopAnimating];
            weakSelf.refreshHeader.hidden = YES;
            weakSelf.refreshing = NO;
            if (count < 15)
            {
                weakSelf.chatTableView.tableHeaderView = nil;
            }
        }];
    });
}

/**
 滚动底部
 */
- (void)scrollBottomAnimation:(BOOL)animation
{
    if (self.messageManager.items.count > 0)
    {
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageManager.items.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animation];
    }
}

/**
 当前会话所有消息已读
 */
- (void)markIsRead
{
    [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:self.session];
}

/**
 发送
 */
- (void)sessionSendMessage:(NIMMessage *)message
{
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:self.session error:nil];
    [self.messageManager addNewMessages:@[message]];
    [self.chatTableView refreshMessages:self.messageManager.items];
    [self scrollBottomAnimation:YES];
}

/**
 发送图片
 */
- (void)sessionSendPhotos:(NSArray<UIImage *> *)photos
{
    for (UIImage *photo in photos)
    {
        NIMImageObject *imageObject = [[NIMImageObject alloc] initWithImage:photo];
        NIMMessage *message = [[NIMMessage alloc] init];
        message.messageObject = imageObject;
        [self sessionSendMessage:message];
    }
}

/**
 语音录制时长判断
 */
- (BOOL)recordFileCanBeSend:(NSString *)filePath
{
    NSURL *url = [NSURL fileURLWithPath:filePath];
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    CMTime time = urlAsset.duration;
    CGFloat mediaLength = CMTimeGetSeconds(time);
    return mediaLength > 2;
}

- (void)judgeUserInteractionEnabled:(BOOL)isRecording
{
    self.chatTableView.userInteractionEnabled = !isRecording;
    self.navigationController.navigationBar.userInteractionEnabled = !isRecording;
}

- (void)checkUserHomeViewWithSessionId:(NSString *)sessionId
{
    WTIMInfo *userInfo = [[WTIMKit sharedKit] infoByUser:sessionId session:self.session];
    
    switch ([[[WTAccountManager sharedManager] currentUser] userType]) {
        case 1://顾问
        {
            if ([sessionId isEqualToString:[[[WTAccountManager sharedManager] currentUser] tel]])
            {
                WTAdviserHomeVC *adviserHomeVC = [[WTAdviserHomeVC alloc] init];
                adviserHomeVC.imAccount = sessionId;
                adviserHomeVC.uid = userInfo.uid;
                [self.rt_navigationController pushViewController:adviserHomeVC animated:YES complete:nil];
            }
            else
            {
                WTUserHomeVC *userHomeVC = [[WTUserHomeVC alloc] init];
                userHomeVC.imAccount = sessionId;
                userHomeVC.uid = userInfo.uid;
                [self.rt_navigationController pushViewController:userHomeVC animated:YES complete:nil];
            }
        }
            break;
        case 2://用户
        {
            WTAdviserHomeVC *adviserHomeVC = [[WTAdviserHomeVC alloc] init];
            adviserHomeVC.imAccount = sessionId;
            adviserHomeVC.uid = userInfo.uid;
            [self.rt_navigationController pushViewController:adviserHomeVC animated:YES complete:nil];
        }
            break;

        default:
            break;
    }
}

#pragma mark - WTChatTableViewProtcol协议方法
- (void)didScrollOffetY:(CGFloat)y
{
    if (y <= 0 && self.isRefreshing == NO)
    {
        [self pullDownRefresh];
    }
}

- (void)onTapResignFirstResponder
{
    [self.sessionBoxVC resignFirstResponder];
}

- (void)onTapHeadIconWithSessionId:(NSString *)sessionId
{
    [self checkUserHomeViewWithSessionId:sessionId];
}

- (void)onRetryMessage:(NIMMessage *)message
{
    if (message.isReceivedMsg)
    {
        [[[NIMSDK sharedSDK] chatManager] fetchMessageAttachment:message
                                                           error:nil];
    }
    else
    {
        WTAlertManager *alertManager = [[WTAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:nil message:@"确定重发此条消息？"];
        [alertManager cancelActionWithTitle:@"取消" destructiveIndex:-2 otherTitle:@"确定", nil];
        [alertManager showAlertFromController:self actionBlock:^(NSInteger actionIndex) {
            switch (actionIndex) {
                case 0:
                    [[[NIMSDK sharedSDK] chatManager] resendMessage:message
                                                              error:nil];
                    break;
                    
                default:
                    break;
            }
        }];
    }
}

/**
 删除消息
 */
- (void)onDeleteMessage:(NIMMessage *)message
{
    WTAlertManager *alertManager = [[WTAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:nil message:@"确定删除此条消息？"];
    [alertManager cancelActionWithTitle:@"取消" destructiveIndex:-2 otherTitle:@"确定", nil];
    [alertManager showAlertFromController:self actionBlock:^(NSInteger actionIndex) {
        switch (actionIndex) {
            case 0:
                [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
                [self.messageManager deleteMessage:message];
                [self.chatTableView refreshMessages:self.messageManager.items];
                break;
                
            default:
                break;
        }
    }];
    
}

/**
 撤回消息
 */
- (void)onRevokeMessage:(NIMMessage *)message
{
    WTAlertManager *alertManager = [[WTAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleActionSheet title:nil message:@"是否撤回此条消息？"];
    [alertManager cancelActionWithTitle:@"取消" destructiveIndex:-2 otherTitle:@"确定", nil];
    [alertManager showAlertFromController:self actionBlock:^(NSInteger actionIndex) {
        switch (actionIndex) {
            case 0:
            {
                [[NIMSDK sharedSDK].chatManager revokeMessage:message completion:^(NSError * _Nullable error) {
                    if (!error)
                    {
                        [self.messageManager deleteMessage:message];
                        NIMMessage *tip = [WTSessionUtil configTipMessage:[WTSessionUtil tipOnMessageRevoked:nil]];
                        tip.timestamp = message.timestamp;
                        [self.messageManager insertTipMessages:@[tip]];
                        [[NIMSDK sharedSDK].conversationManager saveMessage:tip forSession:message.session completion:nil];
                    }
                    else
                    {
                        [WTProgressHUD showProgressInView:self.view message:@"只能撤回2分钟以内的消息"];
                    }
                }];
            }
                break;
                
            default:
                break;
        }
    }];
}

- (void)onTapTextMessage:(NIMMessage *)message
{
    [self onTapResignFirstResponder];
}

/**
 点击图片
 */
- (void)onTapImageMessage:(NIMMessage *)message bubbleImage:(WTBubbleImageView *)bubbleImage
{
    [self onTapResignFirstResponder];
    NIMImageObject *imageObject = (NIMImageObject *)message.messageObject;
    
    YBImageBrowserModel *model = [YBImageBrowserModel new];
    [model setUrlWithDownloadInAdvance:[NSURL URLWithString:imageObject.url]];
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataArray = @[model];
    browser.currentIndex = 0;
    [browser show];
}

- (void)onTapAudioMessage:(NIMMessage *)message
{
    [self onTapResignFirstResponder];
}

/**
 点击视频
 */
- (void)onTapVideoMessage:(NIMMessage *)message
{
    [self onTapResignFirstResponder];
    
    NIMVideoObject *videoObject = (NIMVideoObject *)message.messageObject;
    
    WTPlayVideoVC *playVideoVC = [[WTPlayVideoVC alloc] init];
    playVideoVC.videoPath = videoObject.path;
    playVideoVC.videoURL = videoObject.url;
    playVideoVC.imageCoverPath = videoObject.coverPath;
    [self presentViewController:playVideoVC animated:NO completion:nil];
}

/**
 点击商品
 */
- (void)onTapGoodsMessage:(NIMMessage *)message
{
    [self onTapResignFirstResponder];
    
    NIMCustomObject *customObject = (NIMCustomObject *)message.messageObject;
    WTChatGoodsModel *goodsModle = (WTChatGoodsModel *)customObject.attachment;
    
    WTChatCustomWebViewVC *goodsListVC = [[WTChatCustomWebViewVC alloc] init];
    goodsListVC.urlStr = [NSString stringWithFormat:@"%@/detail?id=%@&nativeMessage=true&imNative=true&shopId=%@&shopName=%@", Web_URL, goodsModle.goodId, goodsModle.shopId, goodsModle.shopName];
    [self presentViewController:goodsListVC animated:YES completion:nil];
}

/**
 点击订单
 */
- (void)onTapOrderMessage:(NIMMessage *)message
{
    [self onTapResignFirstResponder];
    
    NIMCustomObject *customObject = (NIMCustomObject *)message.messageObject;
    WTChatOrderModel *orderModel = (WTChatOrderModel *)customObject.attachment;
    
    WTChatCustomWebViewVC *goodsListVC = [[WTChatCustomWebViewVC alloc] init];
    goodsListVC.urlStr = [NSString stringWithFormat:@"%@/orderDetails?sn=%@&nativeMessage=true", Web_URL, orderModel.orderNo];//&native=true
    [self presentViewController:goodsListVC animated:YES completion:nil];
}

#pragma mark - WTSessionBoxVCDelegate代理方法
- (void)sessionBoxVC:(WTSessionBoxVC *)sessionBoxVC didChangeBoxHeight:(CGFloat)height
{
    [self.chatTableView setWt_height:WTIsiPhoneX ? self.viewHeight - height - 34 : self.viewHeight - height];
    [self.sessionBoxVC.view setWt_top:self.chatTableView.wt_top + self.chatTableView.wt_height];
    [self scrollBottomAnimation:YES];
}

#pragma mark - 发送文本信息
- (void)onSendText:(NSString *)text atUsers:(NSArray *)atUsers
{
    NIMMessage *message = [[NIMMessage alloc] init];
    message.text = text;
    [self sessionSendMessage:message];
}

#pragma mark - 超级表情
- (void)onSelectChartlet:(NSString *)chartletId catalog:(NSString *)catalogId
{
    WTChartletModel *chartletModel = [[WTChartletModel alloc] init];
    chartletModel.chartletID = chartletId;
    chartletModel.chartletCatalog = catalogId;
    NIMMessage *message = [[NIMMessage alloc] init];
    NIMCustomObject *customObject = [[NIMCustomObject alloc] init];
    customObject.attachment = chartletModel;
    message.messageObject = customObject;
    message.apnsContent = @"[贴图]";
    
    [self sessionSendMessage:message];
}

#pragma mark - WTSessionBoxProtocol协议方法
- (BOOL)onTapMediaItem:(WTMediaItem *)item
{
    SEL sel = item.selector;
    BOOL handled = sel && [self respondsToSelector:sel];
    if (handled)
    {
        WT_SuppressPerformSelectorLeakWarning([self performSelector:sel withObject:item]);
        handled = YES;
    }
    return handled;
}

#pragma mark - 相册、视频相关方法
- (void)onTapMediaPhoto:(WTMediaItem *)item
{
    TZImagePickerController *photoPicker = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    photoPicker.allowTakeVideo = NO;
    photoPicker.allowTakePicture = NO;
    photoPicker.naviTitleColor = [UIColor wtBlackColor];
    photoPicker.barItemTextColor = [UIColor wtBlackColor];
    [photoPicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [self sessionSendPhotos:photos];
    }];
    [self presentViewController:photoPicker animated:YES completion:nil];
}

- (void)onTapMediaVideo:(WTMediaItem *)item
{
    WTSmallVideoVC *smallVideoVC = [[WTSmallVideoVC alloc] init];
    smallVideoVC.filePath = [WTFileLocationHelper filePathForVideo:[WTFileLocationHelper genFileNameWithExt:@"mp4"]];
    smallVideoVC.sureBlock = ^(id item) {
        if ([item isKindOfClass:[NSURL class]])
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
            NIMVideoObject *videoObject = [[NIMVideoObject alloc] initWithSourcePath:[item absoluteString]];
            videoObject.displayName = [NSString stringWithFormat:@"发来了一段视频，%@",dateString];
            NIMMessage *message = [[NIMMessage alloc] init];
            message.messageObject = videoObject;
            message.apnsContent = @"发来了一段视频";
            [self sessionSendMessage:message];
        }
        else
        {
            [self sessionSendPhotos:@[item]];
        }
    };
    [self presentViewController:smallVideoVC animated:YES completion:nil];
}

- (void)onTapGoods:(WTMediaItem *)item
{
    WTChatCustomWebViewVC *goodsListVC = [[WTChatCustomWebViewVC alloc] init];
    goodsListVC.urlStr = [NSString stringWithFormat:@"%@/classifyList?native=true", Web_URL];
    [self presentViewController:goodsListVC animated:YES completion:nil];
    goodsListVC.sendCompleteBlock = ^(id object) {
        if ([object isKindOfClass:[WTChatGoodsModel class]])
        {
            WTChatGoodsModel *goodModel = object;
            NIMCustomObject *customObject = [[NIMCustomObject alloc] init];
            customObject.attachment = goodModel;
            NIMMessage *message = [[NIMMessage alloc] init];
            message.messageObject = customObject;
            [self sessionSendMessage:message];
        }
    };
}

- (void)onTapOrder:(WTMediaItem *)item
{
    WTChatCustomWebViewVC *ordersListVC = [[WTChatCustomWebViewVC alloc] init];
    ordersListVC.urlStr = [NSString stringWithFormat:@"%@/order?index=0&native=true", Web_URL];
    [self presentViewController:ordersListVC animated:YES completion:nil];
    ordersListVC.sendCompleteBlock = ^(id object) {
        if ([object isKindOfClass:[WTChatOrderModel class]])
        {
            WTChatOrderModel *orderModel = object;
            NIMCustomObject *customObject = [[NIMCustomObject alloc] init];
            customObject.attachment = orderModel;
            NIMMessage *message = [[NIMMessage alloc] init];
            message.messageObject = customObject;
            [self sessionSendMessage:message];
        }
    };
}

#pragma mark - 录音相关方法
- (void)onCancelRecording
{
    [self judgeUserInteractionEnabled:NO];
    [[NIMSDK sharedSDK].mediaManager cancelRecord];
}

- (void)onStopRecording
{
    [self judgeUserInteractionEnabled:NO];
    [[NIMSDK sharedSDK].mediaManager stopRecord];
}

- (void)onStartRecording
{
    [self judgeUserInteractionEnabled:YES];
    [WTAuthorityManager obtainAudioAuthority:^(BOOL isAllow, NSString *prompt) {
        if (!isAllow)
        {
            WTAlertManager *alertManager = [[WTAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:nil message:prompt];
            [alertManager cancelActionWithTitle:@"确定" destructiveIndex:-2 otherTitle:nil];
            [alertManager showAlertFromController:self actionBlock:nil];
        }
        else
        {
            self.sessionBoxVC.recording = YES;
            
            [[[NIMSDK sharedSDK] mediaManager] addDelegate:self];
            NIMAudioType type = NIMAudioTypeAAC;
            [[[NIMSDK sharedSDK] mediaManager] record:type duration:60];
        }
    }];
}

#pragma mark - NIMChatManagerDelegate代理方法
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages
{
    NIMMessage *message = messages.firstObject;
    NIMSession *session = message.session;
    if (![session isEqual:self.session] || !messages.count)
    {
        return;
    }
    [self.messageManager addNewMessages:messages];
    [self.chatTableView refreshMessages:self.messageManager.items];
    [self scrollBottomAnimation:YES];
    [self markIsRead];
}

- (void)fetchMessageAttachment:(NIMMessage *)message didCompleteWithError:(NSError *)error
{
    [self.messageManager updateMessage:message];
    [self.chatTableView refreshMessages:self.messageManager.items];
}

- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error
{
    [self.chatTableView refreshMessages:self.messageManager.items];
}

- (void)onRecvRevokeMessageNotification:(NIMRevokeMessageNotification *)notification
{
    NIMMessage *tip = [WTSessionUtil configTipMessage:[WTSessionUtil tipOnMessageRevoked:notification]];
    [self.messageManager deleteMessage:notification.message];
    tip.timestamp = notification.message.timestamp;
    [self.messageManager insertTipMessages:@[tip]];
    [[NIMSDK sharedSDK].conversationManager saveMessage:tip forSession:notification.message.session completion:nil];
}

#pragma mark - NIMMediaManagerDelegate代理方法
- (void)recordAudio:(NSString *)filePath didCompletedWithError:(NSError *)error
{
    if (!error)
    {
        if ([self recordFileCanBeSend:filePath])
        {
            NIMAudioObject *audioObject = [[NIMAudioObject alloc] initWithSourcePath:filePath];
            NIMMessage *message = [[NIMMessage alloc] init];
            message.messageObject = audioObject;
            [self sessionSendMessage:message];
        }
        else
        {
            self.sessionBoxVC.recordPhase = WTAudioRecordPhaseLessThanMinTime;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.sessionBoxVC.recording = NO;
        });
    }
    else
    {
        [WTProgressHUD showProgressInView:self.view message:@"录音失败"];
        self.sessionBoxVC.recording = NO;
    }
}

- (void)recordAudioDidCancelled
{
    self.sessionBoxVC.recording = NO;
}

- (void)recordAudioProgress:(NSTimeInterval)currentTime
{
    [self.sessionBoxVC updateAudioRecordTime:currentTime];
}

- (void)recordAudioInterruptionBegin
{
    [[NIMSDK sharedSDK].mediaManager cancelRecord];
}

#pragma mark - Observe Cycle
- (void)onUserInfoHasUpdatedNotification:(NSNotification *)notification
{
    self.title = self.sessionTitle;
    [self.chatTableView refreshMessages:self.messageManager.items];
}

#pragma mark - Getter Cycle
- (WTSessionBoxVC *)sessionBoxVC
{
    if (!_sessionBoxVC)
    {
        _sessionBoxVC = [[WTSessionBoxVC alloc] init];
        [_sessionBoxVC.view setFrame:CGRectMake(0, WTIsiPhoneX ? SCREEN_HEIGHT - 50 - 64 - 34 : SCREEN_HEIGHT - 50 - 64, self.view.wt_width, self.view.wt_height)];
        _sessionBoxVC.delegate = self;
        [_sessionBoxVC setSessionBoxProtocol:self];
    }
    return _sessionBoxVC;
}

- (WTChatTableView *)chatTableView
{
    if (!_chatTableView)
    {
        _chatTableView = [[WTChatTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.wt_width, WTIsiPhoneX ? self.viewHeight - 50 - 34 : self.viewHeight - 50)];
    }
    return _chatTableView;
}

- (WTRefreshHeader *)refreshHeader
{
    if (!_refreshHeader)
    {
        _refreshHeader = [[WTRefreshHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.wt_width, 40)];
    }
    return _refreshHeader;
}

- (NSString *)sessionTitle
{
    NSString *title = @"";
    NIMSessionType type = self.session.sessionType;
    switch (type) {
        case NIMSessionTypeTeam:
        {
            NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
            title = [NSString stringWithFormat:@"%@(%zd)", [team teamName], [team memberNumber]];
        }
            break;
        case NIMSessionTypeP2P:
        {
            title = [WTSessionUtil showNick:self.session.sessionId inSession:self.session];
            title = [title isEqualToString:self.session.sessionId] ? @"" : title;
        }
            break;
            
        default:
            break;
    }
    return title;
}

- (WTSessionMsgManager *)messageManager
{
    if (!_messageManager)
    {
        _messageManager = [[WTSessionMsgManager alloc] initWithSession:self.session];
    }
    return _messageManager;
}

@end
