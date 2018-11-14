//
//  WTWebViewVC.m
//  wutong
//
//  Created by 魏欣宇 on 2018/7/30.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTWebViewVC.h"
#import "WTSessionListVC.h"
#import "WTSessionVC.h"
#import "WTSessionUtil.h"
#import "WTLoginVC.h"
#import "WTScanCodeVC.h"
#import "WTWebView.h"
#import "WTWebViewConfiguration.h"
#import "WTScriptMessageHandler.h"
#import "WTLoginAPI.h"
#import "WTAccountAPI.h"
#import "WTUploadImageAPI.h"
#import "WTShareGoodsModel.h"
#import "WTShareManager.h"
#import "WTFriendsAPI.h"
#import "WTPayModel.h"
#import "WTContactAccountModel.h"
#import <TZImagePickerController.h>
#import <CoreLocation/CoreLocation.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiObject.h"
#import "WXApi.h"

#import "WTFriendsListVC.h"

@interface WTWebViewVC () <WKNavigationDelegate, WKUIDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NIMLoginManagerDelegate, NIMConversationManagerDelegate>

@property (nonatomic, strong) WTWebView *webView;

@property (nonatomic, strong) WTScriptMessageHandler *scriptMessageHandler;

@property (nonatomic, strong) WTBaseNavigationController *sessionListNav;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLLocation *currentLocation;

//@property (nonatomic, assign) BOOL isLocation;

@property (nonatomic,assign) NSInteger totalUnreadCount;

@end

@implementation WTWebViewVC

#pragma mark - NIMLoginManagerDelegate代理方法
/**
 IM登录状态监听方法
 */
- (void)onLogin:(NIMLoginStep)step
{
    switch (step) {
        case NIMLoginStepLoginOK:
            [self loginSuccess];
            break;
        case NIMLoginStepLoginFailed:
        {
            WTAlertManager *alertManager = [[WTAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:nil message:@"登录失败，请重新登录"];
            [alertManager cancelActionWithTitle:nil destructiveIndex:-2 otherTitle:@"确定", nil];
            [alertManager showAlertFromController:self actionBlock:^(NSInteger actionIndex) {
                switch (actionIndex) {
                    case 0:
                    {
                        [self cleanLocalData];
                        [self presentLoginVC];
                    }
                        break;
                        
                    default:
                        break;
                }
            }];
        }
            
        default:
            break;
    }
}

/**
 登录成功后获取最新用户信息
 */
- (void)loginSuccess
{
    if ([[[WTAccountManager sharedManager] token] length])
    {
        [WTAccountAPI obtainAccountInfoWithId:[[[WTAccountManager sharedManager] currentUser] uid] resultBlock:^(NSDictionary *object) {
            if ([object[@"code"] integerValue] == 200)
            {
                WTUser *currentUser = [WTUser mj_objectWithKeyValues:object[@"data"]];
                [[WTAccountManager sharedManager] setCurrentUser:currentUser];
                
                if ([[[WTAccountManager sharedManager] currentUser] userType] != 1 && [[[WTAccountManager sharedManager] currentUser] lastShopId] != 0)
                {
                    NSString *targetStr = [NSString stringWithFormat:@"%@?shopId=%@&shopName=%@", Web_URL, [[[WTAccountManager sharedManager] currentUser] lastShopId] == 0 ? @"null" : [NSString stringWithFormat:@"%ld", (long)[[[WTAccountManager sharedManager] currentUser] lastShopId]], [[[WTAccountManager sharedManager] currentUser] lastShopName]];
                    targetStr = [targetStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:targetStr]]];
                }
                
                if ([[[WTAccountManager sharedManager] currentUser] userType] == 1)
                {
                    NSString *targetStr = [NSString stringWithFormat:@"%@?shopId=%@&shopName=%@", Web_URL, [[[WTAccountManager sharedManager] currentUser] shopId] == 0 ? @"null" : [NSString stringWithFormat:@"%ld", (long)[[[WTAccountManager sharedManager] currentUser] shopId]], [[[WTAccountManager sharedManager] currentUser] shopName]];
                    targetStr = [targetStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:targetStr]]];
                }
            }
            else if ([object[@"code"] integerValue] == 4026)
            {
                [self presentLoginVC];
            }
        }];
        if ([[[WTAccountManager sharedManager] currentUser] lastShopId] == 0)
        {
            [self obtainLocation];
        }
    }
}

