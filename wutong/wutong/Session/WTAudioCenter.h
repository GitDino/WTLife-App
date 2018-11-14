//
//  WTAudioCenter.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/8.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NIMMessage;

@interface WTAudioCenter : NSObject

@property (nonatomic, strong) NIMMessage *currentPlayingMessage;

+ (instancetype)sharedInstance;

- (void)play:(NIMMessage *)message;

@end
