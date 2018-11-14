//
//  WTMessageModel.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WTChartletModel, WTChatGoodsModel, WTChatOrderModel;

typedef NS_ENUM(NSUInteger, MessageModelType) {
    MessageModelTypeText = 0,
    MessageModelTypeImage,
    MessageModelTypeAudio,
    MessageModelTypeVideo,
    MessageModelTypeChartlet,
    MessageModelTypeGoods,
    MessageModelTypeOrder,
    MessageModelTypeTip,
};

@interface WTMessageModel : NSObject

@property (nonatomic, strong) NIMMessage *message;
@property (nonatomic, strong) WTChartletModel *chartletModel;
@property (nonatomic, strong) WTChatGoodsModel *goodsModel;
@property (nonatomic, strong) WTChatOrderModel *orderModel;
@property (nonatomic, assign) MessageModelType type;
@property (nonatomic, copy) NSString *audioDuration;
@property (nonatomic, copy) NSString *videoDuration;

@property (nonatomic, assign) CGRect iconFrame;
@property (nonatomic, assign) CGRect activityFrame;
@property (nonatomic, assign) CGRect failBtnFrame;
@property (nonatomic, assign) CGFloat cellHeight;

#pragma 文字
@property (nonatomic, assign) CGRect textFrame;
@property (nonatomic, assign) CGRect textBubbleFrame;
@property (nonatomic, assign) CGRect textContentViewFrame;

#warning 图片
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) CGRect imageContentViewFrame;

#pragma 语音
@property (nonatomic, assign) CGRect durationFrame;
@property (nonatomic, assign) CGRect animationFrame;
@property (nonatomic, assign) CGRect audioBubbleFrame;
@property (nonatomic, assign) CGRect redFrame;
@property (nonatomic, assign) CGRect audioContentViewFrame;

#pragma 视频
@property (nonatomic, assign) CGRect videoImageFrame;
@property (nonatomic, assign) CGRect playImageFrame;
@property (nonatomic, assign) CGRect shadowImageFrame;
@property (nonatomic, assign) CGRect timeLabelFrame;
@property (nonatomic, assign) CGRect videoContentViewFrame;


#pragma 超级表情
@property (nonatomic, assign) CGRect chartletFrame;
@property (nonatomic, assign) CGRect chartletContentViewFrame;

#pragma 商品
@property (nonatomic, assign) CGRect goodImgFrame;
@property (nonatomic, assign) CGRect goodNameFrame;
@property (nonatomic, assign) CGRect goodPriceFrame;
@property (nonatomic, assign) CGRect goodContentViewFrame;

#pragma 订单
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *orderTime;
@property (nonatomic, copy) NSString *orderState;
@property (nonatomic, assign) CGRect orderNoFrame;
@property (nonatomic, assign) CGRect orderTimeFrame;
@property (nonatomic, assign) CGRect orderStateFrame;
@property (nonatomic, assign) CGRect orderMoneyFrame;
@property (nonatomic, assign) CGRect orderLineViewFrame;
@property (nonatomic, assign) CGRect orderContentViewFrame;

#pragma 撤回消息
@property (nonatomic, assign) CGRect tipFrame;
@property (nonatomic, assign) CGRect tipImageFrame;
@property (nonatomic, assign) CGRect systemContentViewFrame;

- (instancetype)initWithMessage:(NIMMessage *)message;

@end
