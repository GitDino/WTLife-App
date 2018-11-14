//
//  WTGuidePageVC.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/16.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTGuidePageVC.h"
#import "WTAdAPI.h"
#import "WTWebViewVC.h"
#import <CoreLocation/CoreLocation.h>

@interface WTGuidePageVC () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *launchScrollView;

@property (nonatomic, strong) UIButton *enterBtn;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation WTGuidePageVC

#pragma mark - Life Cycle
- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor wtWhiteColor];
    
    [self.locationManager requestWhenInUseAuthorization];
    
    [self obtainAdData];
}

#pragma mark - Private Cycle
- (void)obtainAdData
{
    [WTAdAPI obtainAdDataWithResultBlock:^(NSDictionary *object) {
        NSLog(@"%@", object);
        if ([object[@"code"] integerValue] == 200)
        {
            [self configAboutUIWithImageUrl:object[@"data"][@"cover"]];
        }
    }];
}

- (void)configAboutUIWithImageUrl:(NSString *)url
{
    [self.view addSubview:self.launchScrollView];
    self.launchScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    UIImageView *adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 120)];
    adImageView.userInteractionEnabled = YES;
    [adImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    [self.launchScrollView addSubview:adImageView];
    
    [self.view addSubview:self.enterBtn];
}

#pragma mark - Event Cycle
- (void)onTapEnter:(UIButton *)btn
{
    WTWebViewVC *webVC = [[WTWebViewVC alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = webVC;
}

#pragma mark - Getter Cycle
- (UIScrollView *)launchScrollView
{
    if (!_launchScrollView)
    {
        _launchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _launchScrollView.showsHorizontalScrollIndicator = NO;
        _launchScrollView.bounces = NO;
        _launchScrollView.pagingEnabled = YES;
        _launchScrollView.delegate = self;
    }
    return _launchScrollView;
}

- (UIButton *)enterBtn
{
    if (!_enterBtn)
    {
        _enterBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, SCREEN_HEIGHT - 80, 150, 40)];
        _enterBtn.layer.cornerRadius = 20;
        _enterBtn.layer.borderColor = [UIColor wtAppColor].CGColor;
        _enterBtn.layer.borderWidth = 1.0;
        _enterBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_enterBtn setTitleColor:[UIColor wtAppColor] forState:UIControlStateNormal];
        [_enterBtn setTitleColor:[UIColor wtAppColor] forState:UIControlStateNormal];
        [_enterBtn setTitle:@"立即体验" forState:UIControlStateNormal];
        [_enterBtn addTarget:self action:@selector(onTapEnter:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterBtn;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

@end
