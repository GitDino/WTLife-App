//
//  WTChartletMessageContentView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/8.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTChartletMessageContentView.h"
#import "WTBubbleImageView.h"
#import "WTChartletModel.h"
#import "WTMessageModel.h"
#import <UIImage+IM.h>

@interface WTChartletMessageContentView () <WTBubbleImageViewDelegate>

@property (nonatomic, strong) WTBubbleImageView *chartletImageView;

@end

@implementation WTChartletMessageContentView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _chartletImageView = [[WTBubbleImageView alloc] init];
        _chartletImageView.delegate = self;
        [self addSubview:_chartletImageView];
    }
    return self;
}

#pragma mark - Setter Cycle
- (void)setChartletMessage:(WTMessageModel *)chartletMessage
{
    _chartletMessage = chartletMessage;
    
    _chartletImageView.isCopy = NO;
    _chartletImageView.isSend = _chartletMessage.message.isOutgoingMsg;
    _chartletImageView.frame = _chartletMessage.chartletFrame;
    _chartletImageView.image = [UIImage wt_fetchChartlet:_chartletMessage.chartletModel.chartletID chartletId:_chartletMessage.chartletModel.chartletCatalog];
}

#pragma mark - WTBubbleImageViewDelegate代理方法
- (void)onDelete
{
    if ([self.delegate respondsToSelector:@selector(onDeleteChartlet)])
    {
        [self.delegate onDeleteChartlet];
    }
}

- (void)onRevoke
{
    if ([self.delegate respondsToSelector:@selector(onRevokeChartlet)])
    {
        [self.delegate onRevokeChartlet];
    }
}

@end
