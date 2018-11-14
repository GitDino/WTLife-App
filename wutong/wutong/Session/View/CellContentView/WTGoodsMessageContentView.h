//
//  WTGoodsMessageContentView.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/27.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTMessageModel;

@protocol WTGoodsMessageContentViewDelegate <NSObject>

- (void)onTapGoods;

- (void)onDeleteGoods;

- (void)onRevokeGoods;

@end

@interface WTGoodsMessageContentView : UIView

@property (nonatomic, weak) id<WTGoodsMessageContentViewDelegate> delegate;

@property (nonatomic, strong) WTMessageModel *goodsModel;

@end