#pragma mark - Life Cycle
- (void)dealloc
{
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[WTNotificationCenter defaultCenter] wtRemoveObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setStatusBarBackgroundColor:[UIColor wtWhiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", BASE_URL);
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    
    self.totalUnreadCount = [NIMSDK sharedSDK].conversationManager.allUnreadCount;
    
    if ([[[WTAccountManager sharedManager] currentUser] lastShopId] == 0)
    {
        [self obtainLocation];
    }
    
    [self addObserves];
    [self configSubViews];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(onTapAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTapAction
{
    WTFriendsListVC *friendsListVC = [[WTFriendsListVC alloc] init];
    WTBaseNavigationController *friendsListNav = [[WTBaseNavigationController alloc] initWithRootViewController:friendsListVC];
    [self presentViewController:friendsListNav animated:YES completion:nil];
}

#pragma mark - Private Cycle
- (void)setStatusBarBackgroundColor:(UIColor *)color
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)])
    {
        statusBar.backgroundColor = color;
    }
}


- (void)configSubViews
{
    [self.view addSubview:self.webView];
    
    WTSessionListVC *sessionListVC = [[WTSessionListVC alloc] init];
    sessionListVC.title = @"消息";
    self.sessionListNav = [[WTBaseNavigationController alloc] initWithRootViewController:sessionListVC];
    self.sessionListNav.view.hidden = YES;
    self.sessionListNav.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, WTIsiPhoneX ? SCREEN_HEIGHT - 49 - 34 : SCREEN_HEIGHT - 49);
    [self addChildViewController:self.sessionListNav];
    [self.view addSubview:self.sessionListNav.view];
}

- (void)addObserves
{
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(tapForegroundNotification) name:WTForegroundNotification object:nil];
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(tapBackgroundNotification) name:UMBackgroundNotification object:nil];
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(tapSchemesNotification:) name:URLSchemesNotification object:nil];
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(cleanLocalData) name:CleanLocalDataNotification object:nil];
    
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(tokenInvalid) name:TokenInvalidNotification object:nil];
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(logOut) name:LogOutNotification object:nil];
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(hideSession:) name:HideSessionNotification object:nil];
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(shareGoodsInfo:) name:ShareGoodsInfoNotification object:nil];
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(getCamera) name:GetCameraNotification object:nil];
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(pay:) name:PayNotification object:nil];
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(completePayment:) name:CompletePaymentNotification object:nil];
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(openPhotoLibrary) name:UploadImgNotification object:nil];
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(contactAdviser:) name:ContactAdviserNotification object:nil];
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(contactAdviser:) name:ContactBuyerNotification object:nil];
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(feedBack:) name:LatestFeedbackNotification object:nil];
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(uploadAvator) name:UploadAvatorNotification object:nil];
}

- (void)cleanLocalData
{
    [[WTAccountManager sharedManager] setCurrentUser:nil];
    [[WTAccountManager sharedManager] setToken:nil];
    [self.webView evaluateJavaScript:@"localStorage.removeItem(\"userType\")" completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        NSLog(@"-----%@", error);
    }];
    [self.webView evaluateJavaScript:@"localStorage.removeItem(\"token\")" completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        NSLog(@"-----%@", error);
    }];
    [self.webView evaluateJavaScript:@"localStorage.removeItem(\"uid\")" completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        NSLog(@"-----%@", error);
    }];
    [self.webView evaluateJavaScript:@"localStorage.removeItem(\"tel\")" completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        NSLog(@"-----%@", error);
    }];
}

- (void)presentLoginVC
{
    WTLoginVC *loginVC = [[WTLoginVC alloc] init];
    WTBaseNavigationController *loginNav = [[WTBaseNavigationController alloc] initWithRootViewController:loginVC];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginNav animated:YES completion:nil];
}



#pragma mark - Observe Cycle
- (void)tapForegroundNotification
{
//    [self obtainLocation];
}

- (void)tapBackgroundNotification
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[Web_URL stringByAppendingString:@"/message"]]]];
}

- (void)tapSchemesNotification:(NSNotification *)notification
{
    NSString *result = notification.object;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[result stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]]];
}

- (void)tokenInvalid
{
    [[[NIMSDK sharedSDK] loginManager] logout:nil];
    [self presentLoginVC];
}

