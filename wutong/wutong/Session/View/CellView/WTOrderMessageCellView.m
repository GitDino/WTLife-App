//
//  WTOrderMessageCellView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/29.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTOrderMessageCellView.h"
#import "WTOrderMessageContentView.h"

@interface WTOrderMessageCellView () <WTOrderMessageContentViewDelegate>

@property (nonatomic, strong) WTOrderMessageContentView *contentView;

@end

@implementation WTOrderMessageCellView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _contentView = [[WTOrderMessageContentView alloc] init];
        _contentView.delegate = self;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.borderWidth = 1.0;
        _contentView.layer.borderColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0].CGColor;
        [self addSubview:_contentView];
    }
    return self;
}

- (void)refreshCellViewWithMessageModel:(WTMessageModel *)messageModel
{
    [super refreshCellViewWithMessageModel:messageModel];
    
    _contentView.frame = messageModel.orderContentViewFrame;
    _contentView.orderMessage = messageModel;
}

#pragma mark - WTOrderMessageContentViewDelegate代理方法
- (void)onTapOrder
{
    if ([self.delegate respondsToSelector:@selector(onTapOrderMessage)])
    {
        [self.delegate onTapOrderMessage];
    }
}

- (void)onDeleteOrder
{
    if ([self.delegate respondsToSelector:@selector(onDeleteMessage)])
    {
        [self.delegate onDeleteMessage];
    }
}

- (void)onRevokeOrder
{
    if ([self.delegate respondsToSelector:@selector(onRevokeMessage)])
    {
        [self.delegate onRevokeMessage];
    }
}

@end
