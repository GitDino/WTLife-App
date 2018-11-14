//
//  WTImageMessageContentView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/6.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTImageMessageContentView.h"
#import "WTBubbleImageView.h"
#import "WTMessageModel.h"

@interface WTImageMessageContentView () <WTBubbleImageViewDelegate>

@property (nonatomic, strong) WTBubbleImageView *messageImageView;

@end

@implementation WTImageMessageContentView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _messageImageView = [[WTBubbleImageView alloc] init];
        _messageImageView.delegate = self;
        _messageImageView.userInteractionEnabled = YES;
        _messageImageView.layer.masksToBounds = YES;
        _messageImageView.layer.cornerRadius = 4.0;
        [self addSubview:_messageImageView];
    }
    return self;
}

#pragma mark - WTBubbleImageViewDelegate代理方法
- (void)onTouchUpInside
{
    if ([self.delegate respondsToSelector:@selector(onTapImageView:)])
    {
        [self.delegate onTapImageView:self.messageImageView];
    }
}

- (void)onDelete
{
    if ([self.delegate respondsToSelector:@selector(onDeleteImage)])
    {
        [self.delegate onDeleteImage];
    }
}

- (void)onRevoke
{
    if ([self.delegate respondsToSelector:@selector(onRevokeImage)])
    {
        [self.delegate onRevokeImage];
    }
}

#pragma mark - Setter Cycle
- (void)setImageMessage:(WTMessageModel *)imageMessage
{
    _imageMessage = imageMessage;
    
    NIMImageObject *imageObject = (NIMImageObject *)_imageMessage.message.messageObject;
    
    _messageImageView.isCopy = NO;
    _messageImageView.isSend = _imageMessage.message.isOutgoingMsg;
    _messageImageView.frame = _imageMessage.imageFrame;
    _messageImageView.image = [UIImage imageWithContentsOfFile:imageObject.thumbPath];
}

@end
