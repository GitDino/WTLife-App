//
//  WTPlayVideoView.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/8.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTPlayVideoView.h"
#import <AVFoundation/AVFoundation.h>

@interface WTPlayVideoView ()

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) UIImageView *playImage;

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation WTPlayVideoView

#pragma mark - Life Cycle
- (void)dealloc
{
    [self removeAVPlayerNotification];
    [self stopPlayer];
    self.player = nil;
}

- (instancetype)initWithFrame:(CGRect)frame withShowInView:(UIView *)bgView URL:(NSURL *)url
{
    if (self = [super initWithFrame:frame])
    {
        AVPlayerLayer *playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        playLayer.frame = self.bounds;
        [self.layer addSublayer:playLayer];
        
        if (url)
        {
            self.videoURL = url;
        }
        [bgView addSubview:self];
        
        [self addSubview:self.playImage];
        [self addSubview:self.closeBtn];
    }
    return self;
}

#pragma mark - Private Cycle
- (AVPlayerItem *)obtainAVPlayerItem
{
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:self.videoURL];
    return playerItem;
}

- (void)addAVPlayerNotification:(AVPlayerItem *)playerItem
{
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)removeAVPlayerNotification
{
    AVPlayerItem *playerItem = self.player.currentItem;
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)nextPlayer
{
    [self.player seekToTime:CMTimeMakeWithSeconds(0, _player.currentItem.duration.timescale)];
    [self.player replaceCurrentItemWithPlayerItem:[self obtainAVPlayerItem]];
    [self addAVPlayerNotification:self.player.currentItem];
    if (self.player.rate == 0)
    {
        [self.player play];
    }
}

- (void)stopPlayer
{
    if (self.player.rate == 1)
    {
        [self.player pause];
    }
}

- (void)onTapPlay
{
    self.playImage.hidden = YES;
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}

#pragma mark - Observe Cycle
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"])
    {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay)
        {
            NSLog(@"正在播放...，视频总长度:%.2f", CMTimeGetSeconds(playerItem.duration));
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        NSArray *array = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
        NSLog(@"共缓冲：%.2f", totalBuffer);
    }
}

- (void)playFinished:(NSNotification *)notification
{
    self.playImage.hidden = NO;
}

- (void)onTapClose
{
    if (self.closePlayVideoBlock)
    {
        self.closePlayVideoBlock();
    }
}

#pragma mark - Setter Cycle
- (void)setVideoURL:(NSURL *)videoURL
{
    _videoURL = videoURL;
    [self removeAVPlayerNotification];
    [self nextPlayer];
}

#pragma mark - Getter Cycle
- (AVPlayer *)player
{
    if (!_player)
    {
        _player = [AVPlayer playerWithPlayerItem:[self obtainAVPlayerItem]];
        [self addAVPlayerNotification:_player.currentItem];
    }
    return _player;
}

- (UIImageView *)playImage
{
    if (!_playImage)
    {
        _playImage = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60) * 0.5, (SCREEN_HEIGHT - 60) * 0.5, 60, 60)];
        _playImage.userInteractionEnabled = YES;
        _playImage.image = [UIImage imageNamed:@"play_btn_normal"];
        _playImage.hidden = YES;
        UITapGestureRecognizer *tapPlayGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPlay)];
        [_playImage addGestureRecognizer:tapPlayGes];
    }
    return _playImage;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn)
    {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 44, 44)];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(onTapClose) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
