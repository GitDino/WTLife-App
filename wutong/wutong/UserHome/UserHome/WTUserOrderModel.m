//
//  WTUserOrderModel.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTUserOrderModel.h"
#import "WTGoodsModel.h"

@implementation WTUserOrderModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"listGoods" : [WTGoodsModel class]};
}

@end
