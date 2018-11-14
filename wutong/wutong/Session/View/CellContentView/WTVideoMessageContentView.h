//
//  WTVideoMessageContentView.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTMessageModel;

@protocol WTVideoMessageContentViewDelegate <NSObject>

- (void)onTapVideo;

- (void)onDeleteVideo;

- (void)onRevokeVideo;

@end

@interface WTVideoMessageContentView : UIView

@property (nonatomic, weak) id<WTVideoMessageContentViewDelegate> delegte;

@property (nonatomic, strong) WTMessageModel *videoMessage;

@end
