//
//  WTIMKitTimerHolder.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/23.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTIMKitTimerHolder.h"

@interface WTIMKitTimerHolder ()
{
    NSTimer *_timer;
    BOOL    _repeats;
}
- (void)onTimer:(NSTimer *)timer;
@end

@implementation WTIMKitTimerHolder

- (void)dealloc
{
    [self stopTimer];
}

- (void)startTimer:(NSTimeInterval)seconds delegate:(id<WTIMKitTimerHolderDelegate>)delegate repeats:(BOOL)repeats
{
    _timeDelegate = delegate;
    _repeats = repeats;
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(onTimer:) userInfo:nil repeats:repeats];
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
    _timeDelegate = nil;
}

- (void)onTimer:(NSTimer *)timer
{
    if (!_repeats)
    {
        _timer = nil;
    }
    if (_timeDelegate && [_timeDelegate respondsToSelector:@selector(onTimerFired:)])
    {
        [_timeDelegate onTimerFired:self];
    }
}


@end
