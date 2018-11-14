//
//  WTPayModel.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/1.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTPayModel : NSObject

/**
 支付渠道
 1 : 微信
 2 : 支付宝
 */
@property (nonatomic, assign) NSInteger payType;

/**
 签名信息
 */
@property (nonatomic, copy) NSString *orderStr;

@end
