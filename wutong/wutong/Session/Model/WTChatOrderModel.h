//
//  WTChatOrderModel.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/27.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTChatOrderModel : NSObject <NIMCustomAttachment>

/**
 所属订单
 */
@property (nonatomic, copy) NSString *orderNo;

/**
 订单状态
 */
@property (nonatomic, assign) NSInteger orderState;

/**
 订单时间
 */
@property (nonatomic, assign) NSTimeInterval orderTime;

/**
 订单金额
 */
@property (nonatomic, assign) CGFloat orderPrice;

/**
 订单ID
 */
@property (nonatomic, copy) NSString *orderId;

/**
 商品图片
 */
@property (nonatomic, copy) NSString *goodsImg;

/**
 商品名字
 */
@property (nonatomic, copy) NSString *goodsName;

/**
 商品价格
 */
@property (nonatomic, assign) CGFloat goodsPrice;

@end
