//
//  WTChatCustomWebViewVC.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTChatCustomWebViewVC.h"
#import "WTLoginVC.h"
#import "WTSessionVC.h"
#import "WTSessionUtil.h"
#import "WTWebView.h"
#import "WTWebViewConfiguration.h"
#import "WTScriptMessageHandler.h"
#import "WTChatGoodsModel.h"
#import "WTChatOrderModel.h"
#import "WTShareGoodsModel.h"
#import "WTShareManager.h"
#import "WTPayModel.h"
#import "WTFriendsAPI.h"
#import "WTContactAccountModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiObject.h"
#import "WXApi.h"

@interface WTChatCustomWebViewVC () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WTWebView *webView;

@property (nonatomic, strong) WTScriptMessageHandler *scriptMessageHandler;

@end

@implementation WTChatCustomWebViewVC

#pragma mark - Life Cycle
- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
    [[WTNotificationCenter defaultCenter] wtRemoveObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setStatusBarBackgroundColor:[UIColor wtWhiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]]];
    [self.view addSubview:self.webView];
    
    [self addObservers];
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

- (void)addObservers
{
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(tokenInvalid) name:TokenInvalidNotification object:nil];
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(shareGoodsInfo:) name:ShareGoodsInfoNotification object:nil];
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(pay:) name:PayNotification object:nil];
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(completePayment:) name:CompletePaymentNotification object:nil];
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(contactAdviser:) name:ContactAdviserNotification object:nil];
    
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(sendGood:) name:SendGoodNotification object:nil];
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(sendOrder:) name:SendOrderNotification object:nil];
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(onTapWebBack) name:BackButtonNotification object:nil];
}

- (void)presentLoginVC
{
    WTLoginVC *loginVC = [[WTLoginVC alloc] init];
    WTBaseNavigationController *loginNav = [[WTBaseNavigationController alloc] initWithRootViewController:loginVC];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginNav animated:YES completion:nil];
}

#pragma mark - Observe Cycle
- (void)tokenInvalid
{
    [[[NIMSDK sharedSDK] loginManager] logout:nil];
    [self presentLoginVC];
}

- (void)shareGoodsInfo:(NSNotification *)notification
{
    WTShareGoodsModel *goodsModel = (WTShareGoodsModel *)notification.object;
    [WTShareManager wtShareWithTitle:goodsModel.title description:goodsModel.des thuImage:goodsModel.thunImage webURL:goodsModel.webURL completion:nil];
}

- (void)sendGood:(NSNotification *)notification
{
    WTChatGoodsModel *goodsModel = (WTChatGoodsModel *)notification.object;
    if (self.sendCompleteBlock)
    {
        self.sendCompleteBlock(goodsModel);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"payResult(\"%zd\")", status] completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        NSLog(@"-----%@", error);
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

- (void)sendOrder:(NSNotification *)notification
{
    WTChatOrderModel *orderModel = (WTChatOrderModel *)notification.object;
    if (self.sendCompleteBlock)
    {
        self.sendCompleteBlock(orderModel);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTapWebBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
