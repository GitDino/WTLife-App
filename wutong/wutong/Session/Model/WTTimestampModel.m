//
//  WTTimestampModel.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTTimestampModel.h"
#import "WTSessionUtil.h"

@implementation WTTimestampModel

#pragma mark - Life Cycle
- (instancetype)initWithTime:(NSTimeInterval)time
{
    if (self = [super init])
    {
        _messageTime = time;
        _timeResult = [WTSessionUtil showTime:_messageTime detail:YES];
        _timeSize = [self configTime];
        _cellHeight = 44.0;
    }
    return self;
}

#pragma mark - Private Cycle
- (CGSize)configTime
{
    CGSize timeSize = [NSString sizeWithText:self.timeResult font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT)];
    return timeSize;
}

@end
