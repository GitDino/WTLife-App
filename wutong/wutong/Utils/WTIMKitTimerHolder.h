//
//  WTIMKitTimerHolder.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/23.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WTIMKitTimerHolder;

@protocol WTIMKitTimerHolderDelegate <NSObject>
- (void)onTimerFired:(WTIMKitTimerHolder *)holder;
@end

@interface WTIMKitTimerHolder : NSObject

@property (nonatomic, weak) id<WTIMKitTimerHolderDelegate> timeDelegate;

- (void)startTimer:(NSTimeInterval)seconds delegate:(id<WTIMKitTimerHolderDelegate>)delegate repeats:(BOOL)repeats;

- (void)stopTimer;

@end
