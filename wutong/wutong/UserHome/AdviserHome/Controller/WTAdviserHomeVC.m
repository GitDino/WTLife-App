//
//  WTAdviserHomeVC.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/5.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTAdviserHomeVC.h"
#import "WTAboutUserConfigVC.h"
#import "WTAdviserHomeTableView.h"
#import "WTHomeToolBar.h"
#import "WTAccountAPI.h"
#import "WTUserInfoModel.h"
#import "WTUserHomeCellModel.h"
#import "WTIMKit.h"

@interface WTAdviserHomeVC () <NIMUserManagerDelegate>

@property (nonatomic, strong) WTAdviserHomeTableView *homeTableView;

@property (nonatomic, strong) WTHomeToolBar *toolBar;

@property (nonatomic, strong) WTUserInfoModel *infoModel;

@end

@implementation WTAdviserHomeVC

#pragma mark - Life Cycle
- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
    self.title = @"查看资料";
    [[NIMSDK sharedSDK].userManager addDelegate:self];
    
    [self configNav];
    [self configSubViews];
    [self configAboutBlock];
    [self obtainUserInfo];
}

#pragma mark - Private Cycle
- (void)configNav
{
    self.navigationController.navigationBar.tintColor = [UIColor wtBlackColor];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)leftBarButtonItemAction
{
    [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
}

- (void)configSubViews
{
    [self.view addSubview:self.homeTableView];
    if (![self.imAccount isEqualToString:[[[WTAccountManager sharedManager] currentUser] tel]])
    {
        self.homeTableView.tableFooterView = self.toolBar;
    }
}

- (void)configAboutBlock
{
    __weak typeof(self) weakSelf = self;
    self.toolBar.tapSendMessageBlock = ^{
        [weakSelf.rt_navigationController popViewControllerAnimated:YES complete:nil];
    };
    self.homeTableView.tapIndexCellBlock = ^(NSString *tel, NSInteger index) {
        switch (index) {
            case 0:
            {
                WTAboutUserConfigVC *configVC = [[WTAboutUserConfigVC alloc] init];
                configVC.imAccount = weakSelf.imAccount;
                configVC.uid = weakSelf.uid;
                [weakSelf.rt_navigationController pushViewController:configVC animated:YES complete:nil];
                configVC.popBlock = ^(NSString *aliasName, NSString *remtel) {
                    if (![NSString isBlankString:aliasName])
                    {
                        weakSelf.infoModel.nickname = aliasName;
                    }
                    if (![NSString isBlankString:remtel])
                    {
                        weakSelf.infoModel.remtel = remtel;
                    }
                    BOOL isMySelf = [weakSelf.imAccount isEqualToString:[[[WTAccountManager sharedManager] currentUser] tel]];
                    NSArray *dataArray = [WTUserHomeCellModel obtainAdviserHomeCellModelsWithUserInfoModel:weakSelf.infoModel isMySelf:isMySelf];
                    [weakSelf.homeTableView refreshData:dataArray];
                };
            }
                break;
            case 1:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", tel]]];
                break;
                
            default:
                break;
        }
    };
}

- (void)obtainUserInfo
{
    __weak typeof(self) weakSelf = self;
    [WTProgressHUD showHUDInView:self.view];
    [WTAccountAPI obtainUserInfoWithId:self.uid resultBlock:^(NSDictionary *object) {
        NSLog(@"%@", object);
        [WTProgressHUD hideHUDForView:self.view];
        if ([object[@"code"] integerValue] == 200)
        {
            weakSelf.infoModel = [WTUserInfoModel mj_objectWithKeyValues:object[@"data"]];
            NIMSession *session = [NIMSession session:weakSelf.imAccount type:NIMSessionTypeP2P];
            WTIMInfo *userInfo = [[WTIMKit sharedKit] infoByUser:weakSelf.imAccount session:session];
            weakSelf.infoModel.nickname = userInfo.showName;
            BOOL isMySelf = [weakSelf.imAccount isEqualToString:[[[WTAccountManager sharedManager] currentUser] tel]];
            NSArray *dataArray = [WTUserHomeCellModel obtainAdviserHomeCellModelsWithUserInfoModel:weakSelf.infoModel isMySelf:isMySelf];
            [weakSelf.homeTableView refreshData:dataArray];
        }
        else
        {
            [WTProgressHUD showProgressInView:self.view message:object[@"message"]];
        }
    }];
}

#pragma mark - NIMUserManagerDelegate代理方法
- (void)onFriendChanged:(NIMUser *)user
{
    NIMSession *session = [NIMSession session:self.imAccount type:NIMSessionTypeP2P];
    WTIMInfo *userInfo = [[WTIMKit sharedKit] infoByUser:self.imAccount session:session];
    self.infoModel.nickname = userInfo.showName;
    BOOL isMySelf = [self.imAccount isEqualToString:[[[WTAccountManager sharedManager] currentUser] tel]];
    NSArray *dataArray = [WTUserHomeCellModel obtainAdviserHomeCellModelsWithUserInfoModel:self.infoModel isMySelf:isMySelf];
    [self.homeTableView refreshData:dataArray];
}

#pragma mark - Getter Cycle
- (WTAdviserHomeTableView *)homeTableView
{
    if (!_homeTableView)
    {
        _homeTableView = [[WTAdviserHomeTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _homeTableView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
    }
    return _homeTableView;
}

- (WTHomeToolBar *)toolBar
{
    if (!_toolBar)
    {
        _toolBar = [WTHomeToolBar homeToolBar];
    }
    return _toolBar;
}

@end
