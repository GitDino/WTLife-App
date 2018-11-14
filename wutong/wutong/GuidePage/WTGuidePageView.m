//
//  WTGuidePageView.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/13.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTGuidePageView.h"
#import "WTAdAPI.h"

@interface WTGuidePageView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *launchScrollView;

@property (nonatomic, strong) UIButton *enterBtn;

@property (nonatomic, strong) NSArray *images;

@end

@implementation WTGuidePageView

#pragma mark - Life Cycle
- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor wtWhiteColor];
        
        [self obtainAdData];
    }
    return self;
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
    [self addSubview:self.launchScrollView];
    self.launchScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    UIImageView *adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 120)];
    adImageView.userInteractionEnabled = YES;
    [adImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    [self.launchScrollView addSubview:adImageView];
    
    [self addSubview:self.enterBtn];
}

- (void)hideGuideView
{
    //动画隐藏
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        //延迟0.5秒移除
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }];
}

#pragma mark - Event Cycle
- (void)onTapEnter:(UIButton *)btn
{
    [self hideGuideView];
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

@end
