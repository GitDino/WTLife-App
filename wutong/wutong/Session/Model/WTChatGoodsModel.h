//
//  WTChatGoodsModel.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/27.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTChatGoodsModel : NSObject <NIMCustomAttachment>

/**
 商品图片
 */
@property (nonatomic, copy) NSString *goodImg;

/**
 商品名字
 */
@property (nonatomic, copy) NSString *goodName;

/**
 商品价格
 */
@property (nonatomic, assign) CGFloat goodPrice;

/**
 商品ID
 */
@property (nonatomic, copy) NSString *goodId;

/**
 店铺名字
 */
@property (nonatomic, copy) NSString *shopName;

/**
 店铺ID
 */
@property (nonatomic, copy) NSString *shopId;

@end
