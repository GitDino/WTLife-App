//
//  WTAudioMessageContentView.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/6.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTMessageModel;

@protocol WTAudioMessageContentViewDelegate <NSObject>

- (void)startPlayingAudio;

- (void)retryDownloadMessage;

- (void)onTapAudio;

- (void)onDeleteAudio;

- (void)onRevokeAudio;

@end

@interface WTAudioMessageContentView : UIView

@property (nonatomic, weak) id<WTAudioMessageContentViewDelegate> delegate;

@property (nonatomic, strong) WTMessageModel *audioMessage;

- (void)setPlaying:(BOOL)isPlaying;

@end
