//
//  WTLoginVC.m
//  wutong
//
//  Created by 魏欣宇 on 2018/7/29.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTLoginVC.h"
#import "WTWebViewVC.h"
#import "WTLoginAPI.h"
#import "WTAnotherWebViewVC.h"

@interface WTLoginVC () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *whiteBackView;
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UITextField *phoneNumberTextField;
@property (nonatomic, strong) UITextField *verifyCodeTextField;
@property (nonatomic, strong) UIButton *obtainCodeBtn;

@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) UIButton *agreementBtn;

/**
 验证码相关定时器
 */
@property (nonatomic, strong) NSTimer *verifyTimer;

@property (nonatomic, assign) NSInteger maxSeconds;

@end

@implementation WTLoginVC

#pragma mark - Life Cycle
- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
    [self closeTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor wtLightGrayColor];
    self.maxSeconds = 60;
    
    [self configSubViews];
    [self configNav];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Private Cycle
- (void)configSubViews
{
    [self.view addSubview:self.whiteBackView];
    [self.view addSubview:self.iconImageView];
    
    [self.view addSubview:self.phoneNumberTextField];
    [self.view addSubview:self.verifyCodeTextField];
    [self.view addSubview:self.obtainCodeBtn];
    
    [self.view addSubview:self.loginBtn];
    
    [self.view addSubview:self.agreementBtn];
}

- (void)configNav
{
    self.navigationController.navigationBar.tintColor = [UIColor wtBlackColor];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)leftBarButtonItemAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 开启定时器
 */
- (void)startTimer
{
    self.verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

/**
 关闭定时器
 */
- (void)closeTimer
{
    if (self.verifyTimer.isValid)
    {
        [self.verifyTimer invalidate];
        self.verifyTimer = nil;
    }
}

/**
 倒计时
 */
- (void)countDown
{
    self.maxSeconds -- ;
    [self.obtainCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%zd)", self.maxSeconds] forState:UIControlStateNormal];
    if (self.maxSeconds == 0)
    {
        [self closeTimer];
        self.maxSeconds = 60;
        self.obtainCodeBtn.userInteractionEnabled = YES;
        self.obtainCodeBtn.backgroundColor = [UIColor wtAppColor];
        [self.obtainCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    }
}

#pragma mark - UITextFieldDelegate代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneNumberTextField && textField.text.length < 11)
    {
        return YES;
    }
    if (textField == self.verifyCodeTextField && textField.text.length < 4)
    {
        return YES;
    }
    if ([string isEqualToString:@""])
    {
        return YES;
    }
    return NO;
}

#pragma mark - Event Cyle
/**
 监听输入框事件
 */
- (void)textFieldDidChange:(UITextField *)textField
{
    if (self.phoneNumberTextField.text.length == 11 && self.verifyCodeTextField.text.length == 4)
    {
        self.loginBtn.userInteractionEnabled = YES;
        self.loginBtn.backgroundColor = [UIColor wtAppColor];
    }
    else
    {
        self.loginBtn.userInteractionEnabled = NO;
        self.loginBtn.backgroundColor = [UIColor wtGrayColor];
    }
}

/**
 登录事件
 */
- (void)onTapLoginAction
{
    [self.view endEditing:YES];
    [WTProgressHUD showHUDInView:self.view];
    [WTLoginAPI loginAppWithPhone:self.phoneNumberTextField.text code:self.verifyCodeTextField.text resultBlock:^(NSDictionary *object) {
        [WTProgressHUD hideHUDForView:self.view];
        if ([object[@"code"] integerValue] == 200)
        {
            [[WTAccountManager sharedManager] setToken:object[@"data"][@"token"]];
            WTUser *currentUser = [WTUser mj_objectWithKeyValues:object[@"data"]];
            [[[NIMSDK sharedSDK] loginManager] login:self.phoneNumberTextField.text token:currentUser.wytoken completion:^(NSError * _Nullable error) {
                if (!error)
                {
                    [[WTAccountManager sharedManager] setCurrentUser:currentUser];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    NSLog(@"-----IM登录失败%@", error);
                    WTAlertManager *alertManager = [[WTAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:@"登录失败" message:@"请稍后重试"];
                    [alertManager cancelActionWithTitle:@"确定" destructiveIndex:-2 otherTitle:nil];
                    [alertManager showAlertFromController:self actionBlock:nil];
                }
            }];
            
            
        }
        else
        {
            [WTProgressHUD showProgressInView:self.view message:object[@"message"]];
        }
    }];
}

/**
 获取验证码事件
 */
- (void)onTapVerifyNumberAction
{
    [self.view endEditing:YES];
    if (self.phoneNumberTextField.text.length == 11)
    {
        [WTProgressHUD showHUDInView:self.view];
        [WTLoginAPI obtainVerifyCodeWithPhone:self.phoneNumberTextField.text resultBlock:^(NSDictionary *object) {
            [WTProgressHUD hideHUDForView:self.view];
            if ([object[@"code"] integerValue] == 200)
            {
                self.obtainCodeBtn.userInteractionEnabled = NO;
                self.obtainCodeBtn.backgroundColor = [UIColor wtGrayColor];
                [self startTimer];
                [self.obtainCodeBtn setTitle:@"重新获取(59)" forState:UIControlStateNormal];
            }
            else
            {
                [WTProgressHUD showProgressInView:self.view message:object[@"message"]];
            }
        }];
    }
    else
    {
        WTAlertManager *alertManager = [[WTAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:nil message:@"请检查您输入的手机号"];
        [alertManager cancelActionWithTitle:@"确定" destructiveIndex:-2 otherTitle:nil];
        [alertManager showAlertFromController:self actionBlock:nil];
    }
}

/**
 用户协议事件
 */
- (void)onTapAgreementAction
{
    [self.view endEditing:YES];
    WTAnotherWebViewVC *anotherWeb = [[WTAnotherWebViewVC alloc] init];
    [self presentViewController:anotherWeb animated:NO completion:nil];
}

#pragma mark - Getter Cycle
- (UIView *)whiteBackView
{
    if (!_whiteBackView)
    {
        _whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _whiteBackView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBackView;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView)
    {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) * 0.5, 0, 100, 68)];
        _iconImageView.image = [UIImage imageNamed:@"icon_login_logo"];
    }
    return _iconImageView;
}

