//
//  WTAuthorityManager.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/7.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^authorityBlock)(BOOL isAllow, NSString *prompt);

@interface WTAuthorityManager : NSObject

/**
 获取相册权限
 */
+ (void)obtainPhotosAuthority:(authorityBlock) result;

/**
 获取麦克风权限
 */
+ (void)obtainAudioAuthority:(authorityBlock) result;

/**
 获取相机权限
 */
+ (void)obtainVideoAuthority:(authorityBlock) result;

/**
 获取推送权限
 */
+ (void)obtainPushAuthority:(authorityBlock) result;

/**
 获取位置服务权限
 */
+ (void)obtainLocationAuthority:(authorityBlock) result;

@end