- (void)logOut
{
    WTAlertManager *alertManager = [[WTAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:nil message:@"确定退出当前账号？"];
    [alertManager cancelActionWithTitle:@"取消" destructiveIndex:-2 otherTitle:@"确定", nil];
    [alertManager showAlertFromController:self actionBlock:^(NSInteger actionIndex) {
        switch (actionIndex) {
            case 0:
                [[[NIMSDK sharedSDK] loginManager] logout:nil];
                [self cleanLocalData];
                [self presentLoginVC];
                [self obtainLocation];
                break;
                
            default:
                break;
        }
    }];
}

- (void)hideSession:(NSNotification *)notification
{
    BOOL isHiden = [notification.object boolValue];
    if (isHiden)
    {
        self.sessionListNav.view.hidden = YES;
    }
    else
    {
        if ([[[WTAccountManager sharedManager] token] length])
        {
            self.sessionListNav.view.hidden = NO;
        }
        else
        {
            [self presentLoginVC];
        }
    }
}

- (void)shareGoodsInfo:(NSNotification *)notification
{
    WTShareGoodsModel *goodsModel = (WTShareGoodsModel *)notification.object;
    [WTShareManager wtShareWithTitle:goodsModel.title description:goodsModel.des thuImage:goodsModel.thunImage webURL:goodsModel.webURL completion:nil];
}

- (void)getCamera
{
    [WTAuthorityManager obtainVideoAuthority:^(BOOL isAllow, NSString *prompt) {
        if (isAllow)
        {
            WTScanCodeVC *scanCodeVC = [[WTScanCodeVC alloc] init];
            WTBaseNavigationController *scanCodeNav = [[WTBaseNavigationController alloc] initWithRootViewController:scanCodeVC];
            [self presentViewController:scanCodeNav animated:YES completion:nil];
            scanCodeVC.codeCompleteBlock = ^(NSString *url) {
                if (self.sessionListNav.view.hidden == NO)
                {
                    self.sessionListNav.view.hidden = YES;
                }
                NSString *resultUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[resultUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]]];
            };
        }
        else
        {
            WTAlertManager *alertManager = [[WTAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:nil message:prompt];
            [alertManager cancelActionWithTitle:@"确定" destructiveIndex:-2 otherTitle:nil];
            [alertManager showAlertFromController:self actionBlock:nil];
        }
    }];

}

- (void)pay:(NSNotification *)notification
{
    WTPayModel *payModel = (WTPayModel *)notification.object;
    switch (payModel.payType) {
        case 1://微信支付
        {
            if ([WXApi isWXAppInstalled])
            {
                NSDictionary *wxDict = [NSDictionary dictWithJsonStr:payModel.orderStr];
                NSLog(@"%@", wxDict);
                PayReq *payRequest = [[PayReq alloc] init];
                payRequest.partnerId = [wxDict[@"partnerid"] stringValue];
                payRequest.prepayId = [wxDict[@"prepayid"] stringValue];
                payRequest.package = wxDict[@"package"];
                payRequest.nonceStr = [wxDict[@"noncestr"] stringValue];
                payRequest.timeStamp = [[wxDict[@"timestamp"] stringValue] intValue];
                payRequest.sign = [wxDict[@"sign"] stringValue];
                [WXApi sendReq:payRequest];
            }
            else
            {
                [WTProgressHUD showProgressInView:self.view message:@"请检查是否安装微信客户端"];
            }
        }
            break;
        case 2://支付宝
        {
            [[AlipaySDK defaultService] payOrder:payModel.orderStr fromScheme:@"wutongAlipay" callback:^(NSDictionary *resultDic) {
                NSLog(@"%@", resultDic);
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
            break;
            
        default:
            break;
    }
}

- (void)completePayment:(NSNotification *)notification
{
    NSInteger status = [notification.object integerValue];
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"payResult(\"%ld\")", (long)status] completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        NSLog(@"-----%@", error);
    }];
}

- (void)openPhotoLibrary
{
    TZImagePickerController *photoPicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    photoPicker.allowTakeVideo = NO;
    photoPicker.allowTakePicture = NO;
    photoPicker.naviTitleColor = [UIColor wtBlackColor];
    photoPicker.barItemTextColor = [UIColor wtBlackColor];
    [photoPicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [self uploadImage:photos[0] isAvator:NO];
    }];
    [self presentViewController:photoPicker animated:YES completion:nil];
}

