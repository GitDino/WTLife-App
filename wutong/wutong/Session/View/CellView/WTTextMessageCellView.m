//
//  WTTextMessageCellView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/5.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTTextMessageCellView.h"
#import "WTTextMessageContentView.h"

@interface WTTextMessageCellView () <WTTextMessageContentViewDelegate>

@property (nonatomic, strong) WTTextMessageContentView *contentView;

@end

@implementation WTTextMessageCellView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _contentView = [[WTTextMessageContentView alloc] init];
        _contentView.delegate = self;
        [self addSubview:_contentView];
    }
    return self;
}

- (void)refreshCellViewWithMessageModel:(WTMessageModel *)messageModel
{
    [super refreshCellViewWithMessageModel:messageModel];
    
    _contentView.frame = messageModel.textContentViewFrame;
    _contentView.textMessage = messageModel;
}

#pragma mark - WTTextMessageContentViewDelegate代理方法
- (void)onTapText
{
    if ([self.delegate respondsToSelector:@selector(onTapTextMessage)])
    {
        [self.delegate onTapTextMessage];
    }
}

- (void)onDeleteText
{
    if ([self.delegate respondsToSelector:@selector(onDeleteMessage)])
    {
        [self.delegate onDeleteMessage];
    }
}

- (void)onRevokeText
{
    if ([self.delegate respondsToSelector:@selector(onRevokeMessage)])
    {
        [self.delegate onRevokeMessage];
    }
}

@end
