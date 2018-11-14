//
//  WTVideoMessageContentView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTVideoMessageContentView.h"
#import "WTBubbleImageView.h"
#import "WTMessageModel.h"

@interface WTVideoMessageContentView () <WTBubbleImageViewDelegate>

@property (nonatomic, strong) WTBubbleImageView *videoImageView;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation WTVideoMessageContentView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _videoImageView = [[WTBubbleImageView alloc] init];
        _videoImageView.delegate = self;
        _videoImageView.layer.masksToBounds = YES;
        _videoImageView.layer.cornerRadius = 4.0;
        [self addSubview:_videoImageView];
        
        _playImageView = [[UIImageView alloc] init];
        _playImageView.image = [UIImage imageNamed:@"play_btn_normal"];
        [_videoImageView addSubview:_playImageView];
        
        _shadowImageView = [[UIImageView alloc] init];
        _shadowImageView.image = [[UIImage imageNamed:@"Albumtimeline_video_shadow"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) resizingMode:UIImageResizingModeStretch];
        [_videoImageView addSubview:_shadowImageView];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [_shadowImageView addSubview:_timeLabel];
    }
    return self;
}

#pragma mark - Setter Cycle
- (void)setVideoMessage:(WTMessageModel *)videoMessage
{
    _videoMessage = videoMessage;
    
    NIMVideoObject *videoObject = (NIMVideoObject *)_videoMessage.message.messageObject;
    
    _videoImageView.isCopy = NO;
    _videoImageView.isSend = _videoMessage.message.isOutgoingMsg;
    _videoImageView.frame = _videoMessage.videoImageFrame;
    _videoImageView.image = [UIImage imageWithContentsOfFile:videoObject.coverPath];
    
    _playImageView.frame = _videoMessage.playImageFrame;
    
    _shadowImageView.frame = _videoMessage.shadowImageFrame;
    
    _timeLabel.frame = _videoMessage.timeLabelFrame;
    _timeLabel.text = _videoMessage.videoDuration;
}

#pragma mark - WTBubbleImageViewDelegate代理方法
- (void)onTouchUpInside
{
    if ([self.delegte respondsToSelector:@selector(onTapVideo)])
    {
        [self.delegte onTapVideo];
    }
}

- (void)onDelete
{
    if ([self.delegte respondsToSelector:@selector(onDeleteVideo)])
    {
        [self.delegte onDeleteVideo];
    }
}

- (void)onRevoke
{
    if ([self.delegte respondsToSelector:@selector(onRevokeVideo)])
    {
        [self.delegte onRevokeVideo];
    }
}

@end
