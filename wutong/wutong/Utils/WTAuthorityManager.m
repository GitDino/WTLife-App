//
//  WTAuthorityManager.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/7.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTAuthorityManager.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>

@implementation WTAuthorityManager

#pragma mark - Public Cycle
+ (void)obtainPhotosAuthority:(authorityBlock) result
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied)
    {
        if (result)
        {
            result(NO, @"请在iPhone的[设置]->[隐私]->[照片]选项中，允许吾同生活访问你的手机相册。");
        }
    }
    else
    {
        if (result)
        {
            result(YES, @"已经打开相册权限");
        }
    }
}

+ (void)obtainAudioAuthority:(authorityBlock) result
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusRestricted ||
        status ==AVAuthorizationStatusDenied)
    {
        if (result)
        {
            result(NO, @"请在iPhone的[设置]->[隐私]->[麦克风]选项中，允许吾同生活访问你的手机麦克风。");
        }
    }
    else
    {
        if (result)
        {
            result(YES, @"已经打开麦克风权限");
        }
    }
}

+ (void)obtainVideoAuthority:(authorityBlock) result
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted ||
        status ==AVAuthorizationStatusDenied)
    {
        if (result)
        {
            result(NO, @"请在iPhone的[设置]->[隐私]选项中，允许吾同生活访问你的摄像头和麦克风。");
        }
    }
    else
    {
        if (result)
        {
            result(YES, @"已经打开摄像头权限");
        }
    }
}

+ (void)obtainPushAuthority:(authorityBlock) result
{
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone)
    {
        if (result)
        {
            result(NO, @"你现在无法收到新的通知。请在iPhone的[设置]->[通知]->[吾同生活]中开启。");
        }
    }
    else
    {
        if (result)
        {
            result(YES, @"已经打开推送权限");
        }
    }
}

+ (void)obtainLocationAuthority:(authorityBlock) result
{
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined))
    {
        if (result)
        {
            result(NO, @"无法获取你的位置信息。请在iPhone的[设置]->[隐私]->[定位服务]中打开定位服务，并允许吾同生活使用定位服务。");
        }
    }
    else
    {
        if (result)
        {
            result(YES, @"已经打开位置服务权限");
        }
    }
}

@end
