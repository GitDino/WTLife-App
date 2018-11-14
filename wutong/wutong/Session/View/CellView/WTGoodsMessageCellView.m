//
//  WTGoodsMessageCellView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/27.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTGoodsMessageCellView.h"
#import "WTGoodsMessageContentView.h"

@interface WTGoodsMessageCellView () <WTGoodsMessageContentViewDelegate>

@property (nonatomic, strong) WTGoodsMessageContentView *contentView;

@end

@implementation WTGoodsMessageCellView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _contentView = [[WTGoodsMessageContentView alloc] init];
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
    
    _contentView.frame = messageModel.goodContentViewFrame;
    _contentView.goodsModel = messageModel;
}

#pragma mark - WTGoodsMessageContentViewDelegate代理方法
- (void)onTapGoods
{
    if ([self.delegate respondsToSelector:@selector(onTapGoodsMessage)])
    {
        [self.delegate onTapGoodsMessage];
    }
}

- (void)onDeleteGoods
{
    if ([self.delegate respondsToSelector:@selector(onDeleteMessage)])
    {
        [self.delegate onDeleteMessage];
    }
}

- (void)onRevokeGoods
{
    if ([self.delegate respondsToSelector:@selector(onRevokeMessage)])
    {
        [self.delegate onRevokeMessage];
    }
}

@end