- (UITextField *)phoneNumberTextField
{
    if (!_phoneNumberTextField)
    {
        _phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(self.whiteBackView.frame) + 34, SCREEN_WIDTH - 80, 48)];
        _phoneNumberTextField.delegate = self;
        _phoneNumberTextField.backgroundColor = [UIColor wtWhiteColor];
        _phoneNumberTextField.font = [UIFont systemFontOfSize:14];
        _phoneNumberTextField.placeholder = @"请输入手机号：";
        _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumberTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_login_phoneNumber"]];
        _phoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
        [_phoneNumberTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _phoneNumberTextField;
}

- (UITextField *)verifyCodeTextField
{
    if (!_verifyCodeTextField)
    {
        _verifyCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(self.phoneNumberTextField.frame) + 8, CGRectGetWidth(self.phoneNumberTextField.frame) - 114, 48)];
        _verifyCodeTextField.delegate = self;
        _verifyCodeTextField.backgroundColor = [UIColor wtWhiteColor];
        _verifyCodeTextField.font = [UIFont systemFontOfSize:14];
        _verifyCodeTextField.placeholder = @"请输入验证码：";
        _verifyCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _verifyCodeTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_login_code"]];
        _verifyCodeTextField.leftViewMode = UITextFieldViewModeAlways;
        [_verifyCodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _verifyCodeTextField;
}

- (UIButton *)obtainCodeBtn
{
    if (!_obtainCodeBtn)
    {
        _obtainCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.verifyCodeTextField.frame) + 12, CGRectGetMinY(self.verifyCodeTextField.frame) + 4, 102, 40)];
        _obtainCodeBtn.backgroundColor = [UIColor wtAppColor];
        _obtainCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_obtainCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        [_obtainCodeBtn addTarget:self action:@selector(onTapVerifyNumberAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _obtainCodeBtn;
}

- (UIButton *)loginBtn
{
    if (!_loginBtn)
    {
        _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(self.verifyCodeTextField.frame) + 34, SCREEN_WIDTH - 80, 48)];
        _loginBtn.backgroundColor = [UIColor wtGrayColor];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        
        [_loginBtn addTarget:self action:@selector(onTapLoginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)agreementBtn
{
    if (!_agreementBtn)
    {
        _agreementBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 190) * 0.5, CGRectGetMaxY(_loginBtn.frame) + 12, 190, 20)];
        
        NSString *titleStr = @"登录即同意《吾同用户协议》";
        NSMutableAttributedString *titleAttri = [[NSMutableAttributedString alloc] initWithString:titleStr];
        [titleAttri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, titleStr.length)];
        [titleAttri addAttribute:NSForegroundColorAttributeName value:[UIColor wtBlackColor] range:NSMakeRange(0, 5)];
        [titleAttri addAttribute:NSForegroundColorAttributeName value:[UIColor wtAppColor] range:NSMakeRange(5, titleStr.length - 5)];
        [_agreementBtn setAttributedTitle:titleAttri forState:UIControlStateNormal];
        
        [_agreementBtn addTarget:self action:@selector(onTapAgreementAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreementBtn;
}

@end