- (void)uploadAvator
{
    WTAlertManager *alertManager = [[WTAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleActionSheet title:nil message:nil];
    [alertManager cancelActionWithTitle:@"取消" destructiveIndex:-2 otherTitle:@"相册", @"拍照", nil];
    [alertManager showAlertFromController:self actionBlock:^(NSInteger actionIndex) {
        switch (actionIndex) {
            case 0:
            {
                TZImagePickerController *photoPicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
                photoPicker.allowTakeVideo = NO;
                photoPicker.allowTakePicture = NO;
                photoPicker.naviTitleColor = [UIColor wtBlackColor];
                photoPicker.barItemTextColor = [UIColor wtBlackColor];
                [photoPicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                    [self uploadImage:photos[0] isAvator:YES];
                }];
                [self presentViewController:photoPicker animated:YES completion:nil];
            }
                break;
            case 1:
            {
                UIImagePickerController *pickerCon = [[UIImagePickerController alloc]init];
                pickerCon.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickerCon.allowsEditing = NO;//是否可编辑
                pickerCon.delegate = self;
                [self presentViewController:pickerCon animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
    }];
}

- (void)contactAdviser:(NSNotification *)notification
{
    WTContactAccountModel *contactAccountModel = (WTContactAccountModel *)notification.object;
    if (![contactAccountModel.tel isEqualToString:[[[WTAccountManager sharedManager] currentUser] tel]])
    {
        [WTFriendsAPI addFriendWithUid:contactAccountModel.uid phone:contactAccountModel.tel friendsBlock:^(NSString *imAccount, NSInteger isFirst, NSError * _Nullable error) {
            if (!error)
            {
                NIMSession *session = [NIMSession session:contactAccountModel.tel type:NIMSessionTypeP2P];
                if (isFirst == 1)
                {
                    NIMMessage *tip = [WTSessionUtil configTipMessage:@"你们已建立联系，可以畅快聊天了"];
                    [[NIMSDK sharedSDK].conversationManager saveMessage:tip forSession:session completion:nil];
                }
                WTSessionVC *sessionVC = [[WTSessionVC alloc] initWithSession:session];
                WTBaseNavigationController *sessionNav = [[WTBaseNavigationController alloc] initWithRootViewController:sessionVC];
                [self presentViewController:sessionNav animated:YES completion:nil];
            }
            else
            {
                [WTProgressHUD showProgressInView:self.view message:@"出错了，请稍后再试"];
            }
        }];
    }
    else
    {
        [WTProgressHUD showProgressInView:self.view message:@"不能向自己咨询哦"];
    }
}

- (void)feedBack:(NSNotification *)notification
{
    NSString *tel = notification.object;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", tel]]];
}

#pragma mark - Private Cycle
/**
 判断位置权限及开始定位
 */
- (void)obtainLocation
{
    [WTAuthorityManager obtainLocationAuthority:^(BOOL isAllow, NSString *prompt) {
        if (isAllow)
        {
            [self.locationManager startUpdatingLocation];
        }
        else
        {
            WTAlertManager *alertManager = [[WTAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:nil message:prompt];
            [alertManager cancelActionWithTitle:@"确定" destructiveIndex:-2 otherTitle:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [alertManager showAlertFromController:self actionBlock:nil];
            });
            [self uploadLocation];
        }
    }];
}

/**
 上传地理位置
 */
- (void)uploadLocation
{
    NSString *latiudeStr = self.currentLocation.coordinate.latitude == 0 ? @"" : [NSString stringWithFormat:@"%f", self.currentLocation.coordinate.latitude];
    NSString *longitudeStr = self.currentLocation.coordinate.longitude == 0 ? @"" : [NSString stringWithFormat:@"%f", self.currentLocation.coordinate.longitude];
    [WTLoginAPI uploadLoactionWithLatitude:latiudeStr longitude:longitudeStr resultBlock:^(NSDictionary *object) {
        if ([object[@"code"] integerValue] == 200)
        {
            NSInteger shopID = [object[@"data"][@"id"] integerValue];
            NSString *shopName = object[@"data"][@"shopName"];
            NSString *targetStr = [NSString stringWithFormat:@"%@?shopId=%@&shopName=%@", Web_URL, shopID == 0 ? @"null" : [NSString stringWithFormat:@"%ld", (long)shopID], shopName];
            targetStr = [targetStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:targetStr]]];
        }
        else if ([object[@"code"] integerValue] == 4026)
        {
           [self presentLoginVC];
        }
    }];
}

- (void)uploadImage:(UIImage *)picture isAvator:(BOOL)isAvator
{
    [WTUploadImageAPI uploadImage:picture resultBlock:^(NSDictionary *object) {
        if ([object[@"code"] integerValue] == 200)
        {
            if (isAvator)
            {
                [self.webView evaluateJavaScript:[NSString stringWithFormat:@"getAvatorData(\"%@\")", object[@"data"]] completionHandler:^(id _Nullable object, NSError * _Nullable error) {
                    NSLog(@"-----%@", error);
                }];
            }
            else
            {
                [self.webView evaluateJavaScript:[NSString stringWithFormat:@"getUploadImgData(\"%@\")", object[@"data"]] completionHandler:^(id _Nullable object, NSError * _Nullable error) {
                    NSLog(@"-----%@", error);
                }];
            }
        }
        else
        {
            [WTProgressHUD showProgressInView:self.view message:object[@"message"]];
        }
    }];
}

#pragma mark - CLLocationManagerDelegate代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self.locationManager stopUpdatingLocation];
    self.currentLocation = [locations lastObject];
    
    [self uploadLocation];
}

