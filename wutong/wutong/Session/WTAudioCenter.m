//
//  WTAudioCenter.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/8.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTAudioCenter.h"

@interface WTAudioCenter () <NIMMediaManagerDelegate>

@property (nonatomic,assign) NSInteger retryCount;

@end

@implementation WTAudioCenter

#pragma mark - Life Cycle
+ (instancetype)sharedInstance
{
    static WTAudioCenter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WTAudioCenter alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [[NIMSDK sharedSDK].mediaManager addDelegate:self];
        _retryCount = 3;
    }
    return self;
}

#pragma mark - Public Cycle
- (void)play:(NIMMessage *)message
{
    NIMAudioObject *audioObject = (NIMAudioObject *)message.messageObject;
    if ([audioObject isKindOfClass:[NIMAudioObject class]])
    {
        self.currentPlayingMessage = message;
        message.isPlayed = YES;
        
        [[NIMSDK sharedSDK].mediaManager play:audioObject.path];
    }
}


#pragma mark - NIMMediaManagerDelegate代理方法
- (void)playAudio:(NSString *)filePath didBeganWithError:(NSError *)error
{
    if (error)
    {
        if (self.retryCount > 0)
        {
            self.retryCount --;
            [[NIMSDK sharedSDK].mediaManager play:filePath];
        }
        else
        {
            self.currentPlayingMessage = nil;
            self.retryCount = 3;
        }
    }
    else
    {
        self.retryCount = 3;
    }
}

- (void)playAudio:(NSString *)filePath didCompletedWithError:(NSError *)error
{
    self.currentPlayingMessage = nil;
}

@end
