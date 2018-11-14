//
//  WTAboutUserConfigVC.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/6.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTAboutUserConfigVC.h"
#import "WTFriendsAPI.h"

@interface WTAboutUserConfigVC ()

@property (nonatomic, strong) UILabel *aliasLabel;
@property (nonatomic, strong) UITextField *aliasTextField;

@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UITextField *phoneTextField;

@property (nonatomic, strong) NIMUser *imUser;

@end

@implementation WTAboutUserConfigVC

#pragma mark - Life Cycle
- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
    self.title = @"设置详情";
    
    _imUser = [[NIMSDK sharedSDK].userManager userInfo:self.imAccount];
    
    [self.view addSubview:self.aliasLabel];
    [self.view addSubview:self.aliasTextField];
    
    [self.view addSubview:self.phoneLabel];
    [self.view addSubview:self.phoneTextField];
    
    [self configNavBar];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Private Cycle
- (void)configNavBar
{
    self.navigationController.navigationBar.tintColor = [UIColor wtBlackColor];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - Event Cycle
- (void)leftBarButtonItemAction
{
    [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
}

- (void)rightBarButtonItemAction
{
    if (![NSString isBlankString:self.aliasTextField.text])
    {
        self.imUser.alias = self.aliasTextField.text;
        [[NIMSDK sharedSDK].userManager updateUser:self.imUser completion:^(NSError * _Nullable error) {
        }];
    }
    if (![NSString isBlankString:self.phoneTextField.text])
    {
        [self addAliasPhone];
    }
    if (self.popBlock)
    {
        self.popBlock(self.aliasTextField.text, self.phoneTextField.text);
    }
    [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
}

- (void)addAliasPhone
{
    [WTFriendsAPI addAliasPhone:self.phoneTextField.text toUid:self.uid resultBlock:^(NSDictionary *object) {
        NSLog(@"%@", object);
    }];
}

#pragma mark - Getter Cycle
- (UILabel *)aliasLabel
{
    if (!_aliasLabel)
    {
        _aliasLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 40)];
        _aliasLabel.font = [UIFont systemFontOfSize:15];
        _aliasLabel.textColor = [UIColor wtColorWithR:164 G:170 B:179 A:1.0];
        _aliasLabel.text = @"备注名";
    }
    return _aliasLabel;
}

- (UITextField *)aliasTextField
{
    if (!_aliasTextField)
    {
        _aliasTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 44)];
        _aliasTextField.font = [UIFont systemFontOfSize:14];
        UIView *margeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 44)];
        _aliasTextField.backgroundColor = [UIColor wtWhiteColor];
        _aliasTextField.leftView = margeView;
        _aliasTextField.leftViewMode = UITextFieldViewModeAlways;
        _aliasTextField.rightView = margeView;
        _aliasTextField.rightViewMode =UITextFieldViewModeAlways;
    }
    return _aliasTextField;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel)
    {
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 84, SCREEN_WIDTH - 20, 40)];
        _phoneLabel.font = [UIFont systemFontOfSize:15];
        _phoneLabel.textColor = [UIColor wtColorWithR:164 G:170 B:179 A:1.0];
        _phoneLabel.text = @"电话号码";
    }
    return _phoneLabel;
}

- (UITextField *)phoneTextField
{
    if (!_phoneTextField)
    {
        _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 124, SCREEN_WIDTH, 44)];
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        UIView *margeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 44)];
        _phoneTextField.font = [UIFont systemFontOfSize:14];
        _phoneTextField.backgroundColor = [UIColor wtWhiteColor];
        _phoneTextField.leftView = margeView;
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
        _phoneTextField.rightView = margeView;
        _phoneTextField.rightViewMode =UITextFieldViewModeAlways;
    }
    return _phoneTextField;
}

@end
