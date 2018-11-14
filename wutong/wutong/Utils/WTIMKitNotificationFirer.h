//
//  WTIMKitNotificationFirer.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/23.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTIMKitTimerHolder.h"

@class WTIMKitFirerInfo;

@interface WTIMKitNotificationFirer : NSObject <WTIMKitTimerHolderDelegate>

@property (nonatomic, strong) NSMutableDictionary *cachedInfo;

@property (nonatomic, strong) WTIMKitTimerHolder *timer;

@property (nonatomic, assign) NSTimeInterval timeInterval;

- (void)addFireInfo:(WTIMKitFirerInfo *)info;

@end

@interface WTIMKitFirerInfo : NSObject

@property (nonatomic, strong) NIMSession *session;

@property (nonatomic, copy) NSString *notificationName;

- (NSObject *)fireObject;

- (NSString *)saveIdentity;

@end
