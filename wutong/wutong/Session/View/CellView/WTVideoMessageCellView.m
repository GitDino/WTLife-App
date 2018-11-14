//
//  WTVideoMessageCellView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTVideoMessageCellView.h"
#import "WTVideoMessageContentView.h"

@interface WTVideoMessageCellView () <WTVideoMessageContentViewDelegate>

@property (nonatomic, strong) WTVideoMessageContentView *contentView;

@end

@implementation WTVideoMessageCellView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _contentView = [[WTVideoMessageContentView alloc] init];
        _contentView.delegte = self;
        [self addSubview:_contentView];
    }
    return self;
}

- (void)refreshCellViewWithMessageModel:(WTMessageModel *)messageModel
{
    [super refreshCellViewWithMessageModel:messageModel];
    
    _contentView.frame = messageModel.videoContentViewFrame;
    _contentView.videoMessage = messageModel;
}

#pragma mark - WTVideoMessageContentViewDelegate代理方法
- (void)onTapVideo
{
    if ([self.delegate respondsToSelector:@selector(onTapVideoMessage)])
    {
        [self.delegate onTapVideoMessage];
    }
}

- (void)onDeleteVideo
{
    if ([self.delegate respondsToSelector:@selector(onDeleteMessage)])
    {
        [self.delegate onDeleteMessage];
    }
}

- (void)onRevokeVideo
{
    if ([self.delegate respondsToSelector:@selector(onRevokeMessage)])
    {
        [self.delegate onRevokeMessage];
    }
}

@end
