//
//  WTChartletMessageContentView.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/8.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTMessageModel;

@protocol WTChartletMessageContentViewDelegate <NSObject>

- (void)onDeleteChartlet;

- (void)onRevokeChartlet;

@end

@interface WTChartletMessageContentView : UIView

@property (nonatomic, weak) id<WTChartletMessageContentViewDelegate> delegate;

@property (nonatomic, strong) WTMessageModel *chartletMessage;

@end
