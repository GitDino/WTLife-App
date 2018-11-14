//
//  WTImageMessageCellView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/6.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTImageMessageCellView.h"
#import "WTImageMessageContentView.h"

@interface WTImageMessageCellView () <WTImageMessageContentViewDelegate>

@property (nonatomic, strong) WTImageMessageContentView *contentView;

@end

@implementation WTImageMessageCellView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _contentView = [[WTImageMessageContentView alloc] init];
        _contentView.delegate = self;
        [self addSubview:_contentView];
    }
    return self;
}

- (void)refreshCellViewWithMessageModel:(WTMessageModel *)messageModel
{
    [super refreshCellViewWithMessageModel:messageModel];
    
    _contentView.frame = messageModel.imageContentViewFrame;
    _contentView.imageMessage = messageModel;
}

#pragma mark - WTImageMessageContentViewDelegate代理方法
- (void)onTapImageView:(WTBubbleImageView *)bubbleImage
{
    if ([self.delegate respondsToSelector:@selector(onTapImageMessageWithView:)])
    {
        [self.delegate onTapImageMessageWithView:bubbleImage];
    }
}

- (void)onDeleteImage
{
    if ([self.delegate respondsToSelector:@selector(onDeleteMessage)])
    {
        [self.delegate onDeleteMessage];
    }
}

- (void)onRevokeImage
{
    if ([self.delegate respondsToSelector:@selector(onRevokeMessage)])
    {
        [self.delegate onRevokeMessage];
    }
}

@end
