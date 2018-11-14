//
//  WTImageMessageContentView.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/6.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTMessageModel, WTBubbleImageView;

@protocol WTImageMessageContentViewDelegate <NSObject>

- (void)onTapImageView:(WTBubbleImageView *)bubbleImage;

- (void)onDeleteImage;

- (void)onRevokeImage;

@end

@interface WTImageMessageContentView : UIView

@property (nonatomic, weak) id<WTImageMessageContentViewDelegate> delegate;

@property (nonatomic, strong) WTMessageModel *imageMessage;

@end
