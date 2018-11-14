//
//  WTTextMessageContentView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/5.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTTextMessageContentView.h"
#import "WTBubbleImageView.h"
#import <M80AttributedLabel.h>
#import "M80AttributedLabel+WT.h"
#import "WTMessageModel.h"

@interface WTTextMessageContentView () <WTBubbleImageViewDelegate>

@property (nonatomic, strong) WTBubbleImageView *bubbleImage;

@property (nonatomic, strong) M80AttributedLabel *textLabel;

@end

@implementation WTTextMessageContentView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _bubbleImage = [[WTBubbleImageView alloc] init];
        _bubbleImage.delegate = self;
        [self addSubview:_bubbleImage];
        
        _textLabel = [[M80AttributedLabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.numberOfLines = 0;
        _textLabel.font = [UIFont fontWithName:@"SFUIText-Bold" size:17];
        _textLabel.userInteractionEnabled = YES;
        _textLabel.autoDetectLinks = YES;
        _textLabel.underLineForLink = NO;
        _textLabel.lineSpacing = 0.0;
        [self addSubview:_textLabel];
    }
    return self;
}

#pragma mark - Setter Cycle
- (void)setTextMessage:(WTMessageModel *)textMessage
{
    _textMessage = textMessage;
    
    _bubbleImage.isCopy = YES;
    _bubbleImage.isSend = _textMessage.message.isOutgoingMsg;
    _bubbleImage.frame = _textMessage.textBubbleFrame;
    _bubbleImage.image = !_textMessage.message.isOutgoingMsg ? [[UIImage imageNamed:@"ReceiverTextNodeBkg"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 15, 20) resizingMode:UIImageResizingModeStretch] : [[UIImage imageNamed:@"SenderTextNodeBkg"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
    
    _textLabel.frame = _textMessage.textFrame;
    _textLabel.textColor = _textMessage.message.isOutgoingMsg ? [UIColor wtWhiteColor] : [UIColor wtBlackColor];
    [_textLabel wt_setText:_textMessage.message.text];
}

#pragma mark - WTBubbleImageViewDelegate代理方法
- (void)onTouchUpInside
{
    if ([self.delegate respondsToSelector:@selector(onTapText)])
    {
        [self.delegate onTapText];
    }
}

- (void)onDelete
{
    if ([self.delegate respondsToSelector:@selector(onDeleteText)])
    {
        [self.delegate onDeleteText];
    }
}

- (void)onRevoke
{
    if ([self.delegate respondsToSelector:@selector(onRevokeText)])
    {
        [self.delegate onRevokeText];
    }
}

- (void)onCopy
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.textMessage.message.text;
}


@end
