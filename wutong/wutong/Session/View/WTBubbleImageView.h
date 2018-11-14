//
//  WTBubbleImageView.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/8.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WTBubbleImageViewDelegate <NSObject>
@optional
- (void)onTouchUpInside;

- (void)onDelete;

- (void)onRevoke;

- (void)onCopy;

@end

@interface WTBubbleImageView : UIImageView

@property (nonatomic, weak) id<WTBubbleImageViewDelegate> delegate;

@property (nonatomic, assign) BOOL isCopy;

@property (nonatomic, assign) BOOL isSend;

@end
