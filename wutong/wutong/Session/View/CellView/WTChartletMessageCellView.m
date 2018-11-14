//
//  WTChartletMessageCellView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/8.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTChartletMessageCellView.h"
#import "WTChartletMessageContentView.h"

@interface WTChartletMessageCellView () <WTChartletMessageContentViewDelegate>

@property (nonatomic, strong) WTChartletMessageContentView *contentView;

@end

@implementation WTChartletMessageCellView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _contentView = [[WTChartletMessageContentView alloc] init];
        _contentView.delegate = self;
        [self addSubview:_contentView];
    }
    return self;
}

- (void)refreshCellViewWithMessageModel:(WTMessageModel *)messageModel
{
    [super refreshCellViewWithMessageModel:messageModel];
    
    _contentView.frame = messageModel.chartletContentViewFrame;
    _contentView.chartletMessage = messageModel;
}

#pragma mark - WTChartletMessageContentViewDelegate代理方法
- (void)onDeleteChartlet
{
    if ([self.delegate respondsToSelector:@selector(onDeleteMessage)])
    {
        [self.delegate onDeleteMessage];
    }
}

- (void)onRevokeChartlet
{
    if ([self.delegate respondsToSelector:@selector(onRevokeMessage)])
    {
        [self.delegate onRevokeMessage];
    }
}

@end
