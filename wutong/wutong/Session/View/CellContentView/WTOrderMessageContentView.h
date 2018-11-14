//
//  WTOrderMessageContentView.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/29.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTMessageModel;

@protocol WTOrderMessageContentViewDelegate <NSObject>

- (void)onTapOrder;

- (void)onDeleteOrder;

- (void)onRevokeOrder;

@end

@interface WTOrderMessageContentView : UIView

@property (nonatomic, weak) id<WTOrderMessageContentViewDelegate> delegate;

@property (nonatomic, strong) WTMessageModel *orderMessage;

@end
