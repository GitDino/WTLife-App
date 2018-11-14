//
//  WTOrderMessageContentView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/29.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTOrderMessageContentView.h"
#import "WTBubbleImageView.h"
#import "WTMessageModel.h"
#import "WTChatOrderModel.h"

@interface WTOrderMessageContentView () <WTBubbleImageViewDelegate>

@property (nonatomic, strong) WTBubbleImageView *backImage;

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *orderMoneyLabel;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *goodsNameLabel;
@property (nonatomic, strong) UILabel *goodsPriceLabel;

@end

@implementation WTOrderMessageContentView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _backImage = [[WTBubbleImageView alloc] init];
        _backImage.delegate = self;
        [self addSubview:_backImage];
        
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_typeLabel];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_timeLabel];
        
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_stateLabel];
        
        _orderMoneyLabel = [[UILabel alloc] init];
        _orderMoneyLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_orderMoneyLabel];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [self addSubview:_lineView];
        
        _goodsImageView = [[UIImageView alloc] init];
        _goodsImageView.backgroundColor = [UIColor wtLightGrayColor];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImageView.clipsToBounds = YES;
        [self addSubview:_goodsImageView];
        
        _goodsNameLabel = [[UILabel alloc] init];
        _goodsNameLabel.numberOfLines = 0;
        _goodsNameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_goodsNameLabel];
        
        _goodsPriceLabel = [[UILabel alloc] init];
        _goodsPriceLabel.font = [UIFont systemFontOfSize:16];
        _goodsPriceLabel.textColor = [UIColor colorWithRed:255/255.0 green:75/255.0 blue:46/255.0 alpha:1.0];
        [self addSubview:_goodsPriceLabel];
    }
    return self;
}

#pragma mark - Setter Cycle
- (void)setOrderMessage:(WTMessageModel *)orderMessage
{
    _orderMessage = orderMessage;
    
    _backImage.frame = self.bounds;
    _backImage.isSend = _orderMessage.message.isOutgoingMsg;
    
    _typeLabel.frame = _orderMessage.orderNoFrame;
    _typeLabel.text = _orderMessage.orderNo;
    
    _timeLabel.frame = _orderMessage.orderTimeFrame;
    _timeLabel.text = _orderMessage.orderTime;
    
    _stateLabel.frame = _orderMessage.orderStateFrame;
    _stateLabel.text = _orderMessage.orderState;
    
    _orderMoneyLabel.frame = _orderMessage.orderMoneyFrame;
    _orderMoneyLabel.text = [NSString stringWithFormat:@"订单金额：¥%.2f", _orderMessage.orderModel.orderPrice];
    
    _lineView.frame = _orderMessage.orderLineViewFrame;
    
    _goodsImageView.frame = _orderMessage.goodImgFrame;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:_orderMessage.orderModel.goodsImg] placeholderImage:nil];
    
    _goodsNameLabel.frame = _orderMessage.goodNameFrame;
    _goodsNameLabel.text = _orderMessage.orderModel.goodsName;
    
    _goodsPriceLabel.frame = _orderMessage.goodPriceFrame;
    _goodsPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", _orderMessage.orderModel.goodsPrice];
}

#pragma mark - WTBubbleImageViewDelegate代理方法
- (void)onTouchUpInside
{
    if ([self.delegate respondsToSelector:@selector(onTapOrder)])
    {
        [self.delegate onTapOrder];
    }
}

- (void)onDelete
{
    if ([self.delegate respondsToSelector:@selector(onDeleteOrder)])
    {
        [self.delegate onDeleteOrder];
    }
}

- (void)onRevoke
{
    if ([self.delegate respondsToSelector:@selector(onRevokeOrder)])
    {
        [self.delegate onRevokeOrder];
    }
}

@end
