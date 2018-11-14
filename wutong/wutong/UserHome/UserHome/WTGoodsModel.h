//
//  WTGoodsModel.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTGoodsModel : NSObject

/**
 图片
 */
@property (nonatomic, copy) NSString *img;

/**
 商品名称
 */
@property (nonatomic, copy) NSString *goodsName;

/**
 商品SKU
 */
@property (nonatomic, copy) NSString *skuDesc;

/**
 商品金额
 */
@property (nonatomic, copy) NSString *amount;

/**
 数量
 */
@property (nonatomic, assign) NSInteger number;

@end
