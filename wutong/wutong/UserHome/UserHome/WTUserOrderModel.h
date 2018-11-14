//
//  WTUserOrderModel.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTUserOrderModel : NSObject

/**
 订单时间
 */
@property (nonatomic, assign) NSTimeInterval createTime;

/**
 商品数量
 */
@property (nonatomic, assign) NSInteger total;

/**
 商品金额
 */
@property (nonatomic, copy) NSString *totalAmount;

/**
 商品对象数组
 */
@property (nonatomic, strong) NSArray *listGoods;

@end
