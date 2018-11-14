//
//  WTCustomAttachmentDecoder.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/8.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WTCustomMessageType) {
    WTCustomMessageTypeChartlet = 3,    //超级表情
    WTCustomMessageTypeGoods    = 103,  //发送商品
    WTCustomMessageTypeOrder    = 104,  //发送订单
};

@interface WTCustomAttachmentDecoder : NSObject <NIMCustomAttachmentCoding>

@end
