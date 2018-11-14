//
//  WTAudioMessageCellView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/6.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTAudioMessageCellView.h"
#import "WTAudioMessageContentView.h"

@interface WTAudioMessageCellView () <WTAudioMessageContentViewDelegate>

@property (nonatomic, strong) WTAudioMessageContentView *contentView;

@end

@implementation WTAudioMessageCellView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _contentView = [[WTAudioMessageContentView alloc] init];
        _contentView.delegate = self;
        [self addSubview:_contentView];
    }
    return self;
}

- (void)onRetryMessage:(NIMMessage *)message
{
    if ([self.delegate respondsToSelector:@selector(onRetryMessage:)])
    {
        [self.delegate onRetryMessage:nil];
    }
}

- (void)refreshCellViewWithMessageModel:(WTMessageModel *)messageModel
{
    [super refreshCellViewWithMessageModel:messageModel];
    
    _contentView.frame = messageModel.audioContentViewFrame;
    _contentView.audioMessage = messageModel;
}

#pragma mark - WTAudioMessageContentViewDelegate代理方法
- (void)startPlayingAudio
{
    [self refreshCellViewWithMessageModel:self.messageModel];
}

- (void)retryDownloadMessage
{
    [self onRetryMessage:nil];
}

- (void)onDeleteAudio
{
    if ([self.delegate respondsToSelector:@selector(onDeleteMessage)])
    {
        [self.delegate onDeleteMessage];
    }
}

- (void)onRevokeAudio
{
    if ([self.delegate respondsToSelector:@selector(onRevokeMessage)])
    {
        [self.delegate onRevokeMessage];
    }
}

- (void)onTapAudio
{
    if ([self.delegate respondsToSelector:@selector(onTapAudioMessage)])
    {
        [self.delegate onTapAudioMessage];
    }
}

@end
