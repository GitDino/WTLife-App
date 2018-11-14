//
//  WTIMInfo.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/11.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTIMInfo : NSObject

/**
 用户id或群id
 */
@property (nonatomic, copy) NSString *infoID;

/**
 显示名
 */
@property (nonatomic, copy) NSString *showName;

/**
 头像URL
 */
@property (nonatomic, copy) NSString *avatarURL;

/**
 头像图片
 */
@property (nonatomic, strong) UIImage *avatarImage;

/**
 角色类型
 1 : 顾问
 2 : 普通用户
 3 : 后台管理员
 */
@property (nonatomic, copy) NSString *userType;

/**
 WT用户ID
 */
@property (nonatomic, copy) NSString *uid;

@end
