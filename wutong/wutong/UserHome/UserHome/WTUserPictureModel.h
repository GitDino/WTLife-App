//
//  WTUserPictureModel.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTUserPictureModel : NSObject

/**
 注册时间
 */
@property (nonatomic, copy) NSString *createTime;

/**
 最近消费时间
 */
@property (nonatomic, copy) NSString *lastDate;

/**
 消费总金额
 */
@property (nonatomic, copy) NSString *totalAmount;

/**
 单日最高
 */
@property (nonatomic, copy) NSString *dayMax;

/**
 复购单数
 */
@property (nonatomic, assign) NSInteger totalBuy;

/**
 单品最高
 */
@property (nonatomic, copy) NSString *max;

/**
 客单价
 */
@property (nonatomic, copy) NSString *perOrder;

/**
 系统标签
 */
@property (nonatomic, strong) NSArray *sysTag;

/**
 自定义标签
 */
@property (nonatomic, strong) NSArray *defTags;

@end
