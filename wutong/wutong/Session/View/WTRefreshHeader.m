//
//  WTRefreshHeader.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTRefreshHeader.h"

@interface WTRefreshHeader ()

@property (nonatomic, strong) UIActivityIndicatorView *refreshActivity;

@end

@implementation WTRefreshHeader

#pragma mark - Life Cycle
- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _refreshActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _refreshActivity.frame = CGRectMake((CGRectGetWidth(frame) - 20) * 0.5, 10, 20, 20);
        [self addSubview:_refreshActivity];
    }
    return self;
}

#pragma mark - Public Cycle
- (void)startAnimating
{
    [self.refreshActivity startAnimating];
}

- (void)stopAnimating
{
    [self.refreshActivity stopAnimating];
}

@end
