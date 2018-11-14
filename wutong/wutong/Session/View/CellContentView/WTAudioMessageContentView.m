//
//  WTAudioMessageContentView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/6.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTAudioMessageContentView.h"
#import "WTBubbleImageView.h"
#import "WTAudioCenter.h"
#import "WTMessageModel.h"

@interface WTAudioMessageContentView () <WTBubbleImageViewDelegate, NIMMediaManagerDelegate>

@property (nonatomic, strong) WTBubbleImageView *bubbleImage;

@property (nonatomic, strong) UIImageView *animationImage;

@property (nonatomic, strong) UIImageView *redImage;

@property (nonatomic, strong) UILabel *durationLabel;

@end

@implementation WTAudioMessageContentView

#pragma mark - Life Cycle
- (void)dealloc
{
    [[NIMSDK sharedSDK].mediaManager removeDelegate:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [[NIMSDK sharedSDK].mediaManager addDelegate:self];
        
        _bubbleImage = [[WTBubbleImageView alloc] init];
        _bubbleImage.delegate = self;
        [self addSubview:_bubbleImage];
        
        _animationImage = [[UIImageView alloc] init];
        _animationImage.userInteractionEnabled = YES;
        _animationImage.animationDuration = 1;
        _animationImage.animationRepeatCount = 0;
        [self addSubview:_animationImage];
        
        _redImage = [[UIImageView alloc] init];
        _redImage.image = [UIImage imageNamed:@"receiveOrPay_reddotWithWording"];
        _redImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_redImage];
        
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.font = [UIFont systemFontOfSize:14];
        _durationLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
        _durationLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_durationLabel];
        
    }
    return self;
}

#pragma mark - Public Cycle
- (void)setPlaying:(BOOL)isPlaying
{
    if (isPlaying)
    {
        [self.animationImage startAnimating];
    }
    else
    {
        [self.animationImage stopAnimating];
    }
}

#pragma mark - Private Cycle
- (BOOL)isPlaying
{
    return [WTAudioCenter sharedInstance].currentPlayingMessage == self.audioMessage.message;
}

#pragma mark - WTBubbleImageViewDelegate代理方法
- (void)onTouchUpInside
{
    if ([self.audioMessage.message attachmentDownloadState] == NIMMessageAttachmentDownloadStateFailed)
    {
        if ([self.delegate respondsToSelector:@selector(retryDownloadMessage)])
        {
            [self.delegate retryDownloadMessage];
        }
        return;
    }
    if ([self.audioMessage.message attachmentDownloadState] == NIMMessageAttachmentDownloadStateDownloaded)
    {
        if ([[NIMSDK sharedSDK].mediaManager isPlaying])
        {
            [self setPlaying:NO];
            [[NIMSDK sharedSDK].mediaManager stopPlay];
        }
        else
        {
            [[NIMSDK sharedSDK].mediaManager switchAudioOutputDevice:NIMAudioOutputDeviceSpeaker];
            [[WTAudioCenter sharedInstance] play:self.audioMessage.message];
        }
        
    }
    if ([self.delegate respondsToSelector:@selector(onTapAudio)])
    {
        [self.delegate onTapAudio];
    }
}

#pragma mark - NIMMediaManagerDelegate代理方法
- (void)playAudio:(NSString *)filePath didBeganWithError:(NSError *)error
{
    if (self.isPlaying && [self.delegate respondsToSelector:@selector(startPlayingAudio)])
    {
        [self.delegate startPlayingAudio];
    }
}

- (void)playAudio:(NSString *)filePath didCompletedWithError:(NSError *)error
{
    [self setPlaying:NO];
}

- (void)onDelete
{
    if ([self.delegate respondsToSelector:@selector(onDeleteAudio)])
    {
        [self.delegate onDeleteAudio];
    }
}

- (void)onRevoke
{
    if ([self.delegate respondsToSelector:@selector(onRevokeAudio)])
    {
        [self.delegate onRevokeAudio];
    }
}

#pragma mark - Setter Cycle
- (void)setAudioMessage:(WTMessageModel *)audioMessage
{
    _audioMessage = audioMessage;
    
    if (_audioMessage.message.isOutgoingMsg)
    {
        _durationLabel.hidden = _audioMessage.message.deliveryState != NIMMessageDeliveryStateDeliveried;
        _redImage.hidden = _audioMessage.message.isOutgoingMsg ? YES : _audioMessage.message.isPlayed;
    }
    else
    {
        switch (_audioMessage.message.attachmentDownloadState) {
            case NIMMessageAttachmentDownloadStateDownloaded:
                _durationLabel.hidden = NO;
                _redImage.hidden = _audioMessage.message.isPlayed;
                break;
                
            default:
                _durationLabel.hidden = YES;
                _redImage.hidden = YES;
                break;
        }
    }
    
    _bubbleImage.isCopy = NO;
    _bubbleImage.isSend = _audioMessage.message.isOutgoingMsg;
    _bubbleImage.frame = _audioMessage.audioBubbleFrame;
    _bubbleImage.image = !_audioMessage.message.isOutgoingMsg ? [[UIImage imageNamed:@"ReceiverTextNodeBkg"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 20, 15, 20) resizingMode:UIImageResizingModeStretch] : [[UIImage imageNamed:@"SenderTextNodeBkg"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
    
    _animationImage.frame = _audioMessage.animationFrame;
    _animationImage.image = !_audioMessage.message.isOutgoingMsg ? [UIImage imageNamed:@"ReceiverVoiceNodePlaying"] : [UIImage imageNamed:@"SenderVoiceNodePlaying"];
    _animationImage.animationImages = !_audioMessage.message.isOutgoingMsg ? [NSArray arrayWithObjects:[UIImage imageNamed:@"ReceiverVoiceNodePlaying001"], [UIImage imageNamed:@"ReceiverVoiceNodePlaying002"], [UIImage imageNamed:@"ReceiverVoiceNodePlaying003"],nil] : [NSArray arrayWithObjects:[UIImage imageNamed:@"SenderVoiceNodePlaying001"], [UIImage imageNamed:@"SenderVoiceNodePlaying002"], [UIImage imageNamed:@"SenderVoiceNodePlaying003"],nil];
    
    _durationLabel.frame = _audioMessage.durationFrame;
    _durationLabel.text = _audioMessage.audioDuration;
    
    _redImage.frame = _audioMessage.redFrame;
 
    [self setPlaying:self.isPlaying];
}

@end
