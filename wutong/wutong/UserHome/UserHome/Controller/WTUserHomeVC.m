//
//  WTUserHomeVC.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/5.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTUserHomeVC.h"
#import "WTAboutUserConfigVC.h"
#import "WTUserHomeTableView.h"
#import "WTHomeToolBar.h"
#import "WTAccountAPI.h"
#import "WTTagAPI.h"
#import "WTUserInfoModel.h"
#import "WTUserPictureModel.h"
#import "WTUserOrderModel.h"
#import "WTUserHomeCellModel.h"
#import "WTTagModel.h"
#import "WTIMKit.h"

@interface WTUserHomeVC () <NIMUserManagerDelegate>

@property (nonatomic, strong) WTUserHomeTableView *homeTableView;

@property (nonatomic, strong) WTHomeToolBar *toolBar;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@property (nonatomic, strong) WTUserInfoModel *infoModel;

@property (nonatomic, strong) WTUserPictureModel *pictureModel;

@property (nonatomic, strong) NSArray *orderModelArray;

@property (nonatomic, strong) NSArray *sectionTagArray;

@end

@implementation WTUserHomeVC

#pragma mark - Life Cycle
- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"查看资料";
    [[NIMSDK sharedSDK].userManager addDelegate:self];
    
    [self configNav];
    [self configSubViews];
    [self configDispatch];
    [self configAboutBlock];
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

- (void)configDispatch
{
    self.semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        [self obtainUserInfo];
    });
    dispatch_group_async(group, queue, ^{
        [self obtainUserPicture];
    });
    dispatch_group_async(group, queue, ^{
        [self obtainUserOrders];
    });
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        NSArray *dataArray = [WTUserHomeCellModel obtainUserHomeCellModelsWithUserInfoModel:self.infoModel userPictureModel:self.pictureModel userOrderModelArray:self.orderModelArray functionTag:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.homeTableView.sectionTagArray = self.sectionTagArray;
            [self.homeTableView refreshData:dataArray];
        });
    });
}

- (void)obtainUserInfo
{
    __weak typeof(self) weakSelf = self;
    [WTAccountAPI obtainUserInfoWithId:self.uid resultBlock:^(NSDictionary *object) {
        NSLog(@"%@", object);
        if ([object[@"code"] integerValue] == 200)
        {
            weakSelf.infoModel = [WTUserInfoModel mj_objectWithKeyValues:object[@"data"]];
            NIMSession *session = [NIMSession session:weakSelf.imAccount type:NIMSessionTypeP2P];
            WTIMInfo *userInfo = [[WTIMKit sharedKit] infoByUser:weakSelf.imAccount session:session];
            weakSelf.infoModel.nickname = userInfo.showName;
        }
        else
        {
            [WTProgressHUD showProgressInView:self.view message:object[@"message"]];
        }
        dispatch_semaphore_signal(weakSelf.semaphore);
    }];
}

- (void)obtainUserPicture
{
    __weak typeof(self) weakSelf = self;
    [WTAccountAPI obtainUserPictureWithUid:self.uid resultBlock:^(NSDictionary *object) {
        NSLog(@"%@", object);
        if ([object[@"code"] integerValue] == 200)
        {
            weakSelf.pictureModel = [WTUserPictureModel mj_objectWithKeyValues:object[@"data"]];
        }
        else
        {
            [WTProgressHUD showProgressInView:self.view message:object[@"message"]];
        }
        dispatch_semaphore_signal(self.semaphore);
    }];
}

- (void)obtainUserOrders
{
    __weak typeof(self) weakSelf = self;
    [WTAccountAPI obtainUserOrderWithUid:self.uid resultBlock:^(NSDictionary *object) {
        NSLog(@"%@", object);
        if ([object[@"code"] integerValue] == 200)
        {
            weakSelf.orderModelArray = [WTUserOrderModel mj_objectArrayWithKeyValuesArray:object[@"data"]];
        }
        else
        {
            [WTProgressHUD showProgressInView:self.view message:object[@"message"]];
        }
        dispatch_semaphore_signal(self.semaphore);
    }];
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
                    NSArray *dataArray = [WTUserHomeCellModel obtainUserHomeCellModelsWithUserInfoModel:weakSelf.infoModel userPictureModel:weakSelf.pictureModel userOrderModelArray:weakSelf.orderModelArray functionTag:1];
                    weakSelf.homeTableView.sectionTagArray = weakSelf.sectionTagArray;
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
    
    self.homeTableView.tapIndexFunctionBlock = ^(NSInteger functionTag) {
        NSArray *dataArray = [WTUserHomeCellModel obtainUserHomeCellModelsWithUserInfoModel:weakSelf.infoModel userPictureModel:weakSelf.pictureModel userOrderModelArray:weakSelf.orderModelArray functionTag:functionTag];
        [weakSelf.homeTableView refreshData:dataArray];
    };
    
    self.homeTableView.tapAddCustomTagBlock = ^{
        [weakSelf showAlertWithTextField];
    };
}

- (void)showAlertWithTextField
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入标签" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tagTextField = alertController.textFields.firstObject;
        [self addCustomTag:tagTextField.text];
    }]];
    [alertController addTextFieldWithConfigurationHandler:nil];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)addCustomTag:(NSString *)tagName
{
    [WTTagAPI addCustomTagName:tagName withUid:self.uid resultBlock:^(NSDictionary *object) {
        NSLog(@"%@", object);
        if ([object[@"code"] integerValue] == 200)
        {
            [self configDispatch];
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
    NSArray *dataArray = [WTUserHomeCellModel obtainUserHomeCellModelsWithUserInfoModel:self.infoModel userPictureModel:self.pictureModel userOrderModelArray:self.orderModelArray functionTag:1];
    self.homeTableView.sectionTagArray = self.sectionTagArray;
    [self.homeTableView refreshData:dataArray];
}

#pragma mark - Getter Cycle
- (WTUserHomeTableView *)homeTableView
{
    if (!_homeTableView)
    {
        _homeTableView = [[WTUserHomeTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
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

- (NSArray *)sectionTagArray
{
    if (!_sectionTagArray)
    {
        WTTagModel *tagModel1 = [[WTTagModel alloc] init];
        tagModel1.tagName = @"用户画像";
        tagModel1.selected = YES;
        
        WTTagModel *tagModel2 = [[WTTagModel alloc] init];
        tagModel2.tagName = @"历史订单";
        
        _sectionTagArray = @[tagModel1, tagModel2];
    }
    return _sectionTagArray;
}

@end
