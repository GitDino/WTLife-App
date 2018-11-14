//
//  WTGoodsMessageContentView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/27.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTGoodsMessageContentView.h"
#import "WTBubbleImageView.h"
#import "WTMessageModel.h"
#import "WTChatGoodsModel.h"

@interface WTGoodsMessageContentView () <WTBubbleImageViewDelegate>

@property (nonatomic, strong) WTBubbleImageView *backImage;

@property (nonatomic, strong) UIImageView *goodsImg;

@property (nonatomic, strong) UILabel *goodsName;

@property (nonatomic, strong) UILabel *goodsPrice;

@end

@implementation WTGoodsMessageContentView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _backImage = [[WTBubbleImageView alloc] init];
        _backImage.delegate = self;
        [self addSubview:_backImage];
        
        _goodsImg = [[UIImageView alloc] init];
        _goodsImg.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImg.clipsToBounds = YES;
        _goodsImg.backgroundColor = [UIColor wtLightGrayColor];
        [self addSubview:_goodsImg];
        
        _goodsName = [[UILabel alloc] init];
        _goodsName.numberOfLines = 0;
        _goodsName.font = [UIFont systemFontOfSize:14];
        [self addSubview:_goodsName];
        
        _goodsPrice = [[UILabel alloc] init];
        _goodsPrice.font = [UIFont systemFontOfSize:16];
        _goodsPrice.textColor = [UIColor colorWithRed:255/255.0 green:75/255.0 blue:46/255.0 alpha:1.0];
        [self addSubview:_goodsPrice];
    }
    return self;
}

#pragma mark - Setter Cycle
- (void)setGoodsModel:(WTMessageModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    _backImage.frame = self.bounds;
    _backImage.isSend = _goodsModel.message.isOutgoingMsg;
    
    _goodsImg.frame = _goodsModel.goodImgFrame;
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:_goodsModel.goodsModel.goodImg] placeholderImage:nil];
    
    _goodsName.frame = _goodsModel.goodNameFrame;
    _goodsName.text = _goodsModel.goodsModel.goodName;
    
    _goodsPrice.frame = _goodsModel.goodPriceFrame;
    _goodsPrice.text = [NSString stringWithFormat:@"¥%.2f", _goodsModel.goodsModel.goodPrice];
}

#pragma mark - WTBubbleImageViewDelegate代理方法
- (void)onTouchUpInside
{
    if ([self.delegate respondsToSelector:@selector(onTapGoods)])
    {
        [self.delegate onTapGoods];
    }
}

- (void)onDelete
{
    if ([self.delegate respondsToSelector:@selector(onDeleteGoods)])
    {
        [self.delegate onDeleteGoods];
    }
}

- (void)onRevoke
{
    if ([self.delegate respondsToSelector:@selector(onRevokeGoods)])
    {
        [self.delegate onRevokeGoods];
    }
}

@end