#pragma mark - WKNavigationDelegate代理方法
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"页面开始加载......");
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"页面内容开始返回......");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"页面内容加载完成......");
    
    if ([[WTAccountManager sharedManager] currentUser])
    {
        [self.webView evaluateJavaScript:[NSString stringWithFormat:@"localStorage.setItem(\"userType\",  \"%ld\")", (long)[[[WTAccountManager sharedManager] currentUser] userType]] completionHandler:^(id _Nullable object, NSError * _Nullable error) {
            NSLog(@"-----%@", error);
        }];
        [self.webView evaluateJavaScript:[NSString stringWithFormat:@"localStorage.setItem(\"token\", \"%@\")", [[WTAccountManager sharedManager] token]] completionHandler:^(id _Nullable object, NSError * _Nullable error) {
            NSLog(@"-----%@", error);
        }];
        [self.webView evaluateJavaScript:[NSString stringWithFormat:@"localStorage.setItem(\"uid\", \"%@\")", [[[WTAccountManager sharedManager] currentUser] uid]] completionHandler:^(id _Nullable object, NSError * _Nullable error) {
            NSLog(@"-----%@", error);
        }];
        [self.webView evaluateJavaScript:[NSString stringWithFormat:@"localStorage.setItem(\"tel\", \"%@\")", [[[WTAccountManager sharedManager] currentUser] tel]] completionHandler:^(id _Nullable object, NSError * _Nullable error) {
            NSLog(@"-----%@", error);
        }];
    }
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *releaseVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    [webView evaluateJavaScript:[NSString stringWithFormat:@"getVersionNumber(\"%@\")", releaseVersion] completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        NSLog(@"-----%@", error);
    }];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"页面返回错误......");
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"页面重定向......");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - WKUIDelegate代理方法
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    completionHandler(true);
    NSLog(@"%@", message);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler
{
    NSLog(@"%@", prompt);
}

#pragma mark - UIImagePickerControllerDelegate代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
        [self uploadImage:image isAvator:YES];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NIMConversationManagerDelegate代理方法
- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount
{
    self.totalUnreadCount = totalUnreadCount;
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"getMessageNumber(\"%ld\")", (long)self.totalUnreadCount] completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        NSLog(@"-----%@", error);
    }];
}


- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount
{
    self.totalUnreadCount = totalUnreadCount;
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"getMessageNumber(\"%ld\")", (long)self.totalUnreadCount] completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        NSLog(@"-----%@", error);
    }];
}


- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount
{
    self.totalUnreadCount = totalUnreadCount;
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"getMessageNumber(\"%ld\")", (long)self.totalUnreadCount] completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        NSLog(@"-----%@", error);
    }];
}

- (void)messagesDeletedInSession:(NIMSession *)session
{
    self.totalUnreadCount = [NIMSDK sharedSDK].conversationManager.allUnreadCount;
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"getMessageNumber(\"%ld\")", (long)self.totalUnreadCount] completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        NSLog(@"-----%@", error);
    }];
}

- (void)allMessagesDeleted
{
    self.totalUnreadCount = 0;
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"getMessageNumber(\"%ld\")", (long)self.totalUnreadCount] completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        NSLog(@"-----%@", error);
    }];
}

- (void)allMessagesRead
{
    self.totalUnreadCount = 0;
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"getMessageNumber(\"%ld\")", (long)self.totalUnreadCount] completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        NSLog(@"-----%@", error);
    }];
}

#pragma mark - Getter Cycle
- (WTScriptMessageHandler *)scriptMessageHandler
{
    if (!_scriptMessageHandler)
    {
        _scriptMessageHandler = [[WTScriptMessageHandler alloc] init];
    }
    return _scriptMessageHandler;
}

- (WTWebView *)webView
{
    if (!_webView)
    {
        WTWebViewConfiguration *configuration = [[WTWebViewConfiguration alloc] init];
        WKUserContentController *userContentViewController = [[WKUserContentController alloc] init];
        [userContentViewController addScriptMessageHandler:self.scriptMessageHandler name:@"WKMesesgaSignal"];
        configuration.userContentController = userContentViewController;
        
        _webView = [[WTWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 5.0;
    }
    return _locationManager;
}

@end
