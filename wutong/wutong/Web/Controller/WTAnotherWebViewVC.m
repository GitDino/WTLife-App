//
//  WTAnotherWebViewVC.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/13.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTAnotherWebViewVC.h"
#import "WTWebView.h"
#import "WTWebViewConfiguration.h"
#import "WTScriptMessageHandler.h"

@interface WTAnotherWebViewVC () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WTWebView *webView;

@property (nonatomic, strong) WTScriptMessageHandler *scriptMessageHandler;

@end

@implementation WTAnotherWebViewVC

#pragma mark - Life Cycle
- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setStatusBarBackgroundColor:[UIColor wtWhiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor wtWhiteColor];
    
    [[WTNotificationCenter defaultCenter] wtAddObserver:self selector:@selector(onTapWebBack) name:BackButtonNotification object:nil];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/useragreement", Web_URL]]]];
    [self.view addSubview:self.webView];
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

#pragma mark - Observe Cycle
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
