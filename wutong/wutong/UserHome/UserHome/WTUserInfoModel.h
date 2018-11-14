//
//  WTUserInfoModel.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/5.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTUserInfoModel : NSObject

/**
 头像
 */
@property (nonatomic, copy) NSString *img;

/**
 昵称
 */
@property (nonatomic, copy) NSString *nickname;

/**
 店铺名称
 */
@property (nonatomic, copy) NSString *shopName;

/**
 性别
 */
@property (nonatomic, assign) NSInteger sex;

/**
 地区
 */
@property (nonatomic, copy) NSString *cityName;

/**
 签名
 */
@property (nonatomic, copy) NSString *sign;

/**
 备注电话
 */
@property (nonatomic, copy) NSString *remtel;

@end
